import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:hand_signature/signature.dart';
import 'package:image_editor/image_editor.dart' as image_editor;
import 'package:image_editor_plus/data/image_item.dart';
import 'package:image_editor_plus/data/layer.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/layers/background_blur_layer.dart';
import 'package:image_editor_plus/layers/background_layer.dart';
import 'package:image_editor_plus/layers/emoji_layer.dart';
import 'package:image_editor_plus/layers/image_layer.dart';
import 'package:image_editor_plus/layers/text_layer.dart';
import 'package:image_editor_plus/modules/all_emojies.dart';
import 'package:image_editor_plus/modules/colors_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:screenshot/screenshot.dart';

import '../popup.dart';
import '../styles.dart';
import 'image_filters.dart';
import 'text_editor_image.dart';

Map<String, String> _translations = {};

String i18n(String sourceString) =>
    _translations[sourceString.toLowerCase()] ?? sourceString;

class ImageEditor extends StatelessWidget {
  final Uint8List image;
  final String? savePath;
  final int maxLength;
  final bool allowGallery, allowCamera;

  const ImageEditor(
      {Key? key,
      required this.image,
      this.savePath,
      this.allowCamera = false,
      this.allowGallery = false,
      this.maxLength = 99,
      Color? appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleImageEditor(
      image: image,
      savePath: savePath,
      allowCamera: allowCamera,
      allowGallery: allowGallery,
    );
  }

  static i18n(Map<String, String> translations) {
    translations.forEach((key, value) {
      _translations[key.toLowerCase()] = value;
    });
  }
}

class SingleImageEditor extends StatefulWidget {
  final String? savePath;
  final Uint8List image;
  final List? imageList;
  final bool allowCamera, allowGallery;

  const SingleImageEditor({
    Key? key,
    this.savePath,
    required this.image,
    this.imageList,
    this.allowCamera = false,
    this.allowGallery = false,
  }) : super(key: key);

  @override
  _SingleImageEditorState createState() => _SingleImageEditorState();
}

class _SingleImageEditorState extends State<SingleImageEditor> {
  ImageItem currentImage = ImageItem();
  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();
  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void dispose() {
    layers.clear();
    super.dispose();
  }

  List<Widget> get filterActions {
    return [
      const Spacer(),
      IconButton(
        icon: Icon(
          Icons.undo,
          color: layers.length > 1 || removedLayers.isNotEmpty ? white : grey,
        ),
        onPressed: () {
          if (removedLayers.isNotEmpty) {
            layers.add(removedLayers.removeLast());
            setState(() {});
            return;
          }
          if (layers.length <= 1) return; // do not remove image layer
          undoLayers.add(layers.removeLast());
          setState(() {});
        },
      ).paddingSymmetric(horizontal: 8),
      IconButton(
        icon: Icon(Icons.redo, color: undoLayers.isNotEmpty ? white : grey),
        onPressed: () {
          if (undoLayers.isEmpty) return;
          layers.add(undoLayers.removeLast());
          setState(() {});
        },
      ).paddingSymmetric(horizontal: 8),
      IconButton(
        icon: const Icon(Icons.check),
        onPressed: () async {
          resetTransformation();
          var path = await screenshotController
              .captureAndSave(generatePath(widget.savePath!, 'upload'));
          Get.back(result: File(path!));
        },
      ).paddingSymmetric(horizontal: 8),
    ];
  }

  String generatePath(String srcFilePath, String key) {
    Get.log(srcFilePath);
    var list = srcFilePath.split('/');
    int length = list.length;
    String path = '';
    for (var i = 0; i < length - 1; i++) {
      path += '/${list[i]}';
    }
    Get.log(path);
    return path;
  }

  @override
  void initState() {
    loadImage(widget.image);
    super.initState();
  }

  double flipValue = 0;
  int rotateValue = 0;
  double x = 0;
  double y = 0;
  double z = 0;
  double lastScaleFactor = 1, scaleFactor = 1;
  double widthRatio = 1, heightRatio = 1, pixelRatio = 1;

  resetTransformation() {
    scaleFactor = 1;
    x = 0;
    y = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    viewportSize = MediaQuery.of(context).size;
    var layersStack = Stack(
      children: layers.map((layerItem) {
        if (layerItem is BackgroundLayerData) {
          return BackgroundLayer(
            layerData: layerItem,
            onUpdate: () {
              setState(() {});
            },
          );
        }
        if (layerItem is ImageLayerData) {
          return ImageLayer(
            layerData: layerItem,
            onUpdate: () {
              setState(() {});
            },
          );
        }
        if (layerItem is BackgroundBlurLayerData && layerItem.radius > 0) {
          return BackgroundBlurLayer(
            layerData: layerItem,
          );
        }
        if (layerItem is EmojiLayerData) {
          return EmojiLayer(layerData: layerItem);
        }
        if (layerItem is TextLayerData) {
          return TextLayer(
            layerData: layerItem,
            onUpdate: () {
              setState(() {});
            },
          );
        }
        return Container();
      }).toList(),
    );
    widthRatio = currentImage.width / viewportSize.width;
    heightRatio = currentImage.height / viewportSize.height;
    pixelRatio = math.max(heightRatio, widthRatio);
    return Theme(
      data: Styles.imageEditorTheme,
      child: Scaffold(
        key: scaf,
        appBar: AppBar(actions: filterActions),
        body: Center(
          child: SizedBox(
            height: currentImage.height / pixelRatio,
            width: currentImage.width / pixelRatio,
            child: Screenshot(
              controller: screenshotController,
              child: RotatedBox(
                quarterTurns: rotateValue,
                child: Transform(
                  transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, y,
                      0, 1 / scaleFactor)
                    ..rotateY(flipValue),
                  alignment: FractionalOffset.center,
                  child: layersStack,
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 86 + MediaQuery.of(context).padding.bottom,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: 10),
            ],
          ),
          child: SafeArea(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                BottomButton(
                  icon: Icons.edit,
                  text: 'Brush',
                  onTap: () async {
                    var drawing = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageEditorDrawing(
                          image: currentImage.image,
                        ),
                      ),
                    );
                    if (drawing != null) {
                      undoLayers.clear();
                      removedLayers.clear();
                      layers.add(
                        ImageLayerData(
                          image: ImageItem(drawing),
                        ),
                      );
                      setState(() {});
                    }
                  },
                ),
                BottomButton(
                  icon: Icons.text_fields,
                  text: 'Text',
                  onTap: () async {
                    TextLayerData? layer = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TextEditorImage(),
                      ),
                    );
                    if (layer == null) return;
                    undoLayers.clear();
                    removedLayers.clear();
                    layers.add(layer);
                    setState(() {});
                  },
                ),
                BottomButton(
                  icon: Icons.flip,
                  text: 'Flip',
                  onTap: () {
                    setState(() {
                      flipValue = flipValue == 0 ? math.pi : 0;
                    });
                  },
                ),
                BottomButton(
                  icon: Icons.rotate_left,
                  text: 'Rotate left',
                  onTap: () {
                    var t = currentImage.width;
                    currentImage.width = currentImage.height;
                    currentImage.height = t;
                    rotateValue--;
                    setState(() {});
                  },
                ),
                BottomButton(
                  icon: Icons.rotate_right,
                  text: 'Rotate right',
                  onTap: () {
                    var t = currentImage.width;
                    currentImage.width = currentImage.height;
                    currentImage.height = t;
                    rotateValue++;
                    setState(() {});
                  },
                ),
                BottomButton(
                  icon: Icons.blur_on,
                  text: 'Blur',
                  onTap: () {
                    var blurLayer = BackgroundBlurLayerData(
                      color: Colors.transparent,
                      radius: 0.0,
                      opacity: 0.0,
                    );
                    undoLayers.clear();
                    removedLayers.clear();
                    layers.add(blurLayer);
                    setState(() {});
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                      ),
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setS) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10)),
                              ),
                              padding: const EdgeInsets.all(20),
                              height: 400,
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      i18n('Slider Filter Color').toUpperCase(),
                                    ),
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 20.0),
                                  Text(i18n('Slider Color')),
                                  const SizedBox(height: 10),
                                  Row(children: [
                                    Expanded(
                                      child: BarColorPicker(
                                        width: 300,
                                        thumbColor: white,
                                        cornerRadius: 10,
                                        pickMode: PickMode.color,
                                        colorListener: (int value) {
                                          setS(() {
                                            setState(() {
                                              blurLayer.color = Color(value);
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                    TextButton(
                                      child: Text(i18n('Reset')),
                                      onPressed: () {
                                        setState(() {
                                          setS(() {
                                            blurLayer.color =
                                                Colors.transparent;
                                          });
                                        });
                                      },
                                    )
                                  ]),
                                  const SizedBox(height: 5.0),
                                  Text(i18n('Blur Radius')),
                                  const SizedBox(height: 10.0),
                                  Row(children: [
                                    Expanded(
                                      child: Slider(
                                        activeColor: white,
                                        inactiveColor: Colors.grey,
                                        value: blurLayer.radius,
                                        min: 0.0,
                                        max: 10.0,
                                        onChanged: (v) {
                                          setS(() {
                                            setState(() {
                                              blurLayer.radius = v;
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                    TextButton(
                                      child: Text(i18n('Reset')),
                                      onPressed: () {
                                        setS(() {
                                          setState(() {
                                            blurLayer.color = Colors.white;
                                          });
                                        });
                                      },
                                    )
                                  ]),
                                  const SizedBox(height: 5.0),
                                  Text(i18n('Color Opacity')),
                                  const SizedBox(height: 10.0),
                                  Row(children: [
                                    Expanded(
                                      child: Slider(
                                        activeColor: white,
                                        inactiveColor: Colors.grey,
                                        value: blurLayer.opacity,
                                        min: 0.00,
                                        max: 1.0,
                                        onChanged: (v) {
                                          setS(() {
                                            setState(() {
                                              blurLayer.opacity = v;
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                    TextButton(
                                      child: Text(i18n('Reset')),
                                      onPressed: () {
                                        setS(() {
                                          setState(() {
                                            blurLayer.opacity = 0.0;
                                          });
                                        });
                                      },
                                    )
                                  ]),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                BottomButton(
                  icon: Icons.photo,
                  text: 'Filter',
                  onTap: () async {
                    resetTransformation();
                    for (int i = 1; i < layers.length; i++) {
                      if (layers[i] is BackgroundLayerData) {
                        layers.removeAt(i);
                        break;
                      }
                    }
                    setState(() {});
                    Popup.loading();
                    var data = await screenshotController.capture(
                        pixelRatio: pixelRatio);
                    Popup.pop();
                    Uint8List? editedImage = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VImageFilters(
                          image: data!,
                        ),
                      ),
                    );
                    if (editedImage == null) return;
                    removedLayers.clear();
                    undoLayers.clear();
                    var layer = BackgroundLayerData(
                      file: ImageItem(editedImage),
                    );
                    layers.insert(1, layer);
                    await layer.file.status;
                    setState(() {});
                  },
                ),
                BottomButton(
                  icon: Icons.emoji_emotions_outlined,
                  text: 'Emoji',
                  onTap: () async {
                    EmojiLayerData? layer = await showModalBottomSheet(
                      context: context,
                      backgroundColor: black,
                      builder: (BuildContext context) {
                        return const Emojies();
                      },
                    );
                    if (layer == null) return;
                    undoLayers.clear();
                    removedLayers.clear();
                    layers.add(layer);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadImage(dynamic imageFile) async {
    try {
      await currentImage.load(imageFile);
    } catch (e) {
      Get.log('Error load image when first open $e');
    }
    layers.clear();
    layers.add(BackgroundLayerData(
      file: currentImage,
    ));
    setState(() {});
  }
}

class BottomButton extends StatelessWidget {
  final VoidCallback? onTap, onLongPress;
  final IconData icon;
  final String text;

  const BottomButton({
    Key? key,
    this.onTap,
    this.onLongPress,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 8),
            Text(i18n(text)),
          ],
        ),
      ),
    );
  }
}

class FilterAppliedImage extends StatelessWidget {
  final Uint8List image;
  final ColorFilterGenerator filter;
  final BoxFit? fit;
  final Function(Uint8List)? onProcess;
  final double opacity;

  FilterAppliedImage({
    Key? key,
    required this.image,
    required this.filter,
    this.fit,
    this.onProcess,
    this.opacity = 1,
  }) : super(key: key) {
    if (onProcess != null) {
      if (filter.filters.isEmpty) {
        onProcess!(image);
        return;
      }

      final image_editor.ImageEditorOption option =
          image_editor.ImageEditorOption();
      option.addOption(image_editor.ColorOption(matrix: filter.matrix));
      image_editor.ImageEditor.editImage(
        image: image,
        imageEditorOption: option,
      ).then((result) {
        if (result != null) {
          onProcess!(result);
        }
      }).catchError((err, stack) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (filter.filters.isEmpty) return Image.memory(image, fit: fit);

    return Opacity(
      opacity: opacity,
      child: filter.build(
        Image.memory(image, fit: fit),
      ),
    );
  }
}

class ImageEditorDrawing extends StatefulWidget {
  final Uint8List image;

  const ImageEditorDrawing({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<ImageEditorDrawing> createState() => _ImageEditorDrawingState();
}

class _ImageEditorDrawingState extends State<ImageEditorDrawing> {
  Color pickerColor = Colors.white;
  Color currentColor = Colors.white;

  final control = HandSignatureControl(
    threshold: 3.0,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  List<CubicPath> undoList = [];
  bool skipNextEvent = false;
  List<Color> colorList = [
    Colors.black,
    Colors.white,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.purple,
    Colors.brown,
    Colors.indigo,
    Colors.indigo,
  ];

  void changeColor(Color color) {
    currentColor = color;
    setState(() {});
  }

  @override
  void initState() {
    control.addListener(() {
      if (control.hasActivePath) return;
      if (skipNextEvent) {
        skipNextEvent = false;
        return;
      }
      undoList = [];
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Styles.imageEditorTheme,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                Navigator.pop(context);
              },
            ).paddingSymmetric(horizontal: 8),
            const Spacer(),
            IconButton(
              icon: Icon(
                Icons.undo,
                color: control.paths.isNotEmpty ? white : white.withAlpha(80),
              ),
              onPressed: () {
                if (control.paths.isEmpty) return;
                skipNextEvent = true;
                undoList.add(control.paths.last);
                control.stepBack();
                setState(() {});
              },
            ).paddingSymmetric(horizontal: 8),
            IconButton(
              icon: Icon(
                Icons.redo,
                color: undoList.isNotEmpty ? white : white.withAlpha(80),
              ),
              onPressed: () {
                if (undoList.isEmpty) return;
                control.paths.add(undoList.removeLast());
                setState(() {});
              },
            ).paddingSymmetric(horizontal: 8),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                if (control.paths.isEmpty) return Navigator.pop(context);
                var data = await control.toImage(color: currentColor);
                return Navigator.pop(context, data!.buffer.asUint8List());
              },
            ).paddingSymmetric(horizontal: 8),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: currentColor == black ? white : black,
          child: HandSignature(
            control: control,
            color: currentColor,
            width: 1.0,
            maxWidth: 10.0,
            type: SignatureDrawType.shape,
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 80,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(blurRadius: 10),
              ],
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                ColorButton(
                  color: Colors.yellow,
                  onTap: (color) {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return Container(
                          color: Colors.black87,
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.only(top: 16),
                              child: HueRingPicker(
                                pickerColor: pickerColor,
                                onColorChanged: changeColor,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                for (int i = 0; i < colorList.length; i++)
                  ColorButton(
                    color: colorList[i],
                    onTap: (color) => changeColor(color),
                    isSelected: colorList[i] == currentColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ColorButton extends StatelessWidget {
  final Color color;
  final Function onTap;
  final bool isSelected;

  const ColorButton({
    Key? key,
    required this.color,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: 34,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 23),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.white54,
          width: isSelected ? 2 : 1,
        ),
      ),
    ).onTap(() {
      onTap(color);
    });
  }
}

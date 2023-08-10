import 'package:flutter/material.dart';
import 'package:image_editor_plus/data/layer.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/modules/colors_picker.dart';

class TextEditorImage extends StatefulWidget {
  const TextEditorImage({Key? key}) : super(key: key);

  @override
  State<TextEditorImage> createState() => _TextEditorImageState();
}

/// Image filter for ImageEditor.
/// Use for add text into the image.
class _TextEditorImageState extends State<TextEditorImage> {
  TextEditingController name = TextEditingController();
  Color currentColor = Colors.black;
  double slider = 32.0;
  TextAlign align = TextAlign.left;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Theme(
      data: ImageEditor.theme,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.format_align_left,
                  color: align == TextAlign.left
                      ? Colors.white
                      : Colors.white.withAlpha(80)),
              onPressed: () {
                setState(() {
                  align = TextAlign.left;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.format_align_center,
                  color: align == TextAlign.center
                      ? Colors.white
                      : Colors.white.withAlpha(80)),
              onPressed: () {
                setState(() {
                  align = TextAlign.center;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.format_align_right,
                  color: align == TextAlign.right
                      ? Colors.white
                      : Colors.white.withAlpha(80)),
              onPressed: () {
                setState(() {
                  align = TextAlign.right;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.pop(
                  context,
                  TextLayerData(
                    background: Colors.transparent,
                    text: name.text,
                    color: currentColor,
                    size: slider.toDouble(),
                    align: align,
                  ),
                );
              },
              padding: const EdgeInsets.all(15),
            )
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: size.height / 2.2,
                  child: TextField(
                    controller: name,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Insert Your Message',
                      hintStyle: TextStyle(color: Colors.white),
                      alignLabelWithHint: true,
                    ),
                    scrollPadding: const EdgeInsets.all(20.0),
                    keyboardType: TextInputType.multiline,
                    minLines: 5,
                    maxLines: 99999,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    autofocus: true,
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Text(i18n('Slider Color')),
                      Row(children: [
                        Expanded(
                          child: BarColorPicker(
                            width: 300,
                            thumbColor: Colors.white,
                            cornerRadius: 10,
                            pickMode: PickMode.color,
                            colorListener: (int value) {
                              setState(() {
                                currentColor = Color(value);
                              });
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(i18n('Reset')),
                        ),
                      ]),
                      //   SizedBox(height: 20.0),
                      Text(i18n('Slider White Black Color')),
                      //   SizedBox(height: 10.0),
                      Row(children: [
                        Expanded(
                          child: BarColorPicker(
                            width: 300,
                            thumbColor: Colors.white,
                            cornerRadius: 10,
                            pickMode: PickMode.grey,
                            colorListener: (int value) {
                              setState(() {
                                currentColor = Color(value);
                              });
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(i18n('reset')),
                        )
                      ]),
                      Container(
                        color: Colors.black,
                        child: Column(
                          children: [
                            const SizedBox(height: 10.0),
                            Center(
                              child: Text(
                                i18n('Size Adjust').toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Slider(
                                activeColor: Colors.white,
                                inactiveColor: Colors.grey,
                                value: slider,
                                min: 0.0,
                                max: 100.0,
                                onChangeEnd: (v) {
                                  setState(() {
                                    slider = v;
                                  });
                                },
                                onChanged: (v) {
                                  setState(() {
                                    slider = v;
                                  });
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'loading.dart';

List<CameraDescription> cameras = [];

/// Camera widget, you can access it from class PeppermintUtility.
class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController camera;
  bool camInitialized = false;
  int selectedCamera = 0;
  String imageFile = '';

  @override
  void initState() {
    init();
    super.initState();
  }

  /// check the list of available camera.
  init() async {
    cameras = await availableCameras();
    selectCamera();
  }

  /// Trigger dispose camera after it is removed from widget tree.
  @override
  void dispose() {
    disposeCamera();
    super.dispose();
  }

  disposeCamera() async {
    await camera.dispose();
  }

  /// Select front or back camera
  selectCamera() {
    selectedCamera = selectedCamera == 1 ? 0 : 1;
    camera = CameraController(
      cameras[selectedCamera],
      ResolutionPreset.max,
      enableAudio: false,
    );
    camera.initialize().then((_) {
      camInitialized = true;
      setState(() {});
    });
  }

  Future<void> onNewCameraSelected() async {
    camInitialized = false;
    setState(() {});
    await camera.dispose();
    selectCamera();
  }

  /// Take an Image from camera and then
  /// crop it, also read it as a byte and will
  /// Returns a Future<Uint8List> that completes
  /// with the list of bytes that is the contents of the file.
  void onTakePictureButtonPressed() async {
    takePicture().then((XFile? file) async {
      if (file == null) return;
      String result = await cropSquare(file.path);
      final img.Image capturedImage = img.decodeImage(
        await File(result).readAsBytes(),
      )!;
      final img.Image orientedImage = img.bakeOrientation(capturedImage);
      File newFile = await File(result).writeAsBytes(
        img.encodeJpg(orientedImage),
      );
      Get.back(result: newFile);
    });
  }

  /// Take a picture with device camera
  Future<XFile?> takePicture() async {
    if (!camera.value.isInitialized) {
      return null;
    }
    if (camera.value.isTakingPicture) {
      return null;
    }
    try {
      XFile file = await camera.takePicture();
      return file;
    } on CameraException {
      return null;
    }
  }

  /// Crop an image after picture taken by camera
  /// and return as a File path
  Future<String> cropSquare(String srcFilePath) async {
    var bytes = await File(srcFilePath).readAsBytes();
    img.Image? src = img.decodeImage(bytes);
    var cropSize = min(src!.width, src.height);
    int offsetX = (src.width - min(src.width, src.height)) ~/ 2;
    int offsetY = (src.height - min(src.width, src.height)) ~/ 2;
    img.Image destImage = img.copyCrop(
      src,
      x: offsetX,
      y: offsetY,
      width: cropSize,
      height: cropSize,
    );
    if (selectedCamera == 1) destImage = img.flipHorizontal(destImage);
    var jpg = img.encodeJpg(destImage);
    var list = srcFilePath.split('/');
    int length = list.length;
    String path = '';
    for (var i = 0; i < length - 1; i++) {
      path += '${list[i]}/';
    }
    path += 'x${list[length - 1]}';
    File result = await File(path).writeAsBytes(jpg);
    return result.path;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double zoom = 1.0;
    double scaleFactor = 1.0;
    return Scaffold(
      body: !camInitialized
          ? const PeppermintLoading()
          : Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Center(
                  child: CameraPreview(camera),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,
                      height: (size.height - size.width) / 2,
                      color: Colors.black26,
                    ),
                    Container(
                      width: double.infinity,
                      height: (size.height - size.width) / 2,
                      color: Colors.black26,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Spacer(),
                      Expanded(
                        child: InkWell(
                          onTap: onTakePictureButtonPressed,
                          child: const CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Color(0xff181A26),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: selectCamera,
                          child: const Icon(
                            Icons.flip_camera_android_rounded,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: (size.height - size.width) / 2,
                  child: SizedBox(
                    height: size.width,
                    width: size.width,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Divider(color: Colors.white60, height: 5, thickness: 1),
                        Divider(color: Colors.white60, height: 5, thickness: 1),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: (size.height - size.width) / 2,
                  child: SizedBox(
                    height: size.width,
                    width: size.width,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        VerticalDivider(
                          color: Colors.white60,
                          width: 5,
                          thickness: 1,
                        ),
                        VerticalDivider(
                          color: Colors.white60,
                          width: 5,
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 35,
                    left: 8,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.black,
                          )),
                    )),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onScaleStart: (details) {
                    zoom = scaleFactor;
                  },
                  onScaleUpdate: (details) {
                    scaleFactor = zoom * details.scale;
                    camera.setZoomLevel(scaleFactor);
                  },
                )
              ],
            ),
    );
  }
}

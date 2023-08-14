import 'dart:io';
import 'package:example/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';

/// Utilites page.
/// Contain many of example utilities
/// That you can use with the SDK.
class UtilitiesPage extends StatefulWidget {
  const UtilitiesPage({Key? key}) : super(key: key);

  @override
  State<UtilitiesPage> createState() => _UtilitiesPageState();
}

class _UtilitiesPageState extends State<UtilitiesPage> {
  String? qrCode;
  String? scanResult;
  File? fileImage;
  File? fileVideo;
  TextEditingController controller = TextEditingController();

  /// Upload image from camera
  /// You can set edit to false or true to apply the editor
  /// and will show using VImageLoader widget
  _imageFromCamera() async {
    File? file = await PeppermintUtility.getImageFromCamera(edit: true);
    setState(() {
      fileImage = file;
    });
  }

  /// Upload image from Galery
  /// You can set edit to false or true to apply the squareCrop
  /// and will show using VImageLoader widget
  _imageFromGalery() async {
    File? file = await PeppermintUtility.getImageFromGallery(squareCrop: true);
    setState(() {
      fileImage = file;
    });
  }

  /// Upload media from explorer
  /// You can set edit to false or true to apply the squareCrop
  /// and will show using VImageLoader widget
  _imageFromExplorer() async {
    File? file = await PeppermintUtility.getMediaFromExplorer(squareCrop: true);
    setState(() {
      fileImage = file;
    });
  }

  /// Upload video from Galery
  /// and will show using MediaGram widget
  _getVideoFromGallery() async {
    File? file = await PeppermintUtility.getVideoFromGallery();
    setState(() {
      fileVideo = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilities Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Code of your QR file ${qrCode ?? ''}'),
              const SizedBox(height: 16.0),
              Text('Scanner result ${scanResult ?? ''}'),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'insert url to launch here',
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.green,
                child: Column(
                  children: [
                    fileImage != null
                        ? VImageLoader(
                            file: fileImage,
                          )
                        : const Text(
                            'Image will appear here',
                            textAlign: TextAlign.center,
                          ),
                    const SizedBox(height: 16.0),
                    MyButton(
                        text: 'Image from Galery', onTap: _imageFromGalery),
                    const SizedBox(height: 16.0),
                    MyButton(
                        text: 'Image from Camera', onTap: _imageFromCamera),
                    const SizedBox(height: 16.0),
                    MyButton(
                        text: 'Image from Explorer', onTap: _imageFromExplorer),
                    const SizedBox(height: 16.0),
                    fileVideo != null
                        ? MediaGram(
                            file: fileVideo,
                            grid: false,
                            fileType: 'video',
                          )
                        : const Text(
                            'Video will appear here',
                            textAlign: TextAlign.center,
                          ),
                    const SizedBox(height: 16.0),
                    MyButton(
                        text: 'Video from Galery', onTap: _getVideoFromGallery),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

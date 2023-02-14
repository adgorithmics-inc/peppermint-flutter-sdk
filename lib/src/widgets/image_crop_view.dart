import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'loading.dart';

/// Image crop view
/// Cropping image to square.
/// Square or 1:1 ratio is required as most common ratio for NFT.
class ImageCropView extends StatefulWidget {
  final File file;

  const ImageCropView(this.file, {Key? key}) : super(key: key);

  @override
  _ImageCropViewState createState() => _ImageCropViewState();
}

class _ImageCropViewState extends State<ImageCropView> {
  final cropKey = GlobalKey<CropState>();
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: _buildCroppingImage(),
        ),
      ),
    );
  }

  Widget _buildCroppingImage() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Crop.file(
            widget.file,
            key: cropKey,
            aspectRatio: 1.0,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          alignment: AlignmentDirectional.center,
          child: TextButton(
            child: Text(
              'Crop Image',
              style: Theme.of(context)
                  .textTheme
                  .button
                  ?.copyWith(color: Colors.white),
            ),
            onPressed: () => _cropImage(),
          ),
        ),
        if (loading) const PeppermintLoading(),
      ],
    );
  }

  Future<void> _cropImage() async {
    if (loading) return;
    loading = true;
    setState(() {});
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: widget.file,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();
    Navigator.pop(context, file);
  }
}

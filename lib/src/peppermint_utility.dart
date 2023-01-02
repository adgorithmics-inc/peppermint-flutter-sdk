import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:peppermint_sdk/src/peppermint_constants.dart';
import 'package:peppermint_sdk/src/widgets/image_crop_view.dart';

class PeppermintUtility {
  PeppermintUtility._();

  /// Trim private key string.
  /// This is used because web3dart package sometimes create unwanted 00
  /// in front of generated private key string
  static String getPrettyPrivateKey(privateKey) {
    if (privateKey == null) return privateKey;
    if (privateKey.length > 64) {
      privateKey =
          privateKey.substring(privateKey.length - 64, privateKey.length);
    }
    return privateKey;
  }

  static String getFileType(String extension) {
    extension = extension.toLowerCase();
    switch (extension) {
      case '.mp4':
        return 'video';
      case '.mov':
        return 'video';
      case '.mp3':
        return 'audio';
      default:
        return 'image';
    }
  }

  static Future<File?> getMediaFromExplorer(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: PeppermintConstants.fileTypes,
    );
    if (result != null) {
      String fileType = PeppermintUtility.getFileType(
          path.extension(result.files.single.path!));
      if (fileType == 'image') {
        /// Crop square image

        File? cropped = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    ImageCropView(File(result.files.single.path!))));
        return cropped;
      } else {
        return File(result.files.single.path!);
      }
    }
    return null;
  }

  static Future<File?> getImageFromGallery(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      File? cropped = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ImageCropView(File(result.files.single.path!))));
      return cropped;
    }
    return null;
  }

  static Future<File?> getVideoFromGallery(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
}

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as path;
import 'package:peppermint_sdk/src/peppermint_constants.dart';
import 'widgets/camera_view.dart';
import 'widgets/photo_filters/image_editor.dart';

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

  /// Get file type based on extension
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

  /// Open file explorer and select media
  static Future<File?> getMediaFromExplorer({bool squareCrop = true}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: PeppermintConstants.fileTypes,
    );
    File? file;
    if (result != null) {
      String fileType = PeppermintUtility.getFileType(
          path.extension(result.files.single.path!));
      if (fileType == 'image' && squareCrop) {
        String? croppedFilePath =
            await cropImageWidget(result.files.single.path!);
        file = croppedFilePath != null ? File(croppedFilePath) : null;
      } else {
        file = File(result.files.single.path!);
      }
    }
    return file;
  }

  /// Get image from gallery
  static Future<File?> getImageFromGallery({bool squareCrop = true}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    File? file;
    if (result != null) {
      if (squareCrop) {
        String? croppedFilePath =
            await cropImageWidget(result.files.single.path!);
        file = croppedFilePath != null ? File(croppedFilePath) : null;
      } else {
        file = File(result.files.single.path!);
      }
    }
    return file;
  }

  /// Get video from gallery
  static Future<File?> getVideoFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  /// Get image from camera, it is cropped square and go to image editor first
  static Future<File?> getImageFromCamera({bool edit = true}) async {
    File? file = await Get.to(() => const CameraView());
    if (file != null) {
      if (edit) {
        Uint8List imageData = file.readAsBytesSync();
        file = await Get.to(
          () => ImageEditor(
            image: imageData,
            savePath: file!.path,
            allowCamera: true,
            allowGallery: true,
          ),
        );
      }
    }
    return file;
  }

  /// Generate random name for new contract.
  static String generateContractName() {
    String name =
        '${PeppermintConstants.adjectives[Random().nextInt(PeppermintConstants.adjectives.length)].capitalizeFirst} ${PeppermintConstants.animals[Random().nextInt(PeppermintConstants.animals.length)].capitalizeFirst}';
    if (name.length > 32) {
      name = name.substring(0, 32);
    }

    return name;
  }

  static Future<String?> cropImageWidget(String path) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioLockEnabled: true,
        ),
      ],
    );
    return croppedFile?.path;
  }
}

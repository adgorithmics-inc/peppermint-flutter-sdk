import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:peppermint_sdk/peppermint_sdk.dart';
import 'package:peppermint_sdk/src/peppermint_constants.dart';
import 'package:peppermint_sdk/src/widgets/image_crop_view.dart';
import 'package:scan/scan.dart';
import 'package:url_launcher/url_launcher.dart';
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
  static Future<File?> getMediaFromExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: PeppermintConstants.fileTypes,
    );
    if (result != null) {
      String fileType = PeppermintUtility.getFileType(
          path.extension(result.files.single.path!));
      if (fileType == 'image') {
        /// Crop square image

        File? cropped =
            await Get.to(() => ImageCropView(File(result.files.single.path!)));
        return cropped;
      } else {
        return File(result.files.single.path!);
      }
    }
    return null;
  }

  /// Get image from gallery
  static Future<File?> getImageFromGallery({bool squareCrop = true}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    File? file;

    if (result != null) {
      if (squareCrop) {
        File? cropped =
            await Get.to(() => ImageCropView(File(result.files.single.path!)));
        file = cropped;
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
    File? image;
    File? file = await Get.to(() => const CameraView());
    if (file != null) {
      if (edit) {
        Uint8List imageData = file.readAsBytesSync();
        image = await Get.to(
          () => ImageEditor(
            image: imageData,
            savePath: file.path,
            allowCamera: true,
            allowGallery: true,
          ),
        );
      }
    }
    return image;
  }

  /// Scan QR from image uploaded.
  static Future<QRResult> getQRFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      String? value = await Scan.parse(result.files.single.path!);
      if (value == null) {
        return QRResult(
            success: false,
            result: 'We could not detect your QR in this image');
      }
      return QRResult(success: true, result: value);
    }
    return QRResult(success: true);
  }

  /// launch url via browser.
  static launchBrowser(String url) async {
    bool success = true;
    if (!url.contains('http')) {
      url = 'http://$url';
    }
    if (url.contains('facebook.com')) {
      url = 'fb://facewebmodal/f?href=$url';
    }
    if (await canLaunchUrl(Uri.parse(url))) {
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        success = false;
      }
    } else {
      success = false;
    }
    return success;
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
}

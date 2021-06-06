

import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:images_picker/images_picker.dart';

mixin PickerMixin{
  FutureOr<List<PlatformFile>> getImagePicker() async {
    FilePickerResult? images = await FilePicker.platform.pickFiles(
        allowMultiple: true, type: FileType.image);
    return images?.files ?? [];
  }

  Future<List<PlatformFile>> getVideoPicker() async {
    FilePickerResult? video = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.video,
      withReadStream: true
    );
    return video?.files ?? [];
  }

  Future<List<PlatformFile>> getAudioPicker() async {
    FilePickerResult? audio = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.audio,
    );
    return audio?.files ?? [];
  }

  Future<List<PlatformFile>> getFilePicker() async {
    // FlutterDocumentPickerParams? params=FlutterDocumentPickerParams(
    //   allowedMimeTypes: [
    //     "text/plain"
    //   ],
    // );
    // await FlutterDocumentPicker.openDocument(params:params);
    FilePickerResult? audio = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ["ppt","pptx","docx","pdf","txt","apk","doc",],
    );
    return audio?.files ?? [];
  }

  Future<List<Media>> getImagesPickerCamera({CropType type=CropType.rect}) async {
    List<Media>? images= await ImagesPicker.openCamera(
      pickType: PickType.image,
      // cropOpt: CropOption(
      //   cropType: type
      // ),
    );
    return images??[];
  }
}

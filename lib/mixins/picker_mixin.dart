import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:images_picker/images_picker.dart';

mixin PickerMixin{
  FutureOr<List<PlatformFile>> getImagePicker() async {
    FilePickerResult images = await FilePicker.platform.pickFiles(
        allowMultiple: true, type: FileType.image, withReadStream: true);
    return images?.files;
  }

  FutureOr<List<PlatformFile>> getVideoPicker() async {
    FilePickerResult video = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.video,
    );
    return video?.files;
  }

  FutureOr<List<PlatformFile>> getAudioPicker() async {
    FilePickerResult audio = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.audio,
    );
    return audio?.files;
  }

  FutureOr<List<PlatformFile>> getFilePicker() async {
    FilePickerResult audio = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ["ppt","pptx","docx","pdf","txt","apk",],
    );
    return audio?.files;
  }

  FutureOr<List<Media>> getImgesPickerCamera({CropType type=CropType.rect}) async {
    List<Media> images= await ImagesPicker.openCamera(
      pickType: PickType.image,
      // cropOpt: CropOption(
      //   cropType: type
      // ),
    );
    return images;
  }
}

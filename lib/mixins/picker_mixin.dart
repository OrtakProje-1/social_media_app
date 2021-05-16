import 'package:file_picker/file_picker.dart';

mixin PickerMixin{
  Future<List<PlatformFile>> getImagePicker() async {
    FilePickerResult images = await FilePicker.platform.pickFiles(
        allowMultiple: true, type: FileType.image, withReadStream: true);
    print("path= " + images.files[0]?.path);
    return images.files;
  }

  Future<List<PlatformFile>> getVideoPicker() async {
    FilePickerResult video = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.video,
    );
    return video?.files;
  }

  Future<List<PlatformFile>> getAudioPicker() async {
    FilePickerResult audio = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.audio,
    );
    return audio?.files;
  }
}
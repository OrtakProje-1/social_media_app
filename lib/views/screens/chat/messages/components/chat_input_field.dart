import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/mixins/picker_mixin.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/messagesBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';

import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/chat/models/chat.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';
import 'package:social_media_app/views/screens/detail_screens/images_details.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({Key key, this.rUid, this.noMessage = false})
      : super(key: key);
  final String rUid;
  final bool noMessage;

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> with PickerMixin {
  TextEditingController message = TextEditingController();
  bool loading = false;
  String docId;
  @override
  Widget build(BuildContext context) {
    MessagesBlock messagesBlock = Provider.of<MessagesBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);
    UsersBlock usersBlock = Provider.of<UsersBlock>(context);
    docId = messagesBlock.getDoc(widget.rUid, userBlock.user.uid);
    return Column(
      children: [
        Divider(
          height: 1,
          color: kPrimaryColor.withOpacity(0.5),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding / 4,
            vertical: kDefaultPadding / 4,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 32,
                color: Color(0xFF087949).withOpacity(0.08),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  child: TextButton(
                    child: Icon(Icons.add, color: kPrimaryColor),
                    onPressed: () async {
                      FilesTyper fType = await showModal();
                      if (fType != null) {
                        print(fType.type.toString() +
                            " " +
                            fType.files.length.toString());
                            getFilesDetailsScreen(fType);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(90)),
                        primary: Colors.white,
                        elevation: 0,
                        onPrimary: kPrimaryColor.withOpacity(0.6)),
                  ),
                ),
                SizedBox(width: kDefaultPadding / 4),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: message,
                            cursorRadius: Radius.circular(8),
                            cursorColor: Colors.black87,
                            cursorWidth: 1.5,
                            decoration: InputDecoration(
                              hintText: "Mesajınız...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                  child: Icon(Icons.send_rounded, color: kPrimaryColor),
                  onPressed: () async {
                    if (!loading) if (message.text.length > 0) {
                      if (mounted) {
                        setState(() {
                          loading = true;
                        });
                      }
                      String mesaj = message.text;
                      message.clear();
                      int time = DateTime.now().millisecondsSinceEpoch;
                      if (widget.noMessage) {
                        MyUser my =
                            usersBlock.getUserFromUid(userBlock.user.uid);
                        MyUser rec = usersBlock.getUserFromUid(widget.rUid);

                        await messagesBlock.setChatCard(
                            userBlock.user.uid,
                            widget.rUid,
                            Chat(
                                lastMessage: mesaj,
                                name: rec.displayName,
                                image: rec.photoURL,
                                time: time,
                                senderUid: my.uid,
                                rUid: rec.uid));
                        await messagesBlock.setChatCard(
                            widget.rUid,
                            userBlock.user.uid,
                            Chat(
                                lastMessage: mesaj,
                                name: my.displayName,
                                image: my.photoURL,
                                time: time,
                                senderUid: my.uid,
                                rUid: rec.uid));
                      } else {
                        MyUser rec = usersBlock.getUserFromUid(widget.rUid);
                        MyUser my =
                            usersBlock.getUserFromUid(userBlock.user.uid);
                        await messagesBlock.updateChatCard(
                            userBlock.user.uid,
                            widget.rUid,
                            Chat(
                                lastMessage: mesaj,
                                name: rec.displayName,
                                image: rec.photoURL,
                                time: time,
                                senderUid: my.uid,
                                rUid: rec.uid));
                        await messagesBlock.updateChatCard(
                          widget.rUid,
                          userBlock.user.uid,
                          Chat(
                            lastMessage: mesaj,
                            name: rec.displayName,
                            image: rec.photoURL,
                            time: time,
                            rUid: rec.uid,
                            senderUid: my.uid,
                          ),
                        );
                      }
                      await messagesBlock.addMessage(
                        docId,
                        ChatMessage(
                          messageStatus: MessageStatus.not_view,
                          messageTime: time,
                          messageType: ChatMessageType.text,
                          text: mesaj,
                          isRemoved: false,
                          senderUid: userBlock.user.uid,
                        ),
                      );
                      message.clear();
                      if (mounted) {
                        setState(() {
                          loading = false;
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90)),
                      primary: Colors.white,
                      elevation: 0,
                      onPrimary: kPrimaryColor.withOpacity(0.5)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getFilesDetailsScreen(FilesTyper filesTyper)async{
    switch (filesTyper.type) {
      case ChatMessageType.image:
         await Navigate.pushPage(context,ImagesDetail(files:filesTyper.files));
        break;
      default:
    }
  }




  Future<FilesTyper> showModal() async {
    return await showModalBottomSheet<FilesTyper>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (c) {
        return Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: 250,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 3),
                child: Text(
                  "Dosya Türü Seçin",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white60,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                width: 150,
                height: 3,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    dosyaTipleri(
                      "Galeri",
                      Icons.photo_outlined,
                      imagePicker: true,
                      onPressed: () async {
                        List<PlatformFile> files = await getImagePicker();
                        Navigator.pop(
                            context,
                            files.isNotEmpty
                                ? FilesTyper(
                                    files: files, type: ChatMessageType.image)
                                : null);
                      },
                    ),
                    dosyaTipleri("Kamera", Icons.camera_alt_outlined,
                        imagePicker: true, onPressed: () {}),
                    dosyaTipleri("Ses", Icons.headset_outlined,
                        onPressed: () async {
                      List<PlatformFile> files = await getAudioPicker();
                      Navigator.pop(
                          context,
                          files.isNotEmpty
                              ? FilesTyper(
                                  files: files, type: ChatMessageType.audio)
                              : null);
                    }),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    dosyaTipleri("Döküman", Icons.insert_drive_file_outlined,
                        onPressed: () async {
                      List<PlatformFile> files = await getFilePicker();
                      Navigator.pop(
                          context,
                          files.isNotEmpty
                              ? FilesTyper(
                                  files: files, type: ChatMessageType.file)
                              : null);
                    }),
                    dosyaTipleri("Video", Icons.videocam_outlined,
                        onPressed: () async {
                      List<PlatformFile> files = await getVideoPicker();
                      Navigator.pop(
                          context,
                          files.isNotEmpty
                              ? FilesTyper(
                                  files: files, type: ChatMessageType.video)
                              : null);
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Column dosyaTipleri(
    String isim,
    IconData icon, {
    bool imagePicker = false,
    VoidCallback onPressed,
  }) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              elevation: 0,
              shadowColor: kPrimaryColor.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45)),
            ),
            onPressed: onPressed,
            child: Center(
              child: Icon(
                icon,
                color: kPrimaryColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 5,
          ),
          child: Text(
            isim,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
          ),
        ),
      ],
    );
  }
}

class FilesTyper {
  FilesTyper({this.files, this.type});

  final ChatMessageType type;
  final List<PlatformFile> files;
}

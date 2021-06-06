import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypton/crypton.dart' as crypt;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/mixins/picker_mixin.dart';
import 'package:social_media_app/mixins/bottom_sheet_mixin.dart';
import 'package:social_media_app/models/blocked_details.dart';
import 'package:social_media_app/models/media_reference.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/crypto_block.dart';
import 'package:social_media_app/providers/messagesBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';

import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/enum.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';
import 'package:social_media_app/views/screens/chat/models/sender_media_message.dart';
import 'package:social_media_app/views/screens/detail_screens/images_details.dart';
import 'package:social_media_app/views/screens/detail_screens/video_detail_screen.dart';
import 'package:social_media_app/views/screens/detail_screens/widgets/send_button.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification_receiver.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification_sender.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({Key? key, this.rUid, this.noMessage = false})
      : super(key: key);
  final String? rUid;
  final bool noMessage;

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField>
    with PickerMixin, BottomSheetMixin {
  TextEditingController message = TextEditingController();
  bool loading = false;
  String? docId;
  bool didIBlock = false;
  bool didHeBlock = false;
// JaDNxHLL6YUIgQEGraHk3xpYUvB2
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MessagesBlock messagesBlock = Provider.of<MessagesBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);
    UsersBlock usersBlock = Provider.of<UsersBlock>(context);
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    MyUser? rec = usersBlock.getUserFromUid(widget.rUid);
    MyUser? my = usersBlock.getUserFromUid(userBlock.user!.uid);
    docId = messagesBlock.getDoc(widget.rUid, userBlock.user!.uid);
    return StreamBuilder<List<BlockedDetails>>(
        stream: profileBlock.blockedUsers,
        initialData: profileBlock.blockedUsers.valueWrapper!.value,
        builder: (context, myBlocked) {
          didIBlock = myBlocked.data!.any((e) => e.blockedUid == rec!.uid!);
          return StreamBuilder<QuerySnapshot>(
              stream: profileBlock.streamBlockedUsers(rec!.uid!),
              builder: (context, heBlocked) {
                if (heBlocked.hasData) {
                  List<BlockedDetails> heBlockedDetails = heBlocked.data!.docs
                      .map((e) => BlockedDetails.fromMap(e.data()))
                      .toList();
                  didHeBlock =
                      heBlockedDetails.any((e) => e.blockedUid == my!.uid!);
                } else {
                  didHeBlock = false;
                }
                return Stack(
                  children: [
                    Column(
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
                                    child: Icon(Icons.add, color: Colors.white),
                                    onPressed: () async {
                                      FilesTyper? fType = await showModal();
                                      if (fType != null) {
                                        print(fType.type.toString() +
                                            " " +
                                            fType.files!.length.toString());
                                        SenderMediaMessage? senderMessage =
                                            await getFilesDetailsScreen(
                                                fType,
                                                usersBlock,
                                                userBlock.user!.uid);
                                        if (senderMessage != null) {
                                          print("mesaj= " +
                                              senderMessage.message! +
                                              "\ntype= ${senderMessage.type}\n urls= " +
                                              senderMessage.refs!.length
                                                  .toString());

                                          String recMesaj;
                                          String senderMesaj;
                                          if (rec.publicKey != null) {
                                            senderMesaj = CryptoBlock()
                                                .getPublicKey()
                                                .encrypt(
                                                    senderMessage.message!);
                                            recMesaj =
                                                crypt.RSAPublicKey.fromString(
                                                        rec.publicKey!)
                                                    .encrypt(
                                                        senderMessage.message!);
                                          } else {
                                            senderMesaj = message.text;
                                            recMesaj = message.text;
                                          }

                                          await messagesBlock.addMessage(
                                            my!,
                                            rec,
                                            widget.noMessage,
                                            ChatMessage(
                                              isRemoved: false,
                                              messageStatus:
                                                  MessageStatus.not_view,
                                              messageTime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              messageType: senderMessage.type,
                                              sender: NSender(
                                                uid: my.uid,
                                                name: my.displayName,
                                                photoURL: my.photoURL,
                                              ),
                                              receiver: NReceiver(
                                                rUid: rec.uid,
                                                rToken: rec.token,
                                              ),
                                              recCryptedText: recMesaj,
                                              senderCryptedText: senderMesaj,
                                              audio: senderMessage.type ==
                                                      ChatMessageType.audio
                                                  ? senderMessage.refs![0]
                                                  : null,
                                              video: senderMessage.type ==
                                                      ChatMessageType.video
                                                  ? senderMessage.refs![0]
                                                  : null,
                                              images: senderMessage.type ==
                                                      ChatMessageType.image
                                                  ? senderMessage.refs
                                                  : null,
                                              file: senderMessage.type ==
                                                      ChatMessageType.file
                                                  ? senderMessage.refs![0]
                                                  : null,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(90)),
                                        primary: recMesColor,
                                        elevation: 0,
                                        onPrimary: Colors.white),
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
                                            cursorColor: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color,
                                            cursorWidth: 1.5,
                                            decoration: InputDecoration(
                                              hintText: "Mesajınız...",
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (s) {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SendButton(
                                  iconColor: Colors.white,
                                  onPressed: () async {
                                    if (!loading) if (message.text.length > 0) {
                                      if (mounted) {
                                        setState(() {
                                          loading = true;
                                        });
                                      }
                                      String recMesaj;
                                      String senderMesaj;
                                      if (rec.publicKey != null) {
                                        senderMesaj = CryptoBlock()
                                            .getPublicKey()
                                            .encrypt(message.text);
                                        recMesaj =
                                            crypt.RSAPublicKey.fromString(
                                                    rec.publicKey!)
                                                .encrypt(message.text);
                                      } else {
                                        senderMesaj = message.text;
                                        recMesaj = message.text;
                                      }

                                      message.clear();
                                      int time =
                                          DateTime.now().millisecondsSinceEpoch;
                                      await messagesBlock.addMessage(
                                        my!,
                                        rec,
                                        widget.noMessage,
                                        ChatMessage(
                                          messageStatus: MessageStatus.not_view,
                                          messageTime: time,
                                          messageType: ChatMessageType.text,
                                          recCryptedText: recMesaj,
                                          senderCryptedText: senderMesaj,
                                          isRemoved: false,
                                          sender: NSender(
                                            uid: userBlock.user!.uid,
                                            name: userBlock.user!.displayName,
                                            photoURL: userBlock.user!.photoURL,
                                          ),
                                          receiver: NReceiver(
                                              rToken: rec.token, rUid: rec.uid),
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
                                ),
                                // TextButton(
                                //   child: Icon(Icons.send_rounded, color: kPrimaryColor),

                                //   style: ElevatedButton.styleFrom(
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.circular(90)),
                                //       primary: Colors.white,
                                //       elevation: 0,
                                //       onPrimary: kPrimaryColor.withOpacity(0.5)),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (didHeBlock)
                      Positioned(
                        top: 1,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          child: Center(
                            child: Text(
                              "Görünüşe göre ${rec.displayName} sizi engellemiş.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    if (didIBlock)
                      Positioned(
                        top: 1,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text("Bu kullanıcıyı engellediniz.",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                        color:Colors.white30,
                                      ),
                                      
                                    ),
                                    primary:Colors.white
                                  ),
                                  onPressed: ()async{
                                   await profileBlock.deleteBlockedUser(my!,rec.uid!);
                                  },
                                  child: Text("Engeli Kaldır")),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              });
        });
  }

  Future<SenderMediaMessage?> getFilesDetailsScreen(
      FilesTyper filesTyper, UsersBlock usersBlock, String myUid) async {
    MyUser? receiver = usersBlock.getUserFromUid(widget.rUid);
    switch (filesTyper.type) {
      case ChatMessageType.image:
        return await Navigate.pushPage<SenderMediaMessage>(
            context,
            ImagesDetail(
              files: filesTyper.files,
              receiver: receiver,
            ));

      case ChatMessageType.audio:
        if (filesTyper.files!.isNotEmpty) {
          MediaReference? mediaRef = await getAudioModalBottomSheet(
              context, filesTyper, receiver, myUid);
          return mediaRef != null
              ? SenderMediaMessage(
                  type: ChatMessageType.audio, message: "", refs: [mediaRef])
              : null;
        } else
          return null;
      case ChatMessageType.video:
        if (isThereData(filesTyper)) {
          if (isNotNull(filesTyper.files)) {
            PlatformFile video = filesTyper.files![0];
            if (video.size! > (1024 * 1024 * 20)) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Video 20 mb dan büyük...")));
              return null;
            }
            //   Trimmer trimmer=Trimmer();
            //  await trimmer.loadVideo(videoFile:File(filesTyper.files![0].path!));
            return await Navigate.pushPage<SenderMediaMessage>(
                context,
                VideoDetailScreen(
                    video: filesTyper.files![0],
                    receiver: usersBlock.getUserFromUid(widget.rUid)));
          }
        }
        return null;
      case ChatMessageType.file:
        if (isThereData(filesTyper)) {
          if (isNotNull(filesTyper.files)) {
            print("files null değil");
            PlatformFile file = filesTyper.files![0];
            if (file.size! > (1024 * 1024 * 20)) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Dosya 20 mb dan büyük...")));
              return null;
            }
            MediaReference? ref = await getFileModalBottomSheet(
                context, filesTyper, receiver, myUid);
            print(ref);
            return ref != null
                ? SenderMediaMessage(
                    message: file.name,
                    refs: [ref],
                    type: ChatMessageType.file,
                  )
                : null;
          }
        }
        return null;
      default:
        return null;
    }
  }

  FutureOr<FilesTyper?> showModal() async {
    return await showModalBottomSheet<FilesTyper>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (c) {
        return Container(
          width: double.maxFinite,
          margin: EdgeInsets.all(8),
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(15),
          ),
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
                        if (isNotNull(files)) {
                          Navigator.pop(
                              context,
                              FilesTyper(
                                  files: files, type: ChatMessageType.image));
                        }
                        Navigator.pop(context);
                      },
                    ),
                    dosyaTipleri("Kamera", Icons.camera_alt_outlined,
                        imagePicker: true, onPressed: () async {
                      List<Media> images = await getImagesPickerCamera();
                      List<PlatformFile> imagesPlat;
                      if (images.isNotEmpty) {
                        imagesPlat = images
                            .map((e) => PlatformFile(
                                size: e.size.toInt(),
                                path: e.thumbPath,
                                name: e.path))
                            .toList();
                        Navigator.pop(
                            context,
                            FilesTyper(
                                files: imagesPlat,
                                type: ChatMessageType.image));
                      }
                      Navigator.pop(context);
                    }),
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
                      if (isNotNull(files)) {
                        Navigator.pop(
                            context,
                            files.isNotEmpty
                                ? FilesTyper(
                                    files: files, type: ChatMessageType.file)
                                : null);
                      } else {
                        Navigator.pop(context);
                      }
                    }),
                    dosyaTipleri("Video", Icons.videocam_outlined,
                        onPressed: () async {
                      List<PlatformFile> files = await getVideoPicker();
                      if (isNotNull(files)) {
                        Navigator.pop(
                            context,
                            files.isNotEmpty
                                ? FilesTyper(
                                    files: files, type: ChatMessageType.video)
                                : null);
                      } else {
                        Navigator.pop(context);
                      }
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
    VoidCallback? onPressed,
  }) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          height: 55,
          width: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.grey[850],
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

  final ChatMessageType? type;
  final List<PlatformFile>? files;
}

class MyCrypto {
  void main() {
    String sifreli = encrypt("Merhaba");
    print(sifreli);
    String normal = decrypt(sifreli);
    print(normal);
  }

  var encryptionKey = 'hasan';

  String encrypt(String data) {
    var charCount = data.length;
    var encrypted = [];
    var kp = 0;
    var kl = encryptionKey.length - 1;
    print("charCount= " + charCount.toString());

    for (var i = 0; i < charCount; i++) {
      var other = data[i].codeUnits[0] ^ encryptionKey[kp].codeUnits[0];
      print("${data[i]} units= " +
          data[i].codeUnits[0].toString() +
          " encry= " +
          encryptionKey[kp] +
          " = " +
          encryptionKey[kp].codeUnits[0].toString() +
          " other= " +
          other.toString());
      encrypted.insert(i, other);
      kp = (kp < kl) ? (++kp) : (0);
    }
    return dataToString(encrypted);
  }

  String decrypt(data) {
    return encrypt(data);
  }

  String dataToString(data) {
    var s = "";
    for (var i = 0; i < data.length; i++) {
      s += String.fromCharCode(data[i]);
    }
    return s;
  }
}

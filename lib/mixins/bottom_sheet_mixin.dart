import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/media_reference.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/storageBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/views/screens/chat/messages/components/chat_input_field.dart';
import 'package:social_media_app/views/screens/main_screen/widgets/build_audio_widget.dart';
import 'package:social_media_app/views/widgets/buttons/custom_elevated_button.dart';

mixin BottomSheetMixin {
  Future<MediaReference?> getAudioModalBottomSheet(BuildContext context,
      FilesTyper filesTyper, MyUser? receiver, String myUid) async {
    bool loading = false;
    return await showModalBottomSheet<MediaReference>(
        context: context,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (c) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[850]),
            margin: EdgeInsets.all(8),
            height: 200,
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "'${filesTyper.files![0].name}' ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: " ${receiver!.displayName} ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: "kişisine gönderilsin mi?"),
                        ],
                      ),
                    ),
                    BuildAudioWidget(
                      audios: filesTyper.files,
                      size: MediaQuery.of(context).size,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("İptal Et"),
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  shadowColor: Colors.transparent,
                                  backgroundColor: recMesColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(33))),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                if (!loading) {
                                  setState(() {
                                    loading = true;
                                  });
                                  MediaReference mediaRef =
                                      await Provider.of<StorageBlock>(context,
                                              listen: false)
                                          .uploadAudio(
                                    index: 0,
                                    timeStamp: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    ext: StorageBlock.fileExt(
                                        filesTyper.files![0].path!),
                                    file: File(filesTyper.files![0].path!),
                                    userUid: myUid,
                                  );
                                  Navigator.pop(context, mediaRef);
                                }
                              },
                              child:
                                  Text(loading ? "Gönderiliyor..." : "Gönder"),
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  shadowColor: Colors.transparent,
                                  backgroundColor: recMesColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(33))),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // TextButton(onPressed:(){}, child: Text("Göder")),
                  ],
                ),
              );
            }),
          );
        });
  }

  Future<MediaReference?> getFileModalBottomSheet(BuildContext context,
      FilesTyper filesTyper, MyUser? receiver, String myUid) async {
    bool loading = false;
    return await showModalBottomSheet<MediaReference>(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (c) {
          return StatefulBuilder(
            builder: (c, setState) {
              return Column(
                children: [
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[850]),
                    margin: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 8,
                      bottom: 8,
                    ),
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Row(
                              children: [
                                Container(
                                  width: 35,
                                  height: 35,
                                  margin: EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    color: recMesColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.upload_file,
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                                  "'${filesTyper.files![0].name}' ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:
                                                  " ${receiver!.displayName} ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:
                                                  "kişisine ${!loading ? "gönderilsin mi?" : " gönderiliyor"}"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // child: TextField(
                            //   controller: message,
                            //   decoration: InputDecoration(
                            //     hintText: "Mesajınız...",
                            //     border: InputBorder.none,
                            //   ),
                            // ),
                          ),
                          Spacer(),
                          if (loading) ...[
                            Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Yükleniyor, Lütfen bekleyiniz...")
                                ],
                              ),
                            ),
                          ],

                          if (!loading)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("İptal Et"),
                                    style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        shadowColor: Colors.transparent,
                                        backgroundColor: recMesColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(33))),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      if (!loading) {
                                        setState(() {
                                          loading = true;
                                        });
                                        MediaReference mediaRef =
                                            await Provider.of<StorageBlock>(
                                                    context,
                                                    listen: false)
                                                .uploadFile(
                                          index: 0,
                                          timeStamp: DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          ext: StorageBlock.fileExt(
                                              filesTyper.files![0].path!),
                                          file:
                                              File(filesTyper.files![0].path!),
                                          userUid: myUid,
                                        );
                                        Navigator.pop(context, mediaRef);
                                      }
                                    },
                                    child: Text("Gönder"),
                                    style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        shadowColor: Colors.transparent,
                                        backgroundColor: recMesColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(33))),
                                  ),
                                ),
                              ],
                            ),

                          // TextButton(onPressed:(){}, child: Text("Göder")),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  Future<T?> showMessageBottomSheet<T>(BuildContext context) async {
    return await showModalBottomSheet<T>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (c) {
          return Container(
            height: 200,
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade800,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white70,
                      onPrimary: Colors.red,
                      shadowColor: Colors.red.shade200,
                      shape: StadiumBorder(),
                    ),
                    icon: Icon(Icons.block),
                    label: Text("Sohbeti Blokla")),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white70,
                      onPrimary: Colors.black,
                      shadowColor: Colors.red.shade200,
                      shape: StadiumBorder(),
                    ),
                    child: Text("Sohbeti Temizle")),
              ],
            ),
          );
        });
  }
}

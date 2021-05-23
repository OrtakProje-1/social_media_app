import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media_app/mixins/picker_mixin.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/storageBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:extended_image/extended_image.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';
import 'package:social_media_app/views/screens/chat/models/sender_media_message.dart';
import 'package:social_media_app/views/screens/detail_screens/image_editor_page.dart';
import 'package:social_media_app/views/screens/detail_screens/widgets/image_dismissible_widget.dart';
import 'package:social_media_app/views/screens/detail_screens/widgets/send_button.dart';
import 'package:social_media_app/views/screens/detail_screens/widgets/textfield_widget.dart';

class ImagesDetail extends StatefulWidget {
  final List<PlatformFile> files;
  final MyUser receiver;
  ImagesDetail({Key key, this.files, this.receiver}) : super(key: key);

  @override
  _ImagesDetailState createState() => _ImagesDetailState(files: files);
}

class _ImagesDetailState extends State<ImagesDetail> with PickerMixin {
  List<PlatformFile> files;
  int selectIndex = 0;
  PageController _pageController;
  ScrollController _scrollController;
  BehaviorSubject<double> shadow;
  List<String> downloadUrls = [];
  TextEditingController _message = TextEditingController();
  BehaviorSubject<double> loadingProgress;

  _ImagesDetailState({this.files});




  @override
  Widget build(BuildContext context) {
    StorageBlock storageBlock = Provider.of<StorageBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: ExtendedImageGesturePageView.builder(
              controller: _pageController,
              itemCount: files.length,
              onPageChanged: (i) {
                setState(() {
                  selectIndex = i;
                });
              },
              itemBuilder: (c, i) {
                return ExtendedImage.file(
                  File(files[i].path),
                  key: Key(files[i].path),
                  mode: ExtendedImageMode.gesture,
                  initGestureConfigHandler: (d) {
                    return GestureConfig(
                      cacheGesture: false,
                      inPageView: true,
                      initialScale: 1,
                    );
                  },
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              titleSpacing: 0,
              backgroundColor: Colors.black38,
              title: Row(
                children: [
                  Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image:CachedNetworkImageProvider(widget.receiver.photoURL),
                      ),
                    ),
                  ),
                ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    widget.receiver.displayName,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigate.pushPage(
                        context, ImageEditorPage(image: files[selectIndex]));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: () {
                    if (files.length == 1) {
                      Navigator.pop(context);
                    } else {
                      files.removeAt(selectIndex);
                      setState(() {
                        selectIndex > 1 ? selectIndex-- : selectIndex = 0;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              color: Colors.black38,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: double.maxFinite,
                          child: TextFieldWidget(
                            controller: _message,
                          ),
                        ),
                        Container(
                          height: 60,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: InkWell(
                                  onTap: () async {
                                    List<PlatformFile> newImages =
                                        await getImagePicker();
                                    newImages.forEach((element) {
                                      if (!files
                                          .any((e) => e.path == element.path)) {
                                        files.add(element);
                                      }
                                    });
                                    setState(() {});
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: DottedBorder(
                                    radius: Radius.circular(8),
                                    color: Colors.white.withOpacity(0.9),
                                    borderType: BorderType.RRect,
                                    child: Container(
                                      width: 50,
                                      child: Center(
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              StreamBuilder<double>(
                                  stream: shadow,
                                  initialData: 0,
                                  builder: (context, snapshot) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: (snapshot.data > 0) ? 5 : 0),
                                      child: AnimatedOpacity(
                                        opacity: snapshot.data > 0 ? 1 : 0,
                                        duration: Duration(milliseconds: 300),
                                        child: Container(
                                          width: 3,
                                          padding: EdgeInsets.all(5),
                                          height: double.maxFinite,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 4,
                                                    offset: Offset(0, 0),
                                                    color: Colors.white30,
                                                    spreadRadius: 4),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                      ),
                                    );
                                  }),
                              Expanded(
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  controller: _scrollController,
                                  padding: EdgeInsets.all(5),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: files.length,
                                  itemBuilder: (c, i) {
                                    PlatformFile file = files[i];
                                    return GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          selectIndex = i;
                                        });
                                        await _pageController.animateToPage(
                                            selectIndex,
                                            duration:
                                                Duration(milliseconds: 400),
                                            curve: Curves.linear);
                                      },
                                      child: ImageDismissibleWidget(
                                        file: files[i],
                                        isSelected: selectIndex == i,
                                        onDismissed: (d) {
                                          if (files.length == 1) {
                                            Navigator.pop(context);
                                          } else {
                                            files.removeAt(i);
                                            setState(() {});
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: SendButton(
                      onPressed: () async {
                       
                        String time =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        showLoadingDialog();
                       
                        files.asMap().forEach((index, value) async {
                          String url = await storageBlock.uploadImage(
                              index: index,
                              ext: StorageBlock.fileExt(value.path),
                              file: File(value.path),
                              timeStamp: time,
                              userUid: userBlock.user.uid);
                          print("downloadurl= " + url);
                          downloadUrls.add(url);
                          double val=(downloadUrls.length/files.length);
                          loadingProgress.add(val>=1?1:val);
                          if(val>=1){
                            Navigator.pop(context);
                          }
                          if (downloadUrls.length == files.length) {
                            SenderMediaMessage senderMessage =
                                SenderMediaMessage(
                                    type: ChatMessageType.image,
                                    urls: downloadUrls,
                                    message: _message.text);
                            Navigator.pop(context, senderMessage);
                          }
                        });
                        
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      builder: (c){
        return AlertDialog(
          backgroundColor: Colors.grey.shade800,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: StreamBuilder<double>(
            stream: loadingProgress,
            initialData: 0,
            builder: (context, snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                  Text("Resimler Yükleniyor ( %${(snapshot.data*100).toInt()} )",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                ],
              );
            }
          ),
        );
      }
    );
  }

  void getShadow() {
    double shad;
    try {
      shad = _scrollController?.offset?.toInt() <= 0 ? 0 : 8;
    } catch (e) {
      shad = 0;
    }
    shadow.add(shad);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      getShadow();
    });
    loadingProgress=BehaviorSubject.seeded(0);
    shadow = BehaviorSubject.seeded(0);
  }

  @override
  void dispose() {
    shadow.close();
    loadingProgress.close();
    super.dispose();
  }
}

import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/views/widgets/bottom_appbar_notched_shape.dart';

class ImageEditorPage extends StatefulWidget {
  final PlatformFile image;
  ImageEditorPage({Key key, this.image}) : super(key: key);

  @override
  _ImageEditorPageState createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage> {
  GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  GlobalKey<ExtendedImageGestureState> gestureKey =
      GlobalKey<ExtendedImageGestureState>();

  double aspectRatio;

  final List<AspectRatioItem> _aspectRatios = <AspectRatioItem>[
    AspectRatioItem(text: 'Standart', value: CropAspectRatios.custom),
    AspectRatioItem(text: 'Orjinal', value: CropAspectRatios.original),
    AspectRatioItem(text: 'Kare', value: CropAspectRatios.ratio1_1),
    AspectRatioItem(text: '16:9', value: CropAspectRatios.ratio16_9),
    AspectRatioItem(text: '4:3', value: CropAspectRatios.ratio4_3),
    AspectRatioItem(text: '3:2', value: CropAspectRatios.ratio3_2),
  ];

  @override
  Widget build(BuildContext context) {
    String path = widget.image.path;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 2,
        title: Text("Editör"),
        actions: [
          IconButton(
            icon: Icon(Icons.save_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: ExtendedImage.file(
        File(path),
        fit: BoxFit.contain,
        extendedImageEditorKey: editorKey,
        extendedImageGestureKey: gestureKey,
        enableSlideOutPage: true,
        mode: ExtendedImageMode.editor,
        initEditorConfigHandler: (state) {
          return EditorConfig(
              animationDuration: Duration(milliseconds: 400),
              cornerColor: Colors.white,
              cropAspectRatio: aspectRatio,
              editorMaskColorHandler: (ctx, c) {
                return c ? Colors.black : Colors.black;
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.save_rounded,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        onPressed: () {},
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(45)),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: BottomAppbarNotchedShape(space: 2,spaceRadius: 3, radius: 45,horizontalSpace:-3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                editorKey.currentState.flip();
              },
              icon: Icon(Icons.flip),
            ),
            IconButton(
              onPressed: () async {
                double ratio = await showModalBottomSheet(
                    backgroundColor: Colors.grey.shade800,
                    context: context,
                    builder: (c) {
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: _aspectRatios
                                .map(
                                  (e) => InkWell(
                                    onTap: () {
                                      Navigator.pop(context, e.value);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                                      child: Container(
                                        width: double.maxFinite,
                                        child: Text(
                                          e.text,
                                          style: TextStyle(
                                              color: aspectRatio == e.value
                                                  ? Colors.blue
                                                  : Colors.white,fontWeight:aspectRatio==e.value ? FontWeight.bold : FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList()),
                      );
                    });
                setState(() {
                  aspectRatio=ratio;
                });
              },
              icon: Icon(Icons.aspect_ratio_rounded),
            ),
            SizedBox(),
            IconButton(
              onPressed: () {
                editorKey.currentState.rotate(right: false);
              },
              icon: Icon(Icons.rotate_90_degrees_ccw_rounded),
            ),
            
            IconButton(
              onPressed: () {
                editorKey.currentState.reset();
              },
              icon: Icon(Icons.restore),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:example/common/image_picker/image_picker.dart';
// import 'package:example/common/utils/crop_editor_helper.dart';
// import 'package:example/common/widget/common_widget.dart';
// import 'package:extended_image/extended_image.dart';
// import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:oktoast/oktoast.dart';
// import 'package:social_media_app/util/crop_editor_helper.dart';
// import 'package:url_launcher/url_launcher.dart';

// ///
// ///  create by zmtzawqlp on 2019/8/22
// ///

// class ImageEditorDemo extends StatefulWidget {
//   @override
//   _ImageEditorDemoState createState() => _ImageEditorDemoState();
// }

// class _ImageEditorDemoState extends State<ImageEditorDemo> {
//   final GlobalKey<ExtendedImageEditorState> editorKey =
//       GlobalKey<ExtendedImageEditorState>();
//   final GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>> popupMenuKey =
//       GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>>();
//   final List<AspectRatioItem> _aspectRatios = <AspectRatioItem>[
//     AspectRatioItem(text: 'custom', value: CropAspectRatios.custom),
//     AspectRatioItem(text: 'original', value: CropAspectRatios.original),
//     AspectRatioItem(text: '1*1', value: CropAspectRatios.ratio1_1),
//     AspectRatioItem(text: '4*3', value: CropAspectRatios.ratio4_3),
//     AspectRatioItem(text: '3*4', value: CropAspectRatios.ratio3_4),
//     AspectRatioItem(text: '16*9', value: CropAspectRatios.ratio16_9),
//     AspectRatioItem(text: '9*16', value: CropAspectRatios.ratio9_16)
//   ];
//   AspectRatioItem? _aspectRatio;
//   bool _cropping = false;

//   EditorCropLayerPainter? _cropLayerPainter;

//   @override
//   void initState() {
//     _aspectRatio = _aspectRatios.first;
//     _cropLayerPainter = const EditorCropLayerPainter();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('image editor demo'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.photo_library),
//             onPressed: _getImage,
//           ),
//           IconButton(
//             icon: const Icon(Icons.done),
//             onPressed: () {
//               if (kIsWeb) {
//                 _cropImage(false);
//               } else {
//                 _showCropDialog(context);
//               }
//             },
//           ),
//         ],
//       ),
//       body: Column(children: <Widget>[
//         Expanded(
//           child: _memoryImage != null
//               ? ExtendedImage.memory(
//                   _memoryImage!,
//                   fit: BoxFit.contain,
//                   mode: ExtendedImageMode.editor,
//                   enableLoadState: true,
//                   extendedImageEditorKey: editorKey,
//                   initEditorConfigHandler: (ExtendedImageState? state) {
//                     return EditorConfig(
//                       maxScale: 8.0,
//                       cropRectPadding: const EdgeInsets.all(20.0),
//                       hitTestSize: 20.0,
//                       cropLayerPainter: _cropLayerPainter!,
//                       initCropRectType: InitCropRectType.imageRect,
//                       cropAspectRatio: _aspectRatio!.value,
//                     );
//                   },
//                   cacheRawData: true,
//                 )
//               : ExtendedImage.asset(
//                   'assets/image.jpg',
//                   fit: BoxFit.contain,
//                   mode: ExtendedImageMode.editor,
//                   enableLoadState: true,
//                   extendedImageEditorKey: editorKey,
//                   initEditorConfigHandler: (ExtendedImageState? state) {
//                     return EditorConfig(
//                       maxScale: 8.0,
//                       cropRectPadding: const EdgeInsets.all(20.0),
//                       hitTestSize: 20.0,
//                       cropLayerPainter: _cropLayerPainter!,
//                       initCropRectType: InitCropRectType.imageRect,
//                       cropAspectRatio: _aspectRatio!.value,
//                     );
//                   },
//                   cacheRawData: true,
//                 ),
//         ),
//       ]),
//       bottomNavigationBar: BottomAppBar(
//         //color: Colors.lightBlue,
//         shape: const CircularNotchedRectangle(),
//         child: ButtonTheme(
//           minWidth: 0.0,
//           padding: EdgeInsets.zero,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               FlatButtonWithIcon(
//                 icon: const Icon(Icons.crop),
//                 label: const Text(
//                   'Crop',
//                   style: TextStyle(fontSize: 10.0),
//                 ),
//                 textColor: Colors.white,
//                 onPressed: () {
//                   showDialog<void>(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return Column(
//                           children: <Widget>[
//                             const Expanded(
//                               child: SizedBox(),
//                             ),
//                             SizedBox(
//                               height: 100,
//                               child: ListView.builder(
//                                 shrinkWrap: true,
//                                 scrollDirection: Axis.horizontal,
//                                 padding: const EdgeInsets.all(20.0),
//                                 itemBuilder: (_, int index) {
//                                   final AspectRatioItem item =
//                                       _aspectRatios[index];
//                                   return GestureDetector(
//                                     child: AspectRatioWidget(
//                                       aspectRatio: item.value,
//                                       aspectRatioS: item.text,
//                                       isSelected: item == _aspectRatio,
//                                     ),
//                                     onTap: () {
//                                       Navigator.pop(context);
//                                       setState(() {
//                                         _aspectRatio = item;
//                                       });
//                                     },
//                                   );
//                                 },
//                                 itemCount: _aspectRatios.length,
//                               ),
//                             ),
//                           ],
//                         );
//                       });
//                 },
//               ),
//               FlatButtonWithIcon(
//                 icon: const Icon(Icons.flip),
//                 label: const Text(
//                   'Flip',
//                   style: TextStyle(fontSize: 10.0),
//                 ),
//                 textColor: Colors.white,
//                 onPressed: () {
//                   editorKey.currentState!.flip();
//                 },
//               ),
//               FlatButtonWithIcon(
//                 icon: const Icon(Icons.rotate_left),
//                 label: const Text(
//                   'Rotate Left',
//                   style: TextStyle(fontSize: 8.0),
//                 ),
//                 textColor: Colors.white,
//                 onPressed: () {
//                   editorKey.currentState!.rotate(right: false);
//                 },
//               ),
//               FlatButtonWithIcon(
//                 icon: const Icon(Icons.rotate_right),
//                 label: const Text(
//                   'Rotate Right',
//                   style: TextStyle(fontSize: 8.0),
//                 ),
//                 textColor: Colors.white,
//                 onPressed: () {
//                   editorKey.currentState!.rotate(right: true);
//                 },
//               ),
//               FlatButtonWithIcon(
//                 icon: const Icon(Icons.rounded_corner_sharp),
//                 label: PopupMenuButton<EditorCropLayerPainter>(
//                   key: popupMenuKey,
//                   enabled: false,
//                   offset: const Offset(100, -300),
//                   child: const Text(
//                     'Painter',
//                     style: TextStyle(fontSize: 8.0),
//                   ),
//                   initialValue: _cropLayerPainter,
//                   itemBuilder: (BuildContext context) {
//                     return <PopupMenuEntry<EditorCropLayerPainter>>[
//                       PopupMenuItem<EditorCropLayerPainter>(
//                         child: Row(
//                           children: const <Widget>[
//                             Icon(
//                               Icons.rounded_corner_sharp,
//                               color: Colors.blue,
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Text('Default'),
//                           ],
//                         ),
//                         value: const EditorCropLayerPainter(),
//                       ),
//                       const PopupMenuDivider(),
//                       PopupMenuItem<EditorCropLayerPainter>(
//                         child: Row(
//                           children: const <Widget>[
//                             Icon(
//                               Icons.circle,
//                               color: Colors.blue,
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Text('Custom'),
//                           ],
//                         ),
//                         value: const CustomEditorCropLayerPainter(),
//                       ),
//                       const PopupMenuDivider(),
//                       PopupMenuItem<EditorCropLayerPainter>(
//                         child: Row(
//                           children: const <Widget>[
//                             Icon(
//                               CupertinoIcons.circle,
//                               color: Colors.blue,
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Text('Circle'),
//                           ],
//                         ),
//                         value: const CircleEditorCropLayerPainter(),
//                       ),
//                     ];
//                   },
//                   onSelected: (EditorCropLayerPainter value) {
//                     if (_cropLayerPainter != value) {
//                       setState(() {
//                         if (value is CircleEditorCropLayerPainter) {
//                           _aspectRatio = _aspectRatios[2];
//                         }
//                         _cropLayerPainter = value;
//                       });
//                     }
//                   },
//                 ),
//                 textColor: Colors.white,
//                 onPressed: () {
//                   popupMenuKey.currentState.showButtonMenu();
//                 },
//               ),
//               FlatButtonWithIcon(
//                 icon: const Icon(Icons.restore),
//                 label: const Text(
//                   'Reset',
//                   style: TextStyle(fontSize: 10.0),
//                 ),
//                 textColor: Colors.white,
//                 onPressed: () {
//                   editorKey.currentState.reset();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showCropDialog(BuildContext context) {
//     showDialog<void>(
//         context: context,
//         builder: (BuildContext content) {
//           return Column(
//             children: <Widget>[
//               Expanded(
//                 child: Container(),
//               ),
//               Container(
//                   margin: const EdgeInsets.all(20.0),
//                   child: Material(
//                       child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         const Text(
//                           'select library to crop',
//                           style: TextStyle(
//                               fontSize: 24.0, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(
//                           height: 20.0,
//                         ),
//                         Text.rich(TextSpan(children: <TextSpan>[
//                           TextSpan(
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: 'Image',
//                                   style: const TextStyle(
//                                       color: Colors.blue,
//                                       decorationStyle:
//                                           TextDecorationStyle.solid,
//                                       decorationColor: Colors.blue,
//                                       decoration: TextDecoration.underline),
//                                   recognizer: TapGestureRecognizer()
//                                     ..onTap = () {
//                                       launch(
//                                           'https://github.com/brendan-duncan/image');
//                                     }),
//                               const TextSpan(
//                                   text:
//                                       '(Dart library) for decoding/encoding image formats, and image processing. It\'s stable.')
//                             ],
//                           ),
//                           const TextSpan(text: '\n\n'),
//                           TextSpan(
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: 'ImageEditor',
//                                   style: const TextStyle(
//                                       color: Colors.blue,
//                                       decorationStyle:
//                                           TextDecorationStyle.solid,
//                                       decorationColor: Colors.blue,
//                                       decoration: TextDecoration.underline),
//                                   recognizer: TapGestureRecognizer()
//                                     ..onTap = () {
//                                       launch(
//                                           'https://github.com/fluttercandies/flutter_image_editor');
//                                     }),
//                               const TextSpan(
//                                   text:
//                                       '(Native library) support android/ios, crop flip rotate. It\'s faster.')
//                             ],
//                           )
//                         ])),
//                         const SizedBox(
//                           height: 20.0,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: <Widget>[
//                             OutlinedButton(
//                               child: const Text(
//                                 'Dart',
//                                 style: TextStyle(
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                                 _cropImage(false);
//                               },
//                             ),
//                             OutlinedButton(
//                               child: const Text(
//                                 'Native',
//                                 style: TextStyle(
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                                 _cropImage(true);
//                               },
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ))),
//               Expanded(
//                 child: Container(),
//               )
//             ],
//           );
//         });
//   }

//   Future<void> _cropImage(bool useNative) async {
//     if (_cropping) {
//       return;
//     }
//     String msg = '';
//     try {
//       _cropping = true;

//       //await showBusyingDialog();

//       Uint8List fileData;

//       /// native library
//       if (useNative) {
//         fileData = await cropImageDataWithNativeLibrary(
//             state: editorKey.currentState);
//       } else {
//         ///delay due to cropImageDataWithDartLibrary is time consuming on main thread
//         ///it will block showBusyingDialog
//         ///if you don't want to block ui, use compute/isolate,but it costs more time.
//         //await Future.delayed(Duration(milliseconds: 200));

//         ///if you don't want to block ui, use compute/isolate,but it costs more time.
//         fileData =
//             await cropImageDataWithDartLibrary(state: editorKey.currentState);
//       }
//       final String filePath =
//           await ImageSaver.save('extended_image_cropped_image.jpg', fileData);
//       // var filePath = await ImagePickerSaver.saveFile(fileData: fileData);

//       msg = 'save image : $filePath';
//     } catch (e, stack) {
//       msg = 'save failed: $e\n $stack';
//       print(msg);
//     }

//     _cropping = false;
//   }
// }

// class CustomEditorCropLayerPainter extends EditorCropLayerPainter {
//   const CustomEditorCropLayerPainter();
//   @override
//   void paintCorners(
//       Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
//     final Paint paint = Paint()
//       ..color = painter.cornerColor
//       ..style = PaintingStyle.fill;
//     final Rect cropRect = painter.cropRect;
//     const double radius = 6;
//     canvas.drawCircle(Offset(cropRect.left, cropRect.top), radius, paint);
//     canvas.drawCircle(Offset(cropRect.right, cropRect.top), radius, paint);
//     canvas.drawCircle(Offset(cropRect.left, cropRect.bottom), radius, paint);
//     canvas.drawCircle(Offset(cropRect.right, cropRect.bottom), radius, paint);
//   }
// }

// class CircleEditorCropLayerPainter extends EditorCropLayerPainter {
//   const CircleEditorCropLayerPainter();

//   @override
//   void paintCorners(
//       Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
//     // do nothing
//   }

//   @override
//   void paintMask(
//       Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
//     final Rect rect = Offset.zero & size;
//     final Rect cropRect = painter.cropRect;
//     final Color maskColor = painter.maskColor;
//     canvas.saveLayer(rect, Paint());
//     canvas.drawRect(
//         rect,
//         Paint()
//           ..style = PaintingStyle.fill
//           ..color = maskColor);
//     canvas.drawCircle(cropRect.center, cropRect.width / 2.0,
//         Paint()..blendMode = BlendMode.clear);
//     canvas.restore();
//   }

//   @override
//   void paintLines(
//       Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
//     final Rect cropRect = painter.cropRect;
//     if (painter.pointerDown) {
//       canvas.save();
//       canvas.clipPath(Path()..addOval(cropRect));
//       super.paintLines(canvas, size, painter);
//       canvas.restore();
//     }
//   }
// }

class AspectRatioItem {
  final String text;
  final double value;
  AspectRatioItem({this.text, this.value});
}

class CropAspectRatios {
  /// no aspect ratio for crop
  static const double custom = null;

  /// the same as aspect ratio of image
  /// [cropAspectRatio] is not more than 0.0, it's original
  static const double original = 0.0;

  /// ratio of width and height is 1 : 1
  static const double ratio1_1 = 1.0;

  /// ratio of width and height is 3 : 4
  static const double ratio3_4 = 3.0 / 4.0;

  /// ratio of width and height is 4 : 3
  static const double ratio4_3 = 4.0 / 3.0;

  static const double ratio3_2 = 3.0 / 2.0;

  /// ratio of width and height is 9 : 16
  static const double ratio9_16 = 9.0 / 16.0;

  /// ratio of width and height is 16 : 9
  static const double ratio16_9 = 16.0 / 9.0;
}

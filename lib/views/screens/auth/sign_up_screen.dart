import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/widgets/flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_card_swipper/widgets/transformer_page_view/transformer_page_view.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_media_app/mixins/textfield_mixin.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/auth/loginPage.dart';
import 'package:social_media_app/views/screens/auth/screenshot_widget.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TextFieldMixin{
  int avatarIndex = 0;
  SwiperController _swiperController;
  bool result = false;
  String imagePath;
  List<ScreenshotController> controllers=List.generate(100, (index) => ScreenshotController());

  @override
  void initState() {
    super.initState();
    _swiperController = SwiperController();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    UserBlock userBlock = Provider.of<UserBlock>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt ol".toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.0)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          if (result && imagePath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.file(File(imagePath)),
            ),
          ]
        ],
      ),
      body: Builder(builder: (context) {
        return Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  child: Transform.rotate(
                    angle: math.pi,
                    child: WaveWidget(
                      isLoop: true,
                      waveAmplitude: 3,
                      waveFrequency: size.width < 700 ? 5 : 8,
                      config: CustomConfig(
                        gradients: [
                          [
                            Colors.red.shade900.withOpacity(0.8),
                            Color(0xFF0004F1)
                          ],
                          [
                            Colors.red.shade700.withOpacity(0.6),
                            Color(0xDD0004F1)
                          ],
                          [
                            Colors.red.shade500.withOpacity(0.4),
                            Color(0xBB0004F1)
                          ],
                          [
                            Colors.red.shade300.withOpacity(0.2),
                            Color(0x990004F1)
                          ],
                          // [Colors.red, Color(0xAAF44336)],
                          // [Colors.orange, Color(0x66FF9800)],
                          // [Colors.red[800], Color(0x77E57373)],
                          // [Colors.yellow, Color(0x55FFEB3B)],
                        ],
                        durations: [15000, 19440, 10800, 34000],
                        heightPercentages: [0.20, 0.23, 0.25, 0.30],
                        blur: MaskFilter.blur(BlurStyle.outer, 20),
                        gradientBegin: Alignment.bottomLeft,
                        gradientEnd: Alignment.topRight,
                      ),
                      size: size,
                      //size:Size(size.width>700?400:size.width/2+100,size.width>700?400:size.width/2+100),
                    ),
                  ),
                ),
              ),
            ),
            ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Swiper(
                        onIndexChanged: (i){
                          avatarIndex=i;
                        },
                        itemWidth: 100,
                        layout: SwiperLayout.TINDER,
                        itemHeight: 100,
                        itemCount: 100,
                        loop: true,
                        controller: _swiperController,
                        itemBuilder: (c, i) {
                          return ScreenshotWidget(
                            controller: controllers[i],
                            url:"https://avatars.dicebear.com/api/avataaars/:seed$i.svg");
                        },
                      ),
                    ),
                    buildTextField(
                      size: size,
                      context: context,
                      hintText: "Kullanıcı Adı",
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
                      ),
                      suffixIcon: Icon(
                        Icons.check_circle,
                      ),
                    ),
                    buildTextField(
                      size: size,
                      context: context,
                      hintText: "E-mail",
                      prefixIcon: Icon(
                        Icons.alternate_email_rounded,
                      ),
                      suffixIcon: Icon(
                        Icons.check_circle,
                      ),
                    ),
                    buildTextField(
                      size:size,
                      context: context,
                      hintText: "Şifre",
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                      ),
                    ),
                    buildTextField(
                      size:size,
                      context: context,
                      hintText: "Şifre Tekrar",
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                      ),
                    ),
                    Container(
                      width: 200,
                      padding: EdgeInsets.all(30.0),
                      child: RawMaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        fillColor: Colors.pink,
                        onPressed: () async {
                          print(avatarIndex);
                          try {
                            Directory temporaryDir =
                                await getTemporaryDirectory();
                            String path = await controllers[avatarIndex].captureAndSave(
                                temporaryDir.path,
                                fileName: "${DateTime.now()}.png");
                            print(path);
                            setState(() {
                              result = true;
                              imagePath = path;
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        elevation: 11,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0))),
                        child: Text("Kayıt Ol",
                            style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Hesabın var mı?"),
                          TextButton(
                            child: Text(
                              "Giriş yap".toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              bool result = await Navigator.maybePop(context);
                              if (!result) {
                                Navigate.pushPage(context, LoginPage());
                              }
                            },
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        );
      }),
    );
  }

  
}

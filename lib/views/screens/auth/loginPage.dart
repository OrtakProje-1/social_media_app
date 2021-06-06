import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_media_app/mixins/textfield_mixin.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/auth/screenshot_widget.dart';
import 'package:social_media_app/views/screens/auth/sign_up_screen.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:sign_button/sign_button.dart';
import 'package:path_provider/path_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TextFieldMixin {
  int avatarIndex = 0;
  ScreenshotController _controller = ScreenshotController();
  bool result = false;
  String? imagePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    UserBlock userBlock = Provider.of<UserBlock>(context);
    UsersBlock usersBlock = Provider.of<UsersBlock>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: logoText(size1: 30, size2: 28),
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
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
                            Colors.red.shade300.withOpacity(0.4),
                            Color(0x990004F1)
                          ],
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
                      child: ScreenshotWidget.fromWidget(
                        size: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Container(
                            height: 120,
                            width: 120,
                            color: Colors.black,
                            padding: EdgeInsets.all(20),
                            child: Center(
                                child: logoText(
                                    size1: 55, size2: 50, isMini: true)),
                          ),
                        ),
                      ),
                    ),
                    buildTextField(
                      size: size,
                      context: context,
                      hintText: "E-mail",
                      prefixIcon: Icon(Icons.alternate_email_rounded,color: kPrimaryColor.withOpacity(0.8),),
                    ),
                    Column(
                      children: [
                        buildTextField(
                          size: size,
                          context: context,
                          hintText: "Şifre",
                          prefixIcon: Icon(Icons.lock_outlined,color: kPrimaryColor.withOpacity(0.8)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          child: Container(
                            width: double.maxFinite,
                            child: Text("Şifreni mi unuttun?",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 200,
                      padding: EdgeInsets.all(30.0),
                      child: RawMaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 13.0),
                        fillColor: Colors.black.withOpacity(0.05),
                        onPressed: () async {
                          try {
                            Directory temporaryDir =
                                await getTemporaryDirectory();
                            String? path = await _controller.captureAndSave(
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
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          side: BorderSide(
                              width: 1, color: kPrimaryColor.withOpacity(0.5)),
                        ),
                        child: Text("Giriş Yap",
                            style:
                                TextStyle(color: Colors.white, fontSize: 19)),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "yada".toUpperCase(),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child: SignInButton(
                                btnText: "Google ile giriş yap",
                                btnTextColor: Colors.white70,
                                btnColor: Colors.black.withOpacity(0.05),
                                buttonType: ButtonType.google,
                                elevation: 12,
                                // imagePosition: ImagePosition.left,
                                // btnColor: Colors.pink.shade700,
                                // btnTextColor: Colors.white70,
                                buttonSize: ButtonSize.medium,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    width: 1,
                                    color: kPrimaryColor.withOpacity(0.5)
                                  ),
                                ),
                                onPressed: () async {
                                  await userBlock.signInWithGoogle(
                                      context, usersBlock);
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Hesabın yok mu?"),
                          TextButton(
                            child: Text(
                              "Kayıt ol".toUpperCase(),
                              style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor),
                            ),
                            onPressed: () {
                              Navigate.pushPage(context, SignUpScreen());
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

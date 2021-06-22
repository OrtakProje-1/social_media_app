import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_media_app/mixins/textfield_mixin.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/auth/loginPage.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TextFieldMixin {
  int avatarIndex = 0;
  bool result = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    UserBlock userBlock = Provider.of<UserBlock>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:logoText(size1: 30, size2: 28),
        elevation: 0,
        backgroundColor: Colors.transparent,
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
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: Colors.black12,
                          border: Border.all(
                            color: kPrimaryColor
                          ),
                        ),
                        child: Icon(Icons.person,size: 70,color: Colors.white,),
                      ),
                    ),
                    buildTextField(
                      size: size,
                      context: context,
                      hintText: "Kullanıcı Adı",
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
                        color: kPrimaryColor,
                      ),
                      suffixIcon: Icon(
                        Icons.check_circle,
                        color: kPrimaryColor,
                      ),
                    ),
                    buildTextField(
                      size: size,
                      context: context,
                      hintText: "E-mail",
                      prefixIcon: Icon(
                        Icons.alternate_email_rounded,
                        color: kPrimaryColor,
                      ),
                      suffixIcon: Icon(
                        Icons.check_circle,
                        color: kPrimaryColor,
                      ),
                    ),
                    buildTextField(
                      size: size,
                      context: context,
                      hintText: "Şifre",
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: kPrimaryColor,
                      ),
                    ),
                    buildTextField(
                      size: size,
                      context: context,
                      hintText: "Şifre Tekrar",
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: kPrimaryColor,
                      ),
                    ),
                    Container(
                      width: 200,
                      padding: EdgeInsets.all(15.0),
                      child: RawMaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        fillColor: Colors.black.withOpacity(0.05),
                        onPressed: () async {
                          print(avatarIndex);
                        },
                        elevation: 11,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          side: BorderSide(
                            width: 1,
                            color: kPrimaryColor.withOpacity(0.5)
                          ),
                        ),
                        child: Text("Kayıt Ol",
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold)),
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
                              style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor),
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

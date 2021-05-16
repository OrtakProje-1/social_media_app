import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/main_screen/main_screen.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    UserBlock userBlock = Provider.of<UserBlock>(context);
    UsersBlock usersBlock = Provider.of<UsersBlock>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş Yap",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28.0)),
        actions: getPlatformAction(),
        elevation: 8,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Builder(builder: (context) {
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
                        waveAmplitude: 10,
                        waveFrequency: size.width < 700 ? 5 : 8,
                        backgroundColor: Colors.white,
                        config: CustomConfig(
                          gradients: [
                            [Colors.red.shade900.withOpacity(0.8), Color(0xFF0004F1)],
                            [Colors.red.shade700.withOpacity(0.6), Color(0xDD0004F1)],
                            [Colors.red.shade500.withOpacity(0.4), Color(0xBB0004F1)],
                            [Colors.red.shade300.withOpacity(0.2), Color(0x990004F1)],
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
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: size.width > 700 ? 300 : size.width,
                        child: Card(
                          margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          child: TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black26,
                                ),
                                suffixIcon: Icon(
                                  Icons.check_circle,
                                  color: Colors.black26,
                                ),
                                hintText: "Kullanıcı Adı",
                                hintStyle: TextStyle(color: Colors.black26),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 16.0)),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width > 700 ? 300 : size.width,
                        child: Card(
                          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          child: TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black26,
                                ),
                                hintText: "Şifre",
                                hintStyle: TextStyle(
                                  color: Colors.black26,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 16.0)),
                          ),
                        ),
                      ),
                      Container(
                        width: 200,
                        padding: EdgeInsets.all(30.0),
                        child: RawMaterialButton(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          fillColor: Colors.pink,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MainScreen()));
                          },
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                          child: Text("Giriş Yap",
                              style: TextStyle(color: Colors.white70)),
                        ),
                      ),
                      Text("Şifreni mi unuttun?",
                          style: TextStyle(color: Colors.black))
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("yada"),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child:SignInButton(
                                  btnText: "Google ile giriş yap",
                                  btnTextColor: Colors.white70,
                                  btnColor: Colors.black.withOpacity(0.65),
                                  buttonType: ButtonType.google,
                                  elevation: 12,
                                  // imagePosition: ImagePosition.left,
                                  // btnColor: Colors.pink.shade700,
                                  // btnTextColor: Colors.white70,
                                  buttonSize: ButtonSize.medium,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  onPressed: ()async{
                                   await userBlock.signInWithGoogle(context,usersBlock);
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
                                "Kayıt ol",
                                style: TextStyle(color: Colors.indigo),
                              ),
                              onPressed: () {},
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
      ),
    );
  }

  

List<Widget> getPlatformAction() {
  if (kIsWeb) {
    return [1, 2, 3, 4, 5, 6, 7, 8, 9]
        .map((e) => Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("Eleman $e"),
            )))
        .toList();
  } else {
    return [
      IconButton(
        icon: Icon(Icons.sort),
        onPressed: () {},
      ),
    ];
  }
 }
}

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypton/crypton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/crypto_block.dart';
import 'package:social_media_app/providers/get_datas.dart';
import 'package:social_media_app/providers/notificationBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/auth/loginPage.dart';
import 'package:social_media_app/views/screens/main_screen/main_screen.dart';
import 'package:social_media_app/views/widgets/animations/type_write.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  final User user;
  SplashScreen({Key? key,required this.user}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation<double> animation;
  late GetDatas getDatas;
  @override
  void initState() {
    super.initState();
    getDatas = GetDatas();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
               // _animationController?.reverse();
            } else if (status == AnimationStatus.dismissed) {
                _animationController?.forward();
            }
          });
    animation = Tween<double>(begin: 1, end: 0).animate(_animationController!);
      getAllData(widget.user);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _animationController?.forward();
      Future.delayed(Duration(seconds: 3),()async{
        Navigate.pushPageReplacement(context,MainScreen());
      });
    });
  }

  @override
  void dispose() { 
    _animationController?.dispose();
    super.dispose();
  }

  getAllData(User user) async {
    UserBlock block = context.read<UserBlock>();
    UsersBlock usersBlock = context.read<UsersBlock>();
    block.user = user;
    CryptoBlock cryptoBlock=CryptoBlock();
    RSAKeypair keypair=await cryptoBlock.getKeys(user.uid);
    MyUser myUser = MyUser.fromUser(user,publicKey: keypair.publicKey.toString());
    usersBlock.addUser(myUser);
    await getDatas.getAllDatas(context, user.uid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text.rich(
          TextSpan(
            text: "Social",
            style: GoogleFonts.lobster(fontSize: 30, color: kPrimaryColor),
            children: [
              TextSpan(
                text: " Club",
                style: GoogleFonts.lobster(fontSize: 26, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: size.width*2/4,
            margin:EdgeInsets.symmetric(vertical: 30),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: size.width,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 1 - animation.value.toDouble(),
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            border: Border.all(color: kPrimaryColor, width: 1),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image:CachedNetworkImageProvider(widget.user.photoURL!))),
                      ),
                    ),
                  
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: size.width,
              child: Column(
                children: <Widget>[
                  Text("Club'a Hoş Geldin",style: TextStyle(fontWeight: FontWeight.bold,fontSize:25),),
                  AnimatedTextKit(
                    totalRepeatCount: 1,
                    animatedTexts: [
                      RotateAnimatedText(
                        widget.user.displayName!,
                        duration: Duration(milliseconds: 3000),
                        textStyle: GoogleFonts.lobster(
                            fontSize: 40, color:kPrimaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

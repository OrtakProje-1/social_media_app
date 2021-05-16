import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/get_datas.dart';
import 'package:social_media_app/providers/notificationBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/auth/loginPage.dart';
import 'package:social_media_app/views/screens/main_screen/main_screen.dart';
import 'package:social_media_app/views/widgets/animations/type_write.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GetDatas getDatas;
  @override
  void initState() { 
    super.initState();
    getDatas=GetDatas();
    if(FirebaseAuth.instance.currentUser!=null){
      getAllData(FirebaseAuth.instance.currentUser);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 3),()async{
        if(FirebaseAuth.instance.currentUser!=null){
          
          Navigate.pushPageReplacement(context,MainScreen());
        }else 
        Navigate.pushPageReplacement(context,LoginPage());
      });
    });
  }

  getAllData(User user)async{
    UserBlock block=context.read<UserBlock>();
    UsersBlock usersBlock=context.read<UsersBlock>();
    block.user=user;
    MyUser myUser= MyUser.fromUser(user,token:block.token);
      usersBlock.addUser(myUser);
    await getDatas.getAllDatas(context,user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: TypeWrite(
          seconds:3,
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red.shade300,fontSize: 33),
          word: "Hoş Geldiniz",
        ),
      ),
    );
  }
}
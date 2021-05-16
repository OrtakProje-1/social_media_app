import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/postsBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/storageBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/theme_config.dart';
import 'package:social_media_app/views/screens/auth/loginPage.dart';
import 'package:social_media_app/views/screens/main_screen/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/views/screens/no_internet_screen.dart';
import 'package:social_media_app/views/screens/splash_screen.dart/splash_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserBlock userBlock=UserBlock();
    PostsBlock postsBlock=PostsBlock();
    UsersBlock usersBlock=UsersBlock();
    ProfileBlock profileBlock=ProfileBlock();
    StorageBlock storageBlock=StorageBlock();
    return MultiProvider(
      providers: [
        Provider<UsersBlock>(create:(c)=>usersBlock,dispose:(c,usersBlock)=>usersBlock.dispose(),),
        Provider<ProfileBlock>(create:(c)=>profileBlock,dispose:(c,profileBlock)=>profileBlock.dispose(),),
        Provider<UserBlock>(create:(c)=>userBlock,dispose:(c,userBlock)=>userBlock.dispose(),),
        Provider<PostsBlock>(create:(c)=>postsBlock,dispose: (c,postsBlock)=>postsBlock.dispose(),),
        Provider<StorageBlock>(create:(c)=>storageBlock,dispose: (c,storageBlock)=>storageBlock.dispose(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        theme: themeData(ThemeConfig.lightTheme),
        // darkTheme: themeData(ThemeConfig.darkTheme),
        home:StreamBuilder<ConnectivityResult>(
          stream: Connectivity().onConnectivityChanged, 
          builder: (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
            if(snapshot.hasData){
              if(snapshot.data==ConnectivityResult.none){
                return NoInternetScreen();
              }else{
                return SplashScreen();
              }
            }else{
              return SizedBox();
            }
          },
        
        ),
      ),
    );
  }

  Widget getHomeScreen(UserBlock block,UsersBlock usersBlock,ProfileBlock profileBlock){
    User user=FirebaseAuth.instance.currentUser;
    if(user==null){
      return LoginPage();
    }else{
      block.user=user;
      MyUser myUser= MyUser.fromUser(user,token: block.token);
      usersBlock.addUser(myUser);
      profileBlock.getAllFriendsUid(user.uid);
      return MainScreen();
    }
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
    );
  }
}
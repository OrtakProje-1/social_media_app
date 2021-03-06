

import 'dart:async';

import 'package:crypton/crypton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/get_datas.dart';
import 'package:social_media_app/providers/crypto_block.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/auth/loginPage.dart';
import 'package:social_media_app/views/screens/splash_screen.dart/splash_screen.dart';

class UserBlock {
  UserBlock();

  User? _user;
  String? _token;
  String? get token=>_token;
  User? get user => _user;
  set user(User? newUser){
    _user = newUser;
  }

  Future<void> signOut(BuildContext context) async {
    GetDatas().getAllDatas(context,user!.uid,isSignOut: true);
    await FirebaseAuth.instance.signOut();
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await userOffline(context);
    this.user=null;
    Navigate.pushPageWithFadeAnimation(context, LoginPage());
  }
  Future<void> userOffline(BuildContext context)async{
   await Provider.of<ProfileBlock>(context,listen: false).updateUserisOnline(user!.uid,false);
  }
  void dispose() {}
  Future<void> signInWithGoogle(BuildContext context, UsersBlock usersBlock) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
        UserCredential userCredential =
            await _auth.signInWithPopup(googleProvider);
        final user = userCredential.user!;
        // ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        //   content: Text(
        //       'Sign In ${user.uid} with Google name= ${user.displayName},${user.email}'),
        // ));
        bool isSavedUser = usersBlock.users.valueWrapper!.value
            .any((element) => element.uid == user.uid);
        if (!isSavedUser) {
          usersBlock.addUser(MyUser.fromUser(user));
        }
        await GetDatas().getAllDatas(context,user.uid,isSignOut: true);
        Navigate.pushPageReplacement(context, SplashScreen(user: user,));
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;
        final GoogleAuthCredential googleAuthCredential =
            GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        ) as GoogleAuthCredential;
        userCredential = await _auth.signInWithCredential(googleAuthCredential);

        final user = userCredential.user!;
        this.user = user;
        bool isSavedUser = usersBlock.users.valueWrapper!.value
            .any((element) => element.uid == user.uid);
        if (!isSavedUser) {
          CryptoBlock cryptoBlock=CryptoBlock();
          RSAKeypair keys=await cryptoBlock.getKeys(user.uid);
          usersBlock.addUser(MyUser.fromUser(user,publicKey:keys.publicKey.toString()));
        }
        
        Navigate.pushPageReplacement(context, SplashScreen(user: user,));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with Google: $e'),
        ),
      );
    }
  }
}

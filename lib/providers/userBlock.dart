import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/get_datas.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/auth/loginPage.dart';
import 'package:social_media_app/views/screens/main_screen/main_screen.dart';

class UserBlock {
  UserBlock(){
    init();
  }

  void init()async{
  }

  User _user;
  String _token;

  String get token=>_token;
  User get user => _user;

  set user(User newUser){
    _user = newUser;
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    Navigate.pushPageWithFadeAnimation(context, LoginPage());
  }

  void dispose() {}

  Future<void> signInWithGoogle(
      BuildContext context, UsersBlock usersBlock) async {
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
        final user = userCredential.user;
        // ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        //   content: Text(
        //       'Sign In ${user.uid} with Google name= ${user.displayName},${user.email}'),
        // ));
        bool isSavedUser = usersBlock.users.valueWrapper.value
            .any((element) => element.uid == user.uid);
        if (!isSavedUser) {
          usersBlock.addUser(MyUser.fromUser(user,token:token));
        }
        await GetDatas().getAllDatas(context,user.uid);
        Navigate.pushPageReplacement(context, MainScreen());
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final GoogleAuthCredential googleAuthCredential =
            GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);

        final user = userCredential.user;
        this.user = user;
        bool isSavedUser = usersBlock.users.valueWrapper.value
            .any((element) => element.uid == user.uid);
        if (!isSavedUser) {
          usersBlock.addUser(MyUser.fromUser(user,token: token));
        }
        GetDatas().getAllDatas(context,user.uid);
        Navigate.pushPageReplacement(context, MainScreen());
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

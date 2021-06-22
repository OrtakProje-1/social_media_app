import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_app/hus.dart';
import 'package:social_media_app/providers/messagesBlock.dart';
import 'package:social_media_app/providers/postsBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/storageBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/theme_config.dart';
import 'package:social_media_app/views/screens/auth/loginPage.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/views/screens/no_internet_screen.dart';
import 'package:social_media_app/views/screens/splash_screen.dart/splash_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = UserBlock();
    PostsBlock postsBlock = PostsBlock();
    UsersBlock usersBlock = UsersBlock();
    ProfileBlock profileBlock = ProfileBlock();
    StorageBlock storageBlock = StorageBlock();
    MessagesBlock messagesBlock = MessagesBlock();
    return MultiProvider(
      providers: [
        Provider<UsersBlock>(
          create: (c) => usersBlock,
          dispose: (c, usersBlock) => usersBlock.dispose(),
        ),
        Provider<ProfileBlock>(
          create: (c) => profileBlock,
          dispose: (c, profileBlock) => profileBlock.dispose(),
        ),
        Provider<UserBlock>(
          create: (c) => userBlock,
          dispose: (c, userBlock) => userBlock.dispose(),
        ),
        Provider<PostsBlock>(
          create: (c) => postsBlock,
          dispose: (c, postsBlock) => postsBlock.dispose(),
        ),
        Provider<StorageBlock>(
          create: (c) => storageBlock,
          dispose: (c, storageBlock) => storageBlock.dispose(),
        ),
        Provider<MessagesBlock>(
          create: (c) => messagesBlock,
          dispose: (c, messagesBlock) => messagesBlock.dispose(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        color: Colors.black,
        darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Color(0xFF1F1F1F),
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF1F1F1F),
            )),
        themeMode: ThemeMode.dark,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale("en"), Locale("tr")],
        locale: Locale("tr"),
        theme: themeData(ThemeConfig.lightTheme),
        builder: (c, w) {
          return AppLifecycleWidget(
            child: w,
          );
        },
        //home:BorderAnimation(),
        home: StreamBuilder<ConnectivityResult>(
          stream: Connectivity().onConnectivityChanged,
          builder: (BuildContext context,
              AsyncSnapshot<ConnectivityResult> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == ConnectivityResult.none) {
                return NoInternetScreen();
              } else {
                if (FirebaseAuth.instance.currentUser == null) {
                  return LoginPage();
                } else {
                  return SplashScreen(
                    user: FirebaseAuth.instance.currentUser!,
                  );
                }
              }
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
    );
  }
}

class AppLifecycleWidget extends StatefulWidget {
  final Widget? child;
  const AppLifecycleWidget({Key? key, this.child}) : super(key: key);

  @override
  _AppLifecycleWidgetState createState() => _AppLifecycleWidgetState();
}

class _AppLifecycleWidgetState extends State<AppLifecycleWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ProfileBlock profileBlock = context.read<ProfileBlock>();
    UserBlock userBlock = context.read<UserBlock>();
    switch (state) {
      case AppLifecycleState.resumed:
        profileBlock.updateUserisOnline(userBlock.user?.uid, true);
        break;
      case AppLifecycleState.paused:
        profileBlock.updateUserisOnline(userBlock.user?.uid, false);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}

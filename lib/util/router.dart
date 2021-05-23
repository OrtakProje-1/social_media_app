import 'package:flutter/material.dart';
import 'package:social_media_app/views/widgets/animations/fade_page_route.dart';

class Navigate {
  static Future<T> pushPage<T>(BuildContext context, Widget page) async {
    return await Navigator.push<T>(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  static pushPageDialog(BuildContext context, Widget page) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
        fullscreenDialog: true,
      ),
    );
  }

  static pushPageReplacement(BuildContext context, Widget page) async {
    return await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  static Future<T> pushPageWithFadeAnimation<T>(BuildContext context, Widget page) async {
    return await Navigator.pushReplacement(
      context,
      FadePageRoute(
        page,
      ),
    );
  }
}

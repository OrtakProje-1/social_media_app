

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/views/widgets/web_image.dart';
import 'package:fluttericon/typicons_icons.dart';

class EmptyPostItem extends StatefulWidget {

  EmptyPostItem({Key? key}) : super(key: key);
  @override
  _EmptyPostItemState createState() => _EmptyPostItemState();
}

class _EmptyPostItemState extends State<EmptyPostItem> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              dense: true,
              leading: Container(
                width: 40,
                height: 50,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 10,
                      right: 10,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(45)),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: CircleAvatar(foregroundColor: Colors.red,),
                    ),
                  ],
                ),
              ),
              contentPadding: EdgeInsets.all(0),
              focusColor: Constants.iconColor,
              horizontalTitleGap: kIsWeb ? 10 : 5,
              hoverColor: Constants.iconColor,
              title:Container(
                child: Text(""),
                width: 100,
                color: Colors.red,
              ),
              subtitle:Container(
                child: Text(""),
                color: Colors.red,
              ),
              trailing: Icon(Icons.more_horiz_outlined)
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                width: 1, color: Colors.grey.withOpacity(0.3)
              ),
            ),
            padding: EdgeInsets.all(2),
            child: Column(
              children: [
                Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Text(
                      "",
                      textAlign: TextAlign.left,
                    )),
                if (true) ...[
                  if (true) ...[
                    AspectRatio(
                      aspectRatio: 10 / 6,
                      child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.red
                              ),
                            ),
                    ),
                  ],
                 
                ],
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Row(
                    children: [
                      buildPostAction(
                          icon:Typicons.heart,
                          color:Colors.red ,
                          value:0,
                          onPressed:null),
                      buildPostAction(
                          value: 0,
                          icon: Linecons.comment),
                      // Spacer(),
                      buildPostAction(
                          value: 0,
                          icon:Typicons.bookmark)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildPostAction(
      {IconData? icon, VoidCallback? onPressed, Color? color,int? value}) {
        value ??= Random().nextInt(2999);
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
          padding: EdgeInsets.all(0),
          textStyle: TextStyle(color: Colors.black),
          primary: Colors.black,
        ),
        onPressed: onPressed != null ? onPressed : null,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              border: Border.all(
                  color: Constants.bottombarBackgroundColor.withOpacity(0.1),
                  width: 1),
              color: Colors.grey.shade200.withOpacity(0.2)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Icon(
                  icon,
                  color: color,
                ),
                Expanded(
                    child:
                        Center(child: Text(value.toString()))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getWebImage(String url) {
    return MeetNetworkImage(
      imageUrl: url,
      errorBuilder: (BuildContext context, Object error) {
        return Center(
          child: Text("Bir hata oluştu= " + error.toString()),
        );
      },
      loadingBuilder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

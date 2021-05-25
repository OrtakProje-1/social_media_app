

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuildBadgeWidget extends StatelessWidget {
  final Widget widget;
  final Stream<QuerySnapshot> stream;
  final bool isMini;
  const BuildBadgeWidget(
      {Key? key, required this.widget, required this.stream,this.isMini=false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.size != 0) {
              return Stack(
                children: [
                  widget,
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      constraints: BoxConstraints(minWidth:isMini ? 15 : 18, minHeight:isMini ? 15 : 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: Colors.red,
                        shape: BoxShape.rectangle,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Center(
                          child: Text(
                        snapshot.data!.size > 99
                            ? "99+"
                            : snapshot.data!.size.toString(),
                        style: TextStyle(
                          fontSize: isMini ? 10 : 12,
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              );
            }
          }
          return widget;
        });
  }
}

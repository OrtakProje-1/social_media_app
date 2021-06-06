

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/new_message_scree/new_messsage_screen.dart';
import 'components/body.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({Key? key}):super(key: key);
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  ScrollController? _scrollController;
  BehaviorSubject<double>? elevation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    elevation = BehaviorSubject<double>.seeded(0);
    _scrollController!.addListener(() {
      getElevation();
    });
  }

  @override
  Widget build(BuildContext context) {
    ProfileBlock profileBlock = Provider.of(context);
    UserBlock userBlock = Provider.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: StreamBuilder<double>(
            initialData: 0,
            stream: elevation,
            builder: (context, snapshot) {
              return buildAppBar(snapshot.data, profileBlock.friends.value,userBlock);
            }),
      ),
      body: Body(
        scrollController: _scrollController,
      ),
    );
  }

  AppBar buildAppBar(double? elevation, List<MyUser>? friends,UserBlock userBlock) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: elevation,
      leading: Center(
          child: Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: CachedNetworkImageProvider(userBlock.user!.photoURL!),
              ),
            ),
          ),
        ),
      title: Text(
        "Mesajlar",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
       IconButton(
         icon: Icon(Icons.add),
         onPressed: (){
           Navigate.pushPage(context,NewMessageScreen());
         },
       ),
      ],
    );
  }

  void getElevation() {
    double elev;
    try {
      elev = _scrollController!.offset.toInt() <= 0 ? 0 : 8;
    } catch (e) {
      elev = 0;
    }
    elevation!.add(elev);
  }
}
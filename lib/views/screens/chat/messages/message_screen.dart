import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media_app/mixins/bottom_sheet_mixin.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/messagesBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/profileScreen.dart';
import 'package:social_media_app/views/widgets/build_rec_appbar_title.dart';

import 'components/body.dart';

class MessagesScreen extends StatefulWidget {
  final MyUser? user;

  MessagesScreen({Key? key, this.user}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with BottomSheetMixin {
  List<QueryDocumentSnapshot> selectedMessage = [];
  QueryDocumentSnapshot? lastMessage;
  ScrollController? _controller;
  BehaviorSubject<double>? elevation;

  @override
  Widget build(BuildContext context) {
    MessagesBlock messagesBlock = Provider.of<MessagesBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);

    return WillPopScope(
      onWillPop: () async {
        if (selectedMessage.isNotEmpty) {
          selectedMessage.clear();
          setState(() {});
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: StreamBuilder<double>(
            initialData: 0,
            stream: elevation,
            builder: (c, snap) {
              return buildAppBar(selectedMessage.isNotEmpty, messagesBlock,
                  userBlock, widget.user, snap.data);
            },
          ),
        ),
        body: Body(
          controller: _controller,
          lastMessage: (QueryDocumentSnapshot lastMessage) {
            this.lastMessage = lastMessage;
            //   if(mounted) setState(() {});
          },
          rUid: widget.user!.uid,
          selectedMessage: selectedMessage,
          removeSelected: (QueryDocumentSnapshot snap) {
            print("remove = " + snap.toString());
            selectedMessage.removeWhere((element) => element.id == snap.id);
            setState(() {});
          },
          longPressed: (QueryDocumentSnapshot snap) {
            selectedMessage.add(snap);
            setState(() {});
          },
        ),
      ),
    );
  }

  AppBar buildAppBar(bool isSelect, MessagesBlock messagesBlock,
      UserBlock userBlock, MyUser? user, double? elevation) {
    return AppBar(
      titleSpacing: 0,
      elevation: 8,
      backgroundColor: Colors.transparent,
      title: BuildReceiverAppBarTitle(
        user: user,
        onPressed: () {
          Navigate.pushPage(context, ProfileScreen(user: user));
        },
      ),
      actions: [
        if (isSelect) ...[
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () async {
              if (lastMessage != null) {
                if (selectedMessage.any((e) => e.id == lastMessage!.id)) {
                  removeLastMessage(
                      messagesBlock, userBlock.user!.uid, widget.user!.uid);
                }
              }
              selectedMessage.forEach((element) async {
                await messagesBlock.deleteMessage(element, context);
                selectedMessage.remove(element);
              });

              selectedMessage.clear();
              setState(() {});
            },
          ),
        ],
        if (!isSelect) ...[
          IconButton(
            onPressed: () async {
            },
            icon: Icon(Icons.more_vert_rounded),
          ),
        ],
      ],
    );
  }

  void getElevation() {
    double elev;
    try {
      elev = _controller!.offset.toInt() <=
              _controller!.position.maxScrollExtent - 10
          ? 8
          : 0;
    } catch (e) {
      elev = 0;
    }
    elevation!.add(elev);
  }

  @override
  void initState() {
    super.initState();
    elevation = BehaviorSubject.seeded(0);
    _controller = ScrollController();
    _controller!.addListener(() {
      getElevation();
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getElevation();
    });
  }

  Future<void> removeLastMessage(
      MessagesBlock messagesBlock, String myUid, String? recUid) async {
    await messagesBlock.lastMessagesReference
        .doc(myUid)
        .collection("messages")
        .doc(recUid)
        .update(
      {
        'lastMessage': "Bu mesaj silindi...",
      },
    );
    await messagesBlock.lastMessagesReference
        .doc(recUid)
        .collection("messages")
        .doc(myUid)
        .update(
      {
        'lastMessage': "Bu mesaj silindi...",
      },
    );
  }
}

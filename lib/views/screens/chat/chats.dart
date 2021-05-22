import 'package:flutter/material.dart';
import 'package:social_media_app/views/widgets/chat_item.dart';
import 'package:social_media_app/util/data.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Mesajlarım"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
            ),
            onPressed: () {},
          ),
        ],
        
      ),
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(10),
        separatorBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width / 1.3,
              child: Divider(),
            ),
          );
        },
        itemCount: chats.length+1,
        itemBuilder: (BuildContext context, int index) {
          if(chats.length==index){
            return Container(
              height: AppBar().preferredSize.height,
            );
          }
          Map chat = chats[index];
          return ChatItem(
            dp: chat['dp'],
            name: chat['name'],
            isOnline: chat['isOnline'],
            counter: chat['counter'],
            msg: chat['msg'],
            time: chat['time'],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
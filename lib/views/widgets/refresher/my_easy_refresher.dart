import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/get_datas.dart';
import 'package:social_media_app/providers/userBlock.dart';

class MyEasyRefresher extends StatefulWidget {
  final ScrollController? scrollController;
  //final List<Widget> slivers;
  final Widget? child;
  MyEasyRefresher({Key? key, this.scrollController, required this.child})
      : super(key: key);

  @override
  _MyEasyRefresherState createState() => _MyEasyRefresherState();
}

class _MyEasyRefresherState extends State<MyEasyRefresher> {
  EasyRefreshController? _easyRefreshController;
  bool readyUpdate = true;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = Provider.of<UserBlock>(context);
    return EasyRefresh(
      controller: _easyRefreshController,
      scrollController: widget.scrollController,
      onRefresh: () async {
        GetDatas datas = GetDatas();
        _easyRefreshController!.callLoad();
        if (readyUpdate) {
          Future.delayed(Duration(seconds: 5), () {
            setState(() {
              readyUpdate = true;
            });
          });
          await datas.getAllDatas(context, userBlock.user!.uid);
          readyUpdate = false;
        } else {
          print("Güncelleme süre dolmadı");
        }
        await widget.scrollController!.animateTo(0, duration:Duration(milliseconds: 200), curve:Curves.linear);
      },
      header: MaterialHeader(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      ),
      child: widget.child

      //slivers:widget.slivers,
    );
  }
}

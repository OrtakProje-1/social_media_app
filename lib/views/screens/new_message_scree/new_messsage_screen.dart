

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/chat/messages/message_screen.dart';

class NewMessageScreen extends StatefulWidget {
  NewMessageScreen({Key? key}) : super(key: key);

  @override
  _NewMessageScreenState createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding / 2, vertical: 7),
          child: TextField(
            controller: _controller,
            onChanged: (s) {
              setState(() {});
            },
            cursorColor:kPrimaryColor.withOpacity(0.6),
            cursorRadius: Radius.circular(12),
            cursorWidth: 1.4,
            decoration: InputDecoration(
                hintText: "Kimi arıyorsun...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
          ),
        ),
      ),
      body: StreamBuilder<List<MyUser>>(
        stream: profileBlock.friends,
        initialData: profileBlock.friends!.valueWrapper!.value,
        builder: (c, snap) {
          List<MyUser> filteredUser = _controller.text.isEmpty
              ? snap.data!
              : snap.data!
                  .where((e) => e.displayName!
                      .toLowerCase()
                      .contains(_controller.text.toLowerCase()))
                  .toList();
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: filteredUser.length,
            itemBuilder: (c, i) {
              MyUser user = filteredUser[i];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigate.pushPage(
                        context,
                        MessagesScreen(
                          user: user,
                        ));
                  },
                  highlightColor: kPrimaryColor.withOpacity(0.1),
                  splashColor: kPrimaryColor.withOpacity(0.2),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      CachedNetworkImageProvider(user.photoURL!),
                                ),
                              ),
                            ),
                            if (user.isOnline!)
                              Positioned(
                                right: -3,
                                bottom: 1,
                                child: Container(
                                  height: 14,
                                  width: 14,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        width: 3),
                                  ),
                                ),
                              )
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.displayName!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

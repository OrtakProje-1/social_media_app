import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/crypto_block.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';

class FileMessage extends StatefulWidget {
  final ChatMessage? message;
  FileMessage({Key? key,this.message}) : super(key: key);

  @override
  _FileMessageState createState() => _FileMessageState();
}

class _FileMessageState extends State<FileMessage> {
  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = Provider.of<UserBlock>(context);
    User my = userBlock.user!;
    CryptoBlock cryptoBlock=CryptoBlock();
    return GestureDetector(
      onTap:()async{


      },
      child: Container(
        //width: MediaQuery.of(context).size.width * 0.60,
        padding: EdgeInsets.all(kDefaultPadding * 0.4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: getMessageColor(widget.message!.sender!.uid, userBlock.user!.uid),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: getMessageTextColor(widget.message!.sender!.uid, my.uid)
                    .withOpacity(0.4),
              ),
              child: Center(
                child: Icon(Icons.attach_file_sharp),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                     cryptoBlock.getPrivateKey().decrypt(userBlock.user!.uid==widget.message!.sender!.uid ? widget.message!.senderCryptedText! : widget.message!.recCryptedText!),
                    style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade900,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded,size: 70,color: Colors.white),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Internet Bağlantısı bulunamadı lütfen internetinizi kontrol edip tekrar deneyiniz.",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 23),textAlign: TextAlign.center,),
            )
            
          ],
        ),
      ),
    );
  }
}
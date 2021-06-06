import 'package:flutter/material.dart';

mixin LoadingMixin{
  void showLoadingStreamDialog(BuildContext context,Stream<double> loadingProgress) {
    showDialog(
      context: context,
      builder: (c){
        return AlertDialog(
          backgroundColor: Colors.grey.shade800,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: StreamBuilder<double>(
            stream: loadingProgress,
            initialData: 0,
            builder: (context, snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                  SizedBox(width: 10,),
                  Text("Resimler Yükleniyor ( %${(snapshot.data!*100).toInt()} )",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                ],
              );
            }
          ),
        );
      }
    );
  }
  void showLoadingDialog(BuildContext context,String textLoading) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (c){
        return AlertDialog(
          backgroundColor: Colors.grey.shade800,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                  SizedBox(width: 10,),
                  Text("$textLoading Yükleniyor",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                ],
              ),  
        );
      }
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

String average(star5,star4,star3,star2,star1){
  late String rating;
  var total = star1+star2+star3+star4+star5;

  var stars = star1+(star2*2)+(star3*3)+(star4*4)+(star5*5);

  if(total==0){
    rating = "0";
  }else{
    rating = (stars/total).toStringAsFixed(1);

  }

  return rating;

}


class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback? suspendingCallBack;

  LifecycleEventHandler({
    required this.resumeCallBack,
    this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (suspendingCallBack != null) {
          await suspendingCallBack!();
        }
        break;
    }
  }
}
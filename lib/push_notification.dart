import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotfication{
  ListenFireBaseMessage(){
    //listen firebase message
    FirebaseMessaging.onMessage.listen((event) {
      final RemoteMessage message=event;
      //get title in notification
      print(message.notification?.title ?? "Empty title");
      //get body in notifacation
      print(message.notification?.body ?? "Empty body");
      //get data
      print(message.data);
    });

  }
}
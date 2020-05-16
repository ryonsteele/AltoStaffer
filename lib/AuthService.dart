import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  static String deviceToken = "";
  static int fcmTokenCount = 0;


  String init(){
    fcmTokenCount = 0;


    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print(" onLaunch called ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) {
        print(" onResume called ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) {
        //showNotification(msg);
        print(" onMessage called ${(msg)}");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered.listen((
        IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    return getToken();
  }

  String getToken(){
    firebaseMessaging.getToken().then((token) {
      //update(token);
      deviceToken = token;
      if((deviceToken == null || deviceToken.isEmpty) && fcmTokenCount < 3){
        fcmTokenCount++;
        getToken();
      }else{
        return deviceToken;
      }
      fcmTokenCount = 0;
    });
    return deviceToken;
  }
}
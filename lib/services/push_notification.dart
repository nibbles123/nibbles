import 'dart:convert';
import 'package:http/http.dart' as http;

class PushNotificationService {
  static Future<void> sendPushMessage(String token, String body, String title) async {
    try {
      //POST METHOD FOR PUSH NOTIFICATIONS (FIREBASE CLOUD MESSAGING)
      //THE AUTHORIZATION KEY IS FROM FIREBASE CLOUD MESSAGING SECTION (SERVER KEY)
      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAAyZejIM:APA91bHRzoFnomLnAQettav3oYccm0jPRO4tpRz9Lc3JSrnSI-VEXAsi2rkpfoDip4myhn5ohisLpVGaQd-bvUmFTxHt448HR5EgLZ1BokcK_xtwIhqju9lKmN4Jh5Xqagu66CVxx3AB',
        },
        //IT IS GIVING THE NOTIFICATION THE BODY AND TITLE
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'sound': true
            },
            //TOKEN IS UNIQUE FOR EVERY USER DEVICE THROUGH WHICH THE NOTIFICATION COMES
            "to": token,
          },
        ),
      )
          .then((value) {
        print("Successfully Send ${value.body}");
      });
    } catch (e) {
      print("error push notification");
    }
  }

  static Future<void> sendPushCommunityMessage(
      String token, String body, String title) async {
    try {
      //POST METHOD FOR PUSH NOTIFICATIONS (FIREBASE CLOUD MESSAGING)
      //THE AUTHORIZATION KEY IS FROM FIREBASE CLOUD MESSAGING SECTION (SERVER KEY)
      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAAyZejIM:APA91bHRzoFnomLnAQettav3oYccm0jPRO4tpRz9Lc3JSrnSI-VEXAsi2rkpfoDip4myhn5ohisLpVGaQd-bvUmFTxHt448HR5EgLZ1BokcK_xtwIhqju9lKmN4Jh5Xqagu66CVxx3AB',
        },
        //IT IS GIVING THE NOTIFICATION THE BODY AND TITLE
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              "image": "https://firebasestorage.googleapis.com/v0/b/nibbles-ef8cb.appspot.com/o/community.png?alt=media&token=c957c0da-832f-4d55-9faa-e8e9cca37142",
             
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'sound': true
            },
            //TOKEN IS UNIQUE FOR EVERY USER DEVICE THROUGH WHICH THE NOTIFICATION COMES
            "to": token,
          },
        ),
      )
          .then((value) {
        print("Successfully Send ${value.body}");
      });
    } catch (e) {
      print("error push notification");
    }
  }

}

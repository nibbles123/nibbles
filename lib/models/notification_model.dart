import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? title, body, type;
  DateTime? date;
  NotificationModel({this.body, this.date, this.title, this.type});
  NotificationModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    title = doc["Title"];
    body = doc["Body"];
    type = doc["Type"];
    date = DateTime.parse(doc["Date"]);
  }
}

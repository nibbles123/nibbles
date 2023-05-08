import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id, name, phone, email, password, imageURL, socialURL;
  List? friends, followers, reserved, likedRestaurents;
  bool? isRated, notifications;
  String? loginMethod;
  UserModel({
    this.email,
    this.name,
    this.id,
    this.password,
    this.loginMethod,
    this.phone,
    this.reserved,
    this.isRated,
    this.followers,
    this.notifications,
    this.likedRestaurents,
    this.friends,
    this.socialURL,
    this.imageURL,
  });
  UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc.id;
    loginMethod = doc['LoginMethod'];
    name = doc["Name"];
    email = doc["Email"];
    isRated = doc['IsRated'];
    phone = doc["Phone"];
    notifications = doc['Notifications'];
    password = doc["Password"];
    imageURL = doc["ImageURL"];
    socialURL = doc["SocialURL"];
    followers = doc["Followers"];
    friends = doc["Friends"];
    reserved = doc["Reserved"] ?? [];
    likedRestaurents = doc['LikedRestaurents'];
  }
}

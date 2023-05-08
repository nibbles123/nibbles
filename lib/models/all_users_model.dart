import 'package:cloud_firestore/cloud_firestore.dart';

class AllUserModel {
  String? id, name,phone,email,password,imageURL,socialURL;
  List? friends,followers;
  AllUserModel({
      this.email,
      this.name,
      this.id,
      this.password,
      this.phone,
      this.followers,
      this.friends,
      this.socialURL,
      this.imageURL,});
  AllUserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc.id;
    name = doc["Name"];
    email = doc["Email"];
    phone = doc["Phone"];
    password = doc["Password"];
    imageURL=doc["ImageURL"];
    socialURL=doc["SocialURL"];
    followers=doc["Followers"];
    friends=doc["Friends"];
  }
}

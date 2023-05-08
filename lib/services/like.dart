import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/models/restaurent_model.dart';

import 'database.dart';

class LikeService {
  static Future<void> addRestaurentToLikes(RestaurentModel data) async {
    final authCont = Get.find<AuthController>();
    authCont.isLoading.value = true;
    //ADDING LIKE IN USERS LIST
    if (authCont.userInfo.likedRestaurents!.contains(data.id)) {
      authCont.userInfo.likedRestaurents!.remove(data.id);
    } else {
      authCont.userInfo.likedRestaurents!.add(data.id);
      //ADDING NOTIFICATION
      DataBase().addMyNotification(
          "Restaurant Liked",
          "You have successfully liked ${data.title}",
          "like",
          authCont.userss!.uid,
          false);
    }

    final userMap = {
      'id': authCont.userInfo.id,
      'Name': authCont.userInfo.name,
      'Photo': authCont.userInfo.imageURL
    };
    //UPDATING THAT LIST IN USERS COLLECTION
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(authCont.userss!.uid)
        .update({'LikedRestaurents': authCont.userInfo.likedRestaurents});
    authCont.getUser();

    //ADDING LIKED USER DATA IN RESTAURENTS
    final restaurentData = await FirebaseFirestore.instance
        .collection("Restaurents")
        .doc(data.id)
        .get();
    Map likesMap = restaurentData.get('LikedBy');
    if (likesMap.containsKey(authCont.userss!.uid)) {
      likesMap.remove(authCont.userss!.uid);
    } else {
      likesMap[authCont.userss!.uid] = userMap;
    }
    //UPDATING LIKES MAP IN RESTAURENTS
    await FirebaseFirestore.instance
        .collection("Restaurents")
        .doc(data.id)
        .update({'LikedBy': likesMap});
    //ADD RESTAURENT DATA IN USERS

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(authCont.userss!.uid)
        .collection('Likes')
        .where('id', isEqualTo: data.id)
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        //ADD LIKES
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(authCont.userss!.uid)
            .collection('Likes')
            .add({
          'id': data.id,
          'Name': data.title,
          'Image': data.photos![0],
          'Date': DateTime.now().toString()
        });
      } else {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(authCont.userss!.uid)
            .collection('Likes')
            .doc(value.docs[0].id)
            .delete();
      }
    });
    authCont.isLoading.value = false;

  }
}

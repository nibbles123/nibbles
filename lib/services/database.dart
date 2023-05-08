import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/constants/constants.dart';
import 'package:nibbles/constants/icons.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/controllers/filter_controller.dart';
import 'package:nibbles/models/all_users_model.dart';
import 'package:nibbles/models/notification_model.dart';
import 'package:nibbles/models/reserved_hotels.dart';
import 'package:nibbles/models/restaurent_model.dart';
import 'package:nibbles/services/current_location.dart';
import 'package:nibbles/utils/size_config.dart';

import '../models/user_model.dart';

class DataBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final authCont = Get.find<AuthController>();

  ///for creating user data

  Future<bool> createUser(UserModel user) async {
    try {
      await _firestore.collection("Users").doc(user.id).set({
        "Name": user.name,
        "Email": user.email,
        "Phone": user.phone,
        "Password": user.password,
        "FirstLogin": true,
        "Friends": user.friends ?? [],
        "Followers": user.followers ?? [],
        'LikedRestaurents': user.likedRestaurents ?? [],
        'Notifications': true,
        'IsRated': false,
        'LoginMethod': user.loginMethod,
        "FCMtoken": "",
        "CreatedAt": DateTime.now().toString(),
        "SocialURL": "",
        "Reserved": [],
        "ImageURL": user.imageURL,
        "searchKey": user.name!.toLowerCase()
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //CHANGE PASSWORD QUERY
  Future<void> onChangePassword(
      String oldPass, String newPass, String confirmNewPass) async {
    try {
      if (oldPass.isNotEmpty &&
          newPass.isNotEmpty &&
          confirmNewPass.isNotEmpty) {
        if (oldPass == authCont.userInfo.password) {
          if (newPass == confirmNewPass) {
            authCont.isLoading.value = true;
            authCont.userss!.updatePassword(newPass).then((value) {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(authCont.userss!.uid)
                  .update({"Password": newPass});
            }).then((value) {
              authCont.isLoading.value = false;
              Get.back();
              Get.snackbar(
                  "Changed", "Your password is successfully changed ;)",
                  backgroundColor: Colors.green, colorText: Colors.white);
            });
          } else {
            Get.snackbar("Please try again",
                "Your new and confirm password doesn't match :(",
                backgroundColor: Colors.redAccent, colorText: Colors.white);
          }
        } else {
          Get.snackbar("Please try again", "Your old password is incorrect :(",
              backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Please try again", "Please fill all the fields :(",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      authCont.isLoading.value = false;
      Get.snackbar("Please try again", "$e".split("]")[1],
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  //UPDATE USER PROFILE
  Future<void> onProfileEdit(String name, String socialURL) async {
    Get.find<ButtonController>().isEdit.value = false;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(authCont.userss!.uid)
        .update({
      "Name": name,
      "SocialURL": socialURL,
      "searchKey": name.toLowerCase()
    });
    await authCont.getUser();
    addMyNotification(
        "Changed Details",
        "You have successfully changed your details",
        "update",
        authCont.userss!.uid,
        true);
    authCont.updateLikeUserInfo();
  }

  //STREAM FOR ALL USERS
  Stream<List<AllUserModel>> streamForAllUsers() {
    return _firestore
        .collection("Users")
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllUserModel> users = [];
      query.docs.forEach((element) {
        users.add(AllUserModel.fromDocumentSnapshot(element));
      });
      return users;
    });
  }

//STREAM FOR WISHLIST RESTAURENT
  Stream<List<RestaurentModel>> streamForWishListRestaurents() {
    List<RestaurentModel> restaurents = [];
    return _firestore
        .collection("Restaurents")
        .where("WishList", arrayContains: authCont.userss!.uid)
        .snapshots()
        .map((QuerySnapshot query) {
      query.docs.forEach((element) {
        restaurents.add(RestaurentModel.fromDocumentSnapshot(element));
      });

      return restaurents;
    });
  }

  //STREAM FOR LIKED RESTAURENT
  Stream<List<RestaurentModel>> streamForLikedRestaurents(String userID) {
    List<RestaurentModel> restaurents = [];
    return _firestore
        .collection("Restaurents")
        .where("LikedBy", arrayContains: userID)
        .snapshots()
        .map((QuerySnapshot query) {
      query.docs.forEach((element) {
        restaurents.add(RestaurentModel.fromDocumentSnapshot(element));
      });

      return restaurents;
    });
  }

  //ADD RESTAURENT TO WISHLIST
  Future<void> addRestaurentToWishList(RestaurentModel restaurentModel) async {
    await _firestore
        .collection('Users')
        .doc(authCont.userss!.uid)
        .collection('WishList')
        .where('id', isEqualTo: restaurentModel.id)
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        //ADD WISH LIST
        await _firestore
            .collection('Users')
            .doc(authCont.userss!.uid)
            .collection('WishList')
            .add({
          'id': restaurentModel.id,
          'Name': restaurentModel.title!,
          'Image': restaurentModel.photos![0],
          'Date': DateTime.now().toString()
        });
        addMyNotification(
            "Wishlist Restaurant",
            "You have successfully added ${restaurentModel.title} to your WishList",
            "add",
            authCont.userss!.uid,
            false);
      } else {}
    });
  }

  //RESERVE RESTAURENT
  Future<void> reserveRestaurent(
      String guests,
      String date,
      String time,
      String hotelName,
      String hotelPicture,
      String hotelLocation,
      String hotelID,
      int dateIndex) async {
    authCont.isLoading.value = true;
    authCont.userInfo.reserved!.add(hotelID);
    await _firestore
        .collection("Users")
        .doc(authCont.userss!.uid)
        .update({"Reserved": authCont.userInfo.reserved});
    await _firestore
        .collection("Users")
        .doc(authCont.userss!.uid)
        .collection("ReservedHotels")
        .add({
          "NumberOfGuests": guests,
          "Date": date,
          "Time": time,
          "DateIndex": dateIndex,
          "HotelName": hotelName,
          "HotelLocation": hotelLocation,
          "HotelPicture": hotelPicture,
          "CreatedAt": DateTime.now().toString()
        })
        .then((value) => authCont.getUser())
        .then((value) => Get.back())
        .then((value) => authCont.isLoading.value = false)
        .then((value) => addMyNotification(
            "Reservation Alert",
            "$hotelName successfully reserved!",
            "reserve",
            authCont.userss!.uid,
            true));
  }

  //STREAM FOR RESEVED RESTAURENTS
  Stream<List<ReservedModel>> streamForReservedHotels() {
    return _firestore
        .collection("Users")
        .doc(authCont.userss!.uid)
        .collection("ReservedHotels")
        .orderBy("Date", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ReservedModel> reserveHotels = [];
      query.docs.forEach((element) {
        reserveHotels.add(ReservedModel.fromDocumentSnapshot(element));
      });
      return reserveHotels;
    });
  }

  //ADD NOTIFICATION TO MY OWN
  Future<void> addMyNotification(String title, String body, String type,
      String uid, bool isSnackbarShow) async {
    if (uid == authCont.userss!.uid) {
      String icon = type == "reward"
          ? reward
          : type == "reserve"
              ? reservation
              : type == "like"
                  ? heart
                  : type == "update"
                      ? pencil
                      : type == "community"
                          ? community
                          : "";
      if (isSnackbarShow) {
        Get.snackbar(title, body,
            backgroundColor: Colors.white,
            titleText: Text(
              title,
              style: const TextStyle(
                  color: kPrimaryColor, fontWeight: FontWeight.w600),
            ),
            icon: type == "filter"
                ? const Icon(
                    FeatherIcons.filter,
                    color: kPrimaryColor,
                  )
                : type == 'add'
                    ? const Icon(
                        FeatherIcons.plus,
                        color: kPrimaryColor,
                      )
                    : type == 'rating'
                        ? const Icon(
                            Icons.star_outline,
                            color: kPrimaryColor,
                          )
                        : Image.asset(
                            icon,
                            color: kPrimaryColor,
                            height: SizeConfig.heightMultiplier * 2,
                          ),
            colorText: Colors.black);
      }
    }
    await _firestore
        .collection("Users")
        .doc(uid)
        .collection("Notifications")
        .add({
      "Title": title,
      "Body": body,
      "Date": DateTime.now().toString(),
      "Type": type,
    });
  }

  //STREAM FOR NOTIFICATIONS
  Stream<List<NotificationModel>> streamForNotifications() {
    return _firestore
        .collection("Users")
        .doc(authCont.userss!.uid)
        .collection("Notifications")
        .orderBy("Date", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<NotificationModel> notifications = [];
      query.docs.forEach((element) {
        notifications.add(NotificationModel.fromDocumentSnapshot(element));
      });
      return notifications;
    });
  }

  //ADD FILTER
  Future<void> addFilter(
      List priceRange,
      int distance,
      String date,
      String time,
      List cuisine,
      List locations,
      int dateIndex,
      bool isNearby) async {
    authCont.isLoading.value = true;
    await _firestore
        .collection("Users")
        .doc(authCont.userss!.uid)
        .collection("Filter")
        .doc(filterUID)
        .set({
      'isNearby': isNearby,
      "PriceRange": priceRange,
      "Distance": distance,
      "Date": date,
      "Time": time,
      "Cuisine": cuisine,
      'Location': locations,
      "DateIndex": dateIndex,
      'CreatedAt': DateTime.now().toString()
    }).then((value) => authCont.isLoading.value = false);
  }

  //UPDATE HOTEL RESERVATION
  Future<void> updateReservation(
      String id, String guests, String date, int dateIndex, String time) async {
    authCont.isLoading.value = true;
    await _firestore
        .collection("Users")
        .doc(authCont.userss!.uid)
        .collection("ReservedHotels")
        .doc(id)
        .update({
          "NumberOfGuests": guests,
          "Date": date,
          "Time": time,
          "DateIndex": dateIndex
        })
        .then((value) => Get.back())
        .then((value) => authCont.isLoading.value = false);
  }

  //ALLOW NOTIFICATIONS
  Future<void> allowNotifications(bool value) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(authCont.userss!.uid)
        .update({'Notifications': value}).then((value) => authCont.getUser());
  }
}

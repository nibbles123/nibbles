import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/controllers/filter_controller.dart';
import 'package:nibbles/models/place.dart';
import 'package:nibbles/services/dynamic_links.dart';
import 'package:nibbles/services/place_service.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/pages/bottom%20nav%20bar/directory/directory.dart';
import 'package:nibbles/views/pages/bottom%20nav%20bar/home/home.dart';
import 'package:nibbles/views/pages/bottom%20nav%20bar/notifications/notifications.dart';
import 'package:nibbles/views/pages/bottom%20nav%20bar/profile/profile.dart';
import 'package:nibbles/views/pages/rate%20us/rate_us.dart';
import 'package:nibbles/views/widgets/show_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final buttonCont = Get.find<ButtonController>();
  final authCont = Get.find<AuthController>();
  final filterCont = Get.find<FilterController>();
  List<Widget> classes = [
    HomePage(),
    const NotificationsPage(),
    const DirectoryPage(
      isOffersPage: false,
      whichOffer: '',
    ),
    const ProfilePage(isOtherUser: false)
  ];
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Get.lazyPut<FilterController>(() => FilterController());
      DynamicLinkService.initDynamicLink(context);
      authCont.getUser();
      // changeFirebaseValues();
      firstTimeLoginToken();
      filterCont.getFilterData();
      generatingTokenForUser();
      Future.delayed(const Duration(seconds: 30), () => rateUs());
    });
  }

  rateUs() {
    if (authCont.userInfo.isRated!) {
      print('Rated');
    } else {
      print('Not Rated');
      Timer.periodic(const Duration(minutes: 6), (timer) {
        if (authCont.userInfo.isRated!) {
          timer.cancel();
        } else {
          buttonCont.isRateUsPage.value = true;
        }
      });
    }
  }

  firstTimeLoginToken() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> stableUsers = prefs.getStringList("stableUsers") ?? [];
    stableUsers.add(Get.find<AuthController>().userss!.uid);
    prefs.setStringList("stableUsers", stableUsers);
  }

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  generatingTokenForUser() async {
    //GENERATING A TOKEN FROM FIREBASE MESSAGING
    final fcmToken = await _fcm.getToken();
    //GETTING CURRENTUSER ID
    final uid = authCont.userss?.uid ?? "Null";
    print("This is the user $uid");
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .update({"FCMtoken": fcmToken}).then((value) {
      print("Token successfully");
    });
  }

  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/images/data.csv");
    List<List<dynamic>> _listData =
        const CsvToListConverter().convert(_rawData);
// print('ABRAR ${_listData.length}');
    for (int i = 1; i < _listData.length; i++) {
      List data = _listData[i];

      await FirebaseFirestore.instance
          .collection("Restaurents")
          .where('Title', isEqualTo: data[1])
          .get()
          .then((value) async {
        await FirebaseFirestore.instance
            .collection("Restaurents")
            .doc(value.docs[0].id)
            .update({'Cuisine': data[4]});
      }).then((value) => print('Length is $i'));
    }
  }

  // changeFirebaseValues() async {
  //   await FirebaseFirestore.instance
  //       .collection('Restaurents')
  //       .get()
  //       .then((value) async {
  //     for (int i = 0; i < value.docs.length; i++) {
  //       await FirebaseFirestore.instance
  //           .collection('Restaurents')
  //           .doc(value.docs[i].id)
  //           .update({'LikedBy': {}}).then((value) => print('LENGTH $i'));
  //     }
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return Obx(
      () => buttonCont.isRateUsPage.value
          ? const RateUsPage()
          : WillPopScope(
              onWillPop: () async {
                if (buttonCont.bnbSelectedIndex.value == 0) {
                  return true;
                } else {
                  buttonCont.bnbSelectedIndex.value = 0;
                  return false;
                }
              },
              child: ShowLoading(
                inAsyncCall: authCont.isLoading.value,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: classes.elementAt(buttonCont.bnbSelectedIndex.value),
                  bottomSheet: BottomAppBar(
                    child: Container(
                      height: SizeConfig.heightMultiplier * 10,
                      width: SizeConfig.widthMultiplier * 100,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                              icons.length,
                              (index) => InkWell(
                                    onTap: () {
                                      buttonCont.bnbSelectedIndex.value = index;
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: SizeConfig.heightMultiplier *
                                              1.5),
                                      child: SizedBox(
                                        height: SizeConfig.heightMultiplier * 6,
                                        width: SizeConfig.widthMultiplier * 25,
                                        child: Center(
                                          child: Icon(
                                            icons[index],
                                            color: buttonCont.bnbSelectedIndex
                                                        .value ==
                                                    index
                                                ? kPrimaryColor
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  List<IconData> icons = [
    FeatherIcons.home,
    FeatherIcons.bell,
    FeatherIcons.search,
    FeatherIcons.user
  ];
}

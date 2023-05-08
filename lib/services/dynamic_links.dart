import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/models/restaurent_model.dart';
import 'package:nibbles/views/bottom%20sheet/hotel%20details/hotel_details.dart';

class DynamicLinkService {
  static Future<String> createDynamicLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://nibbles.page.link',
      link: Uri.parse('https://www.nibbles.com/restaurent?id=$id'),
      androidParameters: AndroidParameters(
          packageName: 'com.booking.nibbles',
          // minimumVersion: 125,
          fallbackUrl: Uri.parse(
              'https://play.google.com/store/apps/details?id=com.booking.nibbles')),
      iosParameters: IosParameters(
        
          bundleId: 'com.booking.nibbles',
          // minimumVersion: '1.0.1',
          appStoreId: '6446055325',
      ),
    );

    final link = await parameters.buildUrl();

    return link.toString();
  }

  static Future<void> initDynamicLink(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(onSuccess: (s) async {
      if (s != null) {
        final Uri deepLink = s.link;
        String id = deepLink.queryParameters['id']!;
        gotoNavigation(id, context);
      }
    });
    PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) {
      final Uri deeplink = data.link;
      String id = deeplink.queryParameters['id']!;

      gotoNavigation(id, context);
    }
  }

  static gotoNavigation(String id, BuildContext context) async {
    //OPEN BOTTOM SHEET AND DIRECTORY PAGE
    Get.find<ButtonController>().bnbSelectedIndex.value = 2;
    final data = await FirebaseFirestore.instance
        .collection('Restaurents')
        .doc(id)
        .get();
    final restaurentInfo = RestaurentModel.fromDocumentSnapshot(data);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => HotelDetailsBottomSheet(
            whichOffer: '', isOffersPage: false, restaurent: restaurentInfo));
  }
}

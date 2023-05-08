import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/services/database.dart';

class RateUsService {
  static Future<void> giveFeedBack() async {
    final authCont = Get.find<AuthController>();
    final buttonCont = Get.find<ButtonController>();
    authCont.isLoading.value = true;
    await FirebaseFirestore.instance.collection('AppFeedback').add({
      'Satisfied': buttonCont.satisfiedRating.value,
      'Recommended': buttonCont.recommendedRating.value,
      'LikelyToVisitRestaurent': buttonCont.likelyToVisitRest.value,
      'UiUx': buttonCont.designRating.value,
      'UseAgainApp': buttonCont.useAgainRating.value,
      'FeedbackBy':authCont.userss!.uid,
      'Date':DateTime.now().toString()
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(authCont.userss!.uid)
        .update({
      'IsRated': true,
    }).then((value) => authCont.getUser());
    DataBase().addMyNotification(
        'Feedback',
        'Thanls for your feedback, your feedback is valulable to us so we can work on new updates :)',
        'rating',
        authCont.userss!.uid,true);
    authCont.isLoading.value = false;
    buttonCont.isRateUsPage.value = false;
  }
}

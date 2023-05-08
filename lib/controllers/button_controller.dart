import 'package:get/state_manager.dart';

class ButtonController extends GetxController {
  //FOR BOTTOM NAV BAR
  RxInt bnbSelectedIndex = 0.obs;

  //FOR RESERVE NOW BOTTOM SHEET

  //FOR SELECTED CHOICES
  RxList filterChoicesNames =
      ["Mexican", "Italian", "Spanish", "Greek", "Indian"].obs;

  //ON COMPLETED
  RxBool onCardComplete = false.obs;
  //FOR PROFILE
  RxBool isEdit = false.obs;
  RxString pickedImage = "".obs;
  RxString imageURL = "".obs;
  //FOR RATE US
  RxBool isRateUsPage = false.obs;
 
  //FOR RATINGS
  RxDouble satisfiedRating = 4.0.obs;
  RxDouble likelyToVisitRest = 4.0.obs;
  RxDouble recommendedRating = 4.0.obs;
  RxDouble designRating = 4.0.obs;
  RxDouble useAgainRating = 4.0.obs;
  RxBool isLoadingMore=false.obs;
}

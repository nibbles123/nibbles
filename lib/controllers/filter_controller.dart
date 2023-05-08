import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/constants.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/controllers/restaurents_controller.dart';
import 'package:nibbles/services/current_location.dart';
import 'package:nibbles/services/restaurent_service.dart';

class FilterController extends GetxController {
  //FOR FILTER PAGE
  RxList filterChoices = [].obs;
  RxList selectedChoices = [].obs;

  RxList selectedPrice = [].obs;
  RxBool isNearby = false.obs;
  RxBool isGetLocation = false.obs;
  RxDouble distanceSliderVal = 50.0.obs;
  RxInt selectedDateIndex = (-1).obs;
  RxInt selectedTimeIndex = (-1).obs;
  RxString selectedFilterTime = "".obs;
  RxList selectedLocality = [].obs;
  RxList allLocalities = [].obs;
  RxDouble guestSliderVal = 6.0.obs;
  RxString selectedDate = "".obs;
  RxString selectedTime = "".obs;
  Future<void> getFilterData() async {
    final uid = Get.find<AuthController>().userss!.uid;
    final restaurentCont = Get.find<RestaurentsController>();
    print("Getting Filter $uid");
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Filter")
        .doc(filterUID)
        .get()
        .then((value) {
      if (value.exists) {
        isNearby.value = value.get('isNearby');
        selectedPrice.value = value.get("PriceRange");
        distanceSliderVal.value = value.get("Distance").toDouble();
        selectedTime.value = value.get("Time");
        filterChoices.value = value.get("Cuisine");
        selectedChoices.value=value.get('Cuisine');
        selectedDate.value = value.get("Date");
        if (isNearby.value) {
          CurrentLocationService().setCurrentLocation();
        } else {
          selectedLocality.value = value.get("Location");
        }
        //GETTING TIME INDEX
        for (int i = 0; i < timeList.length; i++) {
          if (timeList[i] == value.get("Time")) {
            selectedTimeIndex.value = i;
            break;
          }
        }
        selectedDateIndex.value = value.get("DateIndex");
      }
    }).then((value) => restaurentCont.restaurents
            .bindStream(RestaurentService().streamForRestaurents()));
  }

  //FOR ADDING LOCATIONS
  Future<void> gettingallLocalities() async {
    await FirebaseFirestore.instance
        .collection('Localities')
        .get()
        .then((value) async {
      for (int i = 0; i < value.docs.length; i++) {
        if (!allLocalities.contains(value.docs[i].get("Name"))) {
          allLocalities.add(value.docs[i].get("Name"));
        }
      }
    }).then((value) => print("Get all localities done"));
  }
}

import 'package:get/get.dart';
import 'package:nibbles/models/restaurent_model.dart';
import 'package:swipable_stack/swipable_stack.dart';

class RestaurentsController extends GetxController {
  RxInt currentImageIndex = 0.obs;
  RxBool isLiked = false.obs;
  RxBool isLoading = false.obs;
  //FOR CARDS
  Rxn<SwipableStackController> cardCont = Rxn<SwipableStackController>();

  //FOR ALL RESTAURENTS
  Rxn<List<RestaurentModel>> restaurents = Rxn<List<RestaurentModel>>();
  List<RestaurentModel>? get getRestaurents => restaurents.value;

  //FOR RESERVED RESTAURENTS
  Rxn<List<RestaurentModel>> reservedRestaurents = Rxn<List<RestaurentModel>>();
  List<RestaurentModel>? get getReservedRestaurents =>
      reservedRestaurents.value;

  @override
  void onInit() {
    super.onInit();
    cardCont.value = SwipableStackController();
  }
}

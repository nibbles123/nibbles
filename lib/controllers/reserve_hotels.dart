import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:nibbles/models/reserved_hotels.dart';
import 'package:nibbles/services/database.dart';

class ReserveHotelsCont extends GetxController{
  Rxn<List<ReservedModel>> reserveHotels= Rxn<List<ReservedModel>>();
  List<ReservedModel>? get getReserveHotels => reserveHotels.value;
  @override
  void onInit() {
    super.onInit();
    reserveHotels.bindStream(DataBase().streamForReservedHotels());
  }
}
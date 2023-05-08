import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:nibbles/models/all_users_model.dart';
import 'package:nibbles/services/database.dart';

class AllUsersController extends GetxController{
  Rxn<List<AllUserModel>> allUsers = Rxn<List<AllUserModel>>();
  List<AllUserModel>? get getAllUsers => allUsers.value;
  @override
  void onInit() {
    super.onInit();
    allUsers.bindStream(DataBase().streamForAllUsers());
  }
}
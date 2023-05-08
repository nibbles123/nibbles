import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:nibbles/models/notification_model.dart';
import 'package:nibbles/services/database.dart';

class NotificationController extends GetxController {
  Rxn<List<NotificationModel>> notify = Rxn<List<NotificationModel>>();
  List<NotificationModel>? get getNotifications => notify.value;
  @override
  void onInit() {
    super.onInit();
    notify.bindStream(DataBase().streamForNotifications());
  }
}

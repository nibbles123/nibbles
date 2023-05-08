
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AuthBindings extends Bindings {  
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

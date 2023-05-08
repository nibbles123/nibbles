import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/controllers/all_users_controller.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/controllers/directory_cont.dart';
import 'package:nibbles/controllers/filter_controller.dart';
import 'package:nibbles/controllers/restaurents_controller.dart';
import 'package:nibbles/utils/stable_root.dart';
import 'package:nibbles/views/pages/authflow/choices/choices.dart';
import 'package:nibbles/views/pages/authflow/login/login.dart';
import 'package:nibbles/views/pages/authflow/reset%20password/reset_password.dart';
import 'package:nibbles/views/pages/bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:nibbles/views/pages/rate%20us/rate_us.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth_controller.dart';
import '../views/pages/authflow/filter/components/choose_choices.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  List<String> stableUsers = [];
  @override
  void initState() {
    super.initState();
    getStableUserRoot();
  }

  getStableUserRoot() async {
    final prefs = await SharedPreferences.getInstance();
    stableUsers = prefs.getStringList("stableUsers") ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController(), permanent: true);
    final buttonCont = Get.put(ButtonController());
    Get.put(AllUsersController(), permanent: true);
    Get.put(FilterController());
    Get.put(RestaurentsController(), permanent: true);
    Get.put(DirectoryCont(), permanent: true);
    return GetX<AuthController>(initState: (_) async {
      Get.put<AuthController>(AuthController());
    }, builder: (_) {
      if (_.user != null) {
        _.getUser();
        if (stableUsers.contains(_.userss!.uid)) {

        return buttonCont.isRateUsPage.value
            ? const RateUsPage()
            : BottomNavBar();
        } else {
          return _.isResetPassword.value
              ? ResetPasswordPage()
              : const ChoicesPage();
        }
      } else {
        return LoginPage();
      }
    });
  }
}

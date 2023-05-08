import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/icons.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/utils/root.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Get.put(ButtonController());
    gettingPermissions();
    Future.delayed(
        const Duration(seconds: 2),
        () => Get.off(() => const Root(),
            transition: Transition.rightToLeft));
  }
  
  gettingPermissions() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        print("Location is granted");
      } else if (status.isDenied) {
        Map<Permission, PermissionStatus> status =
            await [Permission.location].request();

        print("User is not granted");
      }
    } else {
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          appSmallIcon,
          height: SizeConfig.heightMultiplier * 15,
        ),
      ),
    );
  }
}

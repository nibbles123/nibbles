import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/services/database.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';

class SettingsPage extends StatefulWidget{
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final controller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 5,
            top: SizeConfig.heightMultiplier * 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomBackButton(),
            Text(
              'General Settings',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.textMultiplier * 2.5),
            ),
            const Divider(),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            Row(
              children: [
                Text(
                  'Allow Push Notifications',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.textMultiplier * 1.8),
                ),
                const Spacer(),
                Transform.scale(
                  scale: 0.7,
                  child: CupertinoSwitch(
                      value: controller.userInfo.notifications!,
                      activeColor: kPrimaryColor,
                      onChanged: (val) {
                        controller.userInfo.notifications = val;
                        setState(() {
                          
                        });
                        DataBase().allowNotifications(val);
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/views/pages/authflow/reset%20password/components/inputfield.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import '../../../utils/size_config.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/show_loading.dart';

class ChangePasswordBottomSheet extends StatelessWidget {
  const ChangePasswordBottomSheet(
      {Key? key,
      required this.oldPass,
      required this.newPass,
      required this.confirmNewPass,
      required this.onUpdate})
      : super(key: key);
  final TextEditingController confirmNewPass, newPass, oldPass;
  final VoidCallback onUpdate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: SizeConfig.heightMultiplier * 52,
        width: SizeConfig.widthMultiplier * 100,
        child: Obx(
          () => ShowLoading(
            inAsyncCall: Get.find<AuthController>().isLoading.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                Padding(
                  padding:
                      EdgeInsets.only(left: SizeConfig.widthMultiplier * 5),
                  child: const CustomBackButton(),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 1,
                ),
                Text(
                  "   Change Password",
                  style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 3,
                      fontWeight: FontWeight.w600),
                ),
               SizedBox(height: SizeConfig.heightMultiplier*2),
                Center(
                  child: ResetPassInputField(
                      controller: oldPass, hintText:"Old Password"),
                ),
                
               
                Center(
                  child: ResetPassInputField(
                      controller: newPass, hintText: "New Password"),
                ),
                
                Center(
                  child: ResetPassInputField(
                      controller: confirmNewPass,
                      hintText: "Confirm New Password"),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 4,
                ),
                Center(
                    child: CustomButton(
                  text: "Change Password",
                  onTap: onUpdate,
                )),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

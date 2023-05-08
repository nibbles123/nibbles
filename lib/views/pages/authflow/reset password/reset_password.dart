import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/pages/authflow/login/login.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/custom_button.dart';

import '../../../widgets/show_loading.dart';
import 'components/inputfield.dart';

class ResetPasswordPage extends GetWidget<AuthController>{
  ResetPasswordPage({Key? key}) : super(key: key);

  TextEditingController passCont = TextEditingController();
  TextEditingController confirmPassCont = TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> ShowLoading(
        inAsyncCall: controller.isLoading.value,
        child: Scaffold(
          body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier * 5,
                ),
                const CustomBackButton(),
                Text(
                  "   Reset Password",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.textMultiplier * 3.4),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 1,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 8),
                  child: Text(
                    "Please, enter a new password below\ndifferent from the previous password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.6,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 4,
                ),
                ResetPassInputField(
                  controller: passCont,
                  hintText: "Enter Password",
                ),
                ResetPassInputField(
                  controller: confirmPassCont,
                  hintText: "Confirm Password",
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 20,
                ),
                CustomButton(onTap: () {
                if(passCont.text==confirmPassCont.text){
                  controller.onResetPass( passCont.text);
                }
                }, text: "Reset Password")
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/pages/authflow/otp/otp.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/custom_button.dart';
import 'package:nibbles/views/widgets/custom_inputfield.dart';

import '../../../widgets/show_loading.dart';

class ForgotPasswordPage extends GetWidget<AuthController> {
  TextEditingController emailCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ShowLoading(
        inAsyncCall: controller.isLoading.value,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                  const CustomBackButton(),
                  Text(
                    " Forgot Password",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.textMultiplier * 3.4),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 1,
                  ),
                  Text(
                    "    Enter you email address",
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.6,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 20,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: SizeConfig.widthMultiplier * 10),
                    child: CustomInputField(
                        icon: FeatherIcons.mail,
                        hintText: "Email address",
                        controller: emailCont,
                        keyboardType: TextInputType.emailAddress),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 4,
                  ),
                  Center(
                      child: Text(
                    "We'll send you a reset code",
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.4,
                        color: kTextColor),
                  )),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 17,
                  ),
                  CustomButton(
                      onTap: () => emailCont.text.isNotEmpty
                          ? controller.onForgotPassword(emailCont.text.trim())
                          : print('Email empty'),
                      text: "Send Code")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

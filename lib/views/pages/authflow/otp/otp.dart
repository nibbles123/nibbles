import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/pages/authflow/reset%20password/reset_password.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/custom_button.dart';

import 'components/textfield.dart';

class OTPpage extends StatelessWidget {
 
  TextEditingController firstDigit = TextEditingController();
  TextEditingController secondDigit = TextEditingController();
  TextEditingController thirdDigit = TextEditingController();
  TextEditingController forthDigit = TextEditingController();
  final authCont = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
              Text(
                "       A reset code has been sent to your email",
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 1.6,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OtpField(
                      first: true,
                      last: false,
                      controller: firstDigit,
                    ),
                    OtpField(
                      first: false,
                      last: false,
                      controller: secondDigit,
                    ),
                    OtpField(
                      first: false,
                      last: false,
                      controller: thirdDigit,
                    ),
                    OtpField(
                      first: false,
                      last: true,
                      controller: forthDigit,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 3,
              ),
              Center(
                  child: Text(
                "Type the verification code\nwe’ve sent you",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 1.8,
                    color: kTextColor),
              )),
              SizedBox(
                height: SizeConfig.heightMultiplier * 15,
              ),
              CustomButton(
                  onTap: () {
                    String userInputCode = firstDigit.text +
                        secondDigit.text +
                        thirdDigit.text +
                        forthDigit.text;
                    if (userInputCode == authCont.verificationCode.value) {
                      Get.to(() => ResetPasswordPage(),
                          transition: Transition.leftToRight);
                    } else {
                      Get.snackbar(
                          'Please try again', 'OTP code is empty or invalid',
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white);
                    }
                  },
                  text: "Reset Password"),
              // const Spacer(),
              Center(
                child: TextButton(
                    onPressed: () =>authCont.sendOtpEmail().then((value) => Get.snackbar('Email resend successfully', 'Please check your email again')),
                    child: Text(
                      "Send again",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.textMultiplier * 1.7,
                          color: kPrimaryColor),
                    )),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 4,
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/constants/icons.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/services/place_service.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/pages/authflow/forgot%20password/forgot_password.dart';
import 'package:nibbles/views/pages/authflow/login/components/social_button.dart';
import 'package:nibbles/views/pages/authflow/signup/signup.dart';
import 'package:nibbles/views/widgets/custom_button.dart';
import 'package:nibbles/views/widgets/custom_inputfield.dart';
import 'package:nibbles/views/widgets/show_loading.dart';
import 'components/or_widget.dart';

class LoginPage extends GetWidget<AuthController> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  // addValuesToRestaurents() async {
  //   await FirebaseFirestore.instance
  //       .collection("Restaurents")
  //       .get()
  //       .then((value) async {
  //     for (int i = 0; i < value.docs.length; i++) {
  //       await FirebaseFirestore.instance
  //           .collection("Restaurents")
  //           .doc(value.docs[i].id)
  //           .update({"WishList": []}).then((value) => print(i));
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
   
    // addValuesToRestaurents();
    // gettingPhotos();
    return Obx(
      () => ShowLoading(
        inAsyncCall: controller.isLoading.value,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                right: SizeConfig.widthMultiplier * 5,
                left: SizeConfig.widthMultiplier * 4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                 
                   Center(
                     child: Image.asset(appSmallIcon,
                            height: SizeConfig.heightMultiplier * 8.5),
                   ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthMultiplier * 6),
                    child: Text(
                      "Sign in",
                      style:
                          TextStyle(fontSize: SizeConfig.textMultiplier * 2.4),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 4,
                  ),
                  CustomInputField(
                    controller: emailCont,
                    hintText: "Email address",
                    icon: FeatherIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 1,
                  ),
                  CustomInputField(
                      controller: passCont,
                      hintText: "Password",
                      icon: FeatherIcons.lock,
                      keyboardType: TextInputType.text),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 3,
                  ),
                  //FORGOT PASSWORD BUTTON
                  Center(
                    child: TextButton(
                        onPressed: () {
                          Get.to(() => ForgotPasswordPage(),
                              transition: Transition.leftToRight);
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 1.8,
                              color: kTextColor,
                              decoration: TextDecoration.underline),
                        )),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 2,
                  ),
                  CustomButton(
                    onTap: () {
                      if (emailCont.text.isNotEmpty &&
                          passCont.text.isNotEmpty) {
                        controller.onSignIn(emailCont.text, passCont.text,false);
                      } else {
                        Get.snackbar("Please try again",
                            "Provide all necessary information",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white);
                      }
                    },
                    text: "Sign in",
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 3,
                  ),
                  const ORwidget(),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                 Platform.isIOS? SocialButton(
                    icon: appleIcon,
                    text: "Login with iCloud",
                    onTap: () => controller.appleAuthentication(),
                  ):const SizedBox(),
                  SizedBox(
                    height: Platform.isIOS? SizeConfig.heightMultiplier * 1:0,
                  ),
                  SocialButton(
                    icon: googleIcon,
                    text: "Login with Gmail",
                    onTap: () => controller.signInWithGoogle(),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 1,
                  ),
                  SocialButton(
                    icon: fbIcon,
                    text: "Login with Facebook",
                    onTap: () => controller.onFacebookSignin(),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 6,
                  ),
                  //LAST NEW MEMBER LINE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New member?",
                        style: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 1.5,
                            color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => SignupPage(),
                              transition: Transition.leftToRight);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.heightMultiplier * 1,
                              horizontal: SizeConfig.widthMultiplier * 1),
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 1.5,
                                color: kPrimaryColor),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

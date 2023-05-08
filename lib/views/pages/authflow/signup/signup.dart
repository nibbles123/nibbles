import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/pages/authflow/choices/choices.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/custom_button.dart';
import 'package:nibbles/views/widgets/custom_inputfield.dart';
import 'package:nibbles/views/widgets/show_loading.dart';

class SignupPage extends StatelessWidget {
  TextEditingController nameCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  final authCont = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ShowLoading(
        inAsyncCall: authCont.isLoading.value,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 6,
                right: SizeConfig.widthMultiplier * 3),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                  const CustomBackButton(),
                  Text(
                    "Sign up",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.textMultiplier * 3.4),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 1,
                  ),
                  Text(
                    "   Create an account here",
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.6,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                  CustomInputField(
                      icon: FeatherIcons.user,
                      hintText: "Name",
                      keyboardType: TextInputType.text,
                      controller: nameCont),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 1,
                  ),
                  CustomInputField(
                      icon: FeatherIcons.smartphone,
                      hintText: "Mobile Number",
                      keyboardType: TextInputType.phone,
                      controller: phoneCont),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 1,
                  ),
                  CustomInputField(
                      icon: FeatherIcons.mail,
                      hintText: "Email address",
                      keyboardType: TextInputType.emailAddress,
                      controller: emailCont),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 1,
                  ),
                  CustomInputField(
                      icon: FeatherIcons.lock,
                      hintText: "Password",
                      keyboardType: TextInputType.text,
                      controller: passCont),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 2,
                  ),
                  Center(
                      child: Text(
                    "By signing up you agree with our Terms of Use",
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.3,
                        color: kTextColor),
                  )),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                  CustomButton(
                      onTap: () {
                        if (nameCont.text.isNotEmpty &&
                            phoneCont.text.isNotEmpty &&
                            emailCont.text.isNotEmpty &&
                            passCont.text.isNotEmpty) {
                          if (phoneCont.text.length > 10) {
                            if (emailCont.text.isEmail) {
                              //SIGNUP QUERY
                              authCont.onSignup(nameCont.text, phoneCont.text,
                                  emailCont.text, passCont.text);
                            } else {
                              Get.snackbar(
                                  "Please try again", "Email address incorrect",
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white);
                            }
                          } else {
                            Get.snackbar(
                                "Please try again", "Phone number incorrect",
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white);
                          }
                        } else {
                          Get.snackbar("Please try again",
                              "Provide all necessary information",
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white);
                        }
                      },
                      text: "Sign up")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

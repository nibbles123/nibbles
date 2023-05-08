import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/icons.dart';
import 'package:nibbles/utils/size_config.dart';


class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.heightMultiplier * 2),
        child: Image.asset(backIcon,height: SizeConfig.heightMultiplier*2.5),
      ),
    );
  }
}

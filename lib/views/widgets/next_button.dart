import 'package:flutter/material.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    Key? key,
    required this.onTap
  }) : super(key: key);
final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.heightMultiplier * 6,
        width: SizeConfig.widthMultiplier * 90,
        decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(14)),
        child: Center(
            child: Text(
          "Next",
          style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.2),
        )),
      ),
    );
  }
}

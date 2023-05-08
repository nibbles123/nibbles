import 'package:flutter/material.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);
  final VoidCallback onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: SizeConfig.heightMultiplier * 6.5,
          width: SizeConfig.widthMultiplier * 80,
          decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(99),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(5, 5),
                    color: Color.fromRGBO(149, 173, 254, 0.3),
                    blurRadius: 12)
              ]),
          child: Center(
              child: Text(
            text,
            style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.2,fontWeight: FontWeight.w500),
          )),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';


class SocialButton extends StatelessWidget {
  const SocialButton(
      {Key? key, required this.icon, required this.text, required this.onTap})
      : super(key: key);
  final String icon, text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: SizeConfig.heightMultiplier * 6,
          width: SizeConfig.widthMultiplier * 80,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(99),
              boxShadow: const [
                BoxShadow(color: Color(0xFFC1C7D0), blurRadius: 12)
              ]),
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 4),
          child: Row(
            children: [
              Image.asset(
                icon,
                height: SizeConfig.heightMultiplier * 4,
              ),
              SizedBox(
                width: SizeConfig.widthMultiplier * 13,
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 1.6, color: kTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
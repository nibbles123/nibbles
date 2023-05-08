import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';

class ResetPassInputField extends StatefulWidget {
  const ResetPassInputField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);
  final TextEditingController controller;
  final String hintText;

  @override
  State<ResetPassInputField> createState() => _ResetPassInputFieldState();
}

class _ResetPassInputFieldState extends State<ResetPassInputField> {
  bool isShowPass = true;
  Color textfieldColor = const Color(0xFFf9fafb);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier * 6.5,
      width: SizeConfig.widthMultiplier * 90,
      margin: EdgeInsets.only(
          bottom: SizeConfig.heightMultiplier * 1,
          left: SizeConfig.widthMultiplier * 5,
          right: SizeConfig.widthMultiplier * 5),
      decoration: BoxDecoration(
        color: textfieldColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              obscureText: isShowPass,
              controller: widget.controller,
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 1.7,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor),
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 1.7),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(0)),
            ),
          ),
          InkWell(
            onTap: () {
              isShowPass = !isShowPass;
              setState(() {});
            },
            child: Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 1,
                  bottom: SizeConfig.heightMultiplier * 1,
                  left: SizeConfig.widthMultiplier * 3,
                ),
                child: isShowPass
                    ? Icon(
                        FeatherIcons.eyeOff,
                        color: authIconsColor.withOpacity(0.8),
                        size: SizeConfig.heightMultiplier * 1.8,
                      )
                    : Icon(
                        FeatherIcons.eye,
                        color: authIconsColor.withOpacity(0.8),
                        size: SizeConfig.heightMultiplier * 1.8,
                      )),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';

class CustomInputField extends StatefulWidget {
  const CustomInputField(
      {Key? key,
      required this.icon,
      required this.hintText,
      required this.controller,
      required this.keyboardType})
      : super(key: key);
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool isShowPass = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 6),
      child: SizedBox(
        width: SizeConfig.widthMultiplier * 77,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        bottom: SizeConfig.heightMultiplier * 1,
                        left: SizeConfig.widthMultiplier * 3),
                    child: Icon(
                      widget.icon,
                      size: SizeConfig.heightMultiplier * 1.8,
                      color: authIconsColor.withOpacity(0.7),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 3, vertical: 4),
                  height: SizeConfig.heightMultiplier * 3,
                  width: 1,
                  color: hintTextColor,
                ),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    obscureText:
                        widget.hintText == "Password" ? isShowPass : false,
                    style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.7),
                    scrollPadding: const EdgeInsets.all(0),
                    keyboardType: widget.keyboardType,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier * 1.8),
                        // contentPadding: const EdgeInsets.all(0),
                        hintText: widget.hintText,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: hintTextColor,
                            fontSize: SizeConfig.textMultiplier * 1.6)),
                  ),
                ),
                widget.hintText == "Password"
                    ? InkWell(
                        onTap: () {
                          isShowPass = !isShowPass;
                          setState(() {});
                        },
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.heightMultiplier * 1,
                                bottom: SizeConfig.heightMultiplier * 1,
                                left: SizeConfig.widthMultiplier * 3,
                                right: SizeConfig.widthMultiplier * 3),
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
                    : const SizedBox()
              ],
            ),
            const Divider(
              height: 0,
              thickness: 0.7,
              color: hintTextColor,
            )
          ],
        ),
      ),
    );
  }
}

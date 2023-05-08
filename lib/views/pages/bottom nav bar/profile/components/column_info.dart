import 'package:flutter/material.dart';
import 'package:nibbles/constants/icons.dart';
import 'package:nibbles/utils/size_config.dart';

class ProfileColumnInfo extends StatelessWidget {
  const ProfileColumnInfo({
    Key? key,
    required this.title,
    required this.controller,
    required this.isEnableField,
    this.isFocus=false
  }) : super(key: key);
  final String title;
  final TextEditingController controller;
  final bool isEnableField,isFocus;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                  color: const Color(0xFF898989),
                  fontSize: SizeConfig.textMultiplier * 1.5),
            ),
            title == "Social URL"
                ? Padding(
                    padding:
                        EdgeInsets.only(left: SizeConfig.widthMultiplier * 2),
                    child: Image.asset(
                      socialURL,
                      height: SizeConfig.heightMultiplier * 2,
                    ),
                  )
                : const SizedBox()
          ],
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 4,
          width: title == "Following" || title == "Followers"
              ? SizeConfig.widthMultiplier * 30
              : SizeConfig.widthMultiplier * 90,
          child: TextField(
            autofocus: isFocus,
            enabled: isEnableField,
            style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.5),
            maxLines: 1,
            controller: controller,
            decoration: const InputDecoration(
                border: InputBorder.none, contentPadding: EdgeInsets.all(0)),
          ),
        ),
      ],
    );
  }
}

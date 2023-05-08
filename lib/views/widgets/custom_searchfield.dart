import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nibbles/utils/size_config.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    Key? key,
    required this.controller,
    required this.onChange,
    required this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChange;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: SizeConfig.heightMultiplier * 6,
        width: SizeConfig.widthMultiplier * 80,
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12)),
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 4),
        child: Row(
          children: [
            Icon(
              FeatherIcons.search,
              color: Colors.grey.shade600,
            ),
            SizedBox(
              width: SizeConfig.widthMultiplier * 3,
            ),
            Expanded(
                child: TextField(
              controller: controller,
              onChanged: onChange,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(0),
                  hintText:hintText,
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade400)),
            ))
          ],
        ),
      ),
    );
  }
}

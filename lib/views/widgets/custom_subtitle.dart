import 'package:flutter/material.dart';
import 'package:nibbles/utils/size_config.dart';

class CustomSubtitle extends StatelessWidget {
  const CustomSubtitle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 1.5),
      color: Colors.grey.shade300,
      child: Text(
        text,
        style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: SizeConfig.textMultiplier * 1.4),
      ),
    );
  }
}

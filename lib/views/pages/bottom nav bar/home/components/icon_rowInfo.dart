import 'package:flutter/material.dart';
import 'package:nibbles/utils/size_config.dart';

class IconRowInfo extends StatelessWidget {
  const IconRowInfo(
      {Key? key, required this.text, required this.icon, required this.color})
      : super(key: key);
  final String text, icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          icon,
          color: color,
          height: SizeConfig.heightMultiplier * 2.5,
        ),
        SizedBox(
          width: SizeConfig.widthMultiplier * 3,
        ),
        SizedBox(
          width: SizeConfig.widthMultiplier * 60,
          child: Text(
            text,
            style: TextStyle(
                fontSize: SizeConfig.textMultiplier * 2.2,
                fontWeight: FontWeight.w500,
                shadows: const [
                  BoxShadow(color: Colors.black, blurRadius: 40)
                ],
                color: Colors.white),
          ),
        )
      ],
    );
  }
}

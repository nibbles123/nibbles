import 'package:flutter/material.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';


class ORwidget extends StatelessWidget {
  const ORwidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 5,
          right: SizeConfig.widthMultiplier * 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: SizeConfig.widthMultiplier * 30,
            color: kPrimaryColor,
            height: 2,
          ),
          Container(
            height: SizeConfig.heightMultiplier * 5.5,
            width: SizeConfig.widthMultiplier * 11,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kPrimaryColor, width: 2),
                color: Colors.white),
            child: Center(
                child: Text(
              "OR",
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 1.7,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w700),
            )),
          ),
          Container(
            width: SizeConfig.widthMultiplier * 30,
            color: kPrimaryColor,
            height: 2,
          )
        ],
      ),
    );
  }
}

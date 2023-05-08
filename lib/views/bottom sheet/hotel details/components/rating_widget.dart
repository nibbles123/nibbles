import 'package:flutter/material.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({
    Key? key,
    required this.rating,
    this.isAllRating = false,
  }) : super(key: key);
  final num rating;
  final bool isAllRating;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier * 1.9,
      width: isAllRating
          ? SizeConfig.widthMultiplier * 8
          : SizeConfig.widthMultiplier * 12,
      decoration: BoxDecoration(
          color: kPrimaryColor, borderRadius: BorderRadius.circular(5)),
      child: Center(
          child: Text(
        rating.toString(),
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: SizeConfig.textMultiplier * 1.4),
      )),
    );
  }
}

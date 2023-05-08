import 'package:flutter/material.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';

class MenuButton extends StatelessWidget {
  const MenuButton(
      {Key? key,
      required this.onTap,
      required this.isActive,
      required this.isOffersPage})
      : super(key: key);
  final VoidCallback onTap;
  final bool isActive;
  final bool isOffersPage;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.heightMultiplier * 11,
        width: SizeConfig.widthMultiplier * 100,
        color: Colors.white,
        child: Center(
          child: Container(
            height: SizeConfig.heightMultiplier * 5,
            width: SizeConfig.widthMultiplier * 60,
            margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 1),
            decoration: BoxDecoration(
                color: isActive ? Colors.grey : kPrimaryColor,
                borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Text(
                isOffersPage ? 'See Offer' : "Reserve now",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';

class ReserveButton extends StatelessWidget {
  const ReserveButton({
    Key? key,
    required this.onTap,
    required this.isReserved,
    required this.isUpdate,
  }) : super(key: key);
  final VoidCallback onTap;
  final bool isReserved;
  final bool isUpdate;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.heightMultiplier * 6.5,
        width: SizeConfig.widthMultiplier * 80,
        decoration: BoxDecoration(
            color: isReserved ? Colors.grey : kPrimaryColor,
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            isUpdate ? "Update" : "Reserve Now",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.textMultiplier * 3.2),
          ),
        ),
      ),
    );
  }
}

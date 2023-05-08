import 'package:flutter/material.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';

class ProfileOptions extends StatelessWidget {
  const ProfileOptions({
    Key? key,
    required this.onTap,
    required this.title,
    required this.icon,
  }) : super(key: key);
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 2),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: SizeConfig.widthMultiplier * 100,
          child: Row(
            children: [
              Container(
                height: SizeConfig.heightMultiplier * 5.5,
                width: SizeConfig.widthMultiplier * 13,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Icon(
                    icon,
                    color: kPrimaryColor,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.widthMultiplier * 4,
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 1.6,
                    fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: SizeConfig.heightMultiplier * 1.9,
                color: Colors.grey.shade600,
              )
            ],
          ),
        ),
      ),
    );
  }
}

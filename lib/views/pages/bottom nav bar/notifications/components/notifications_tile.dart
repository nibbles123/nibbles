import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  }) : super(key: key);
  final String icon, title, subtitle, time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.widthMultiplier * 4,
        right: SizeConfig.widthMultiplier * 4,
      ),
      child: Row(
        children: [
          icon == "filter"
              ? const Icon(
                  FeatherIcons.filter,
                  color: kPrimaryColor,
                )
              : icon == 'add'
                  ? const Icon(
                      FeatherIcons.plus,
                      color: kPrimaryColor,
                    )
                  : icon == 'rating'
                      ? const Icon(
                          Icons.star_outline,
                          color: kPrimaryColor,
                        )
                      : Image.asset(
                          icon,
                          height: title == "Changed Details"
                              ? SizeConfig.heightMultiplier * 2
                              : SizeConfig.heightMultiplier * 2.5,
                        ),
          SizedBox(
            width: SizeConfig.widthMultiplier * 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: SizeConfig.widthMultiplier * 60,
                child: Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 1.3,
                          color: const Color(0xFF2C2C2C)),
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 1.3,
                          color: const Color(0xFF6B7280)),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 1.5,
              ),
              SizedBox(
                width: SizeConfig.widthMultiplier * 60,
                child: Text(
                  subtitle,
                  style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.3,
                      color: const Color(0xFF6B7280)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

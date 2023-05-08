import 'package:flutter/material.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';
class ProfileButtons extends StatelessWidget {
  const ProfileButtons(
      {Key? key, required this.text, required this.icon, required this.onTap})
      : super(key: key);
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: SizeConfig.widthMultiplier * 22,
        child: Column(
          children: [
            CircleAvatar(
              radius: SizeConfig.widthMultiplier * 6,
              backgroundColor: kLightPink,
              child: Icon(
                icon,
                color: Colors.black,
                size: 21,
              ),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 0.5,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: SizeConfig.textMultiplier * 1.3,
              ),
            )
          ],
        ),
      ),
    );
  }
}

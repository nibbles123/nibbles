import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/models/place.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/dialogs/opening_hours.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/restaurent_model.dart';

class LowerHotelDetailsBody extends StatelessWidget {
  const LowerHotelDetailsBody({
    Key? key,
    required this.restaurent,
    required this.openingHours,
    required this.showHours,
  }) : super(key: key);
  final RestaurentModel restaurent;
  final CurrentOpeningHours openingHours;
  final bool showHours;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //OPENING HOURS
        const Text(
          'Location and Contact',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 3),
        //ADDRESS OF HOTEL

        HotelDetailsRowInfo(
          icon: Icons.location_on_rounded,
          text: restaurent.address!,
          isSmall: false,
        ),

        SizedBox(height: SizeConfig.heightMultiplier * 2),
        //Website
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => _launchUrl(restaurent.website!),
              child: const HotelDetailsRowInfo(
                icon: Icons.computer,
                text: 'Website ➞',
                isSmall: true,
              ),
            ),
            InkWell(
              onTap: () => _sendMail('test@gmail.com'),
              child: const HotelDetailsRowInfo(
                icon: Icons.email,
                text: 'Email ➞',
                isSmall: true,
              ),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 2,
        ),
        //PHONE NUMBER AND HOURS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => _onPhone(restaurent.phone ?? ""),
              child: HotelDetailsRowInfo(
                icon: Icons.phone_outlined,
                text: restaurent.phone ?? '',
                isSmall: true,
              ),
            ),
            InkWell(
              onTap: () => Get.dialog(OpeningHoursDialog(
                openingHours: restaurent.openingHours!,
              )),
              child: const HotelDetailsRowInfo(
                icon: Icons.alarm,
                text: 'See all hours ➞',
                isSmall: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _onPhone(String phone) {
    var phoneURL = Uri.parse("tel:$phone");
    launchUrl(phoneURL);
  }

  _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  _sendMail(String mail) async {
    // Android and iOS
    String uri = 'mailto:$mail';
    // ignore: deprecated_member_use

    // ignore: deprecated_member_use
    await launchUrl(Uri.parse(uri));
  }
}

class HotelDetailsRowInfo extends StatelessWidget {
  const HotelDetailsRowInfo(
      {Key? key,
      required this.icon,
      this.isArrowIcon = true,
      required this.text,
      required this.isSmall})
      : super(key: key);
  final IconData icon;
  final String text;
  final bool isSmall;
  final bool? isArrowIcon;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 2),
          child: SizedBox(
            width: isSmall
                ? SizeConfig.widthMultiplier * 27
                : SizeConfig.widthMultiplier * 65,
            child: Text(
              text,
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 1.6, height: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}

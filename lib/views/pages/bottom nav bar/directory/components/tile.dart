import 'package:flutter/material.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/models/restaurent_model.dart';
import 'package:nibbles/services/google_photo_service.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/bottom%20sheet/hotel%20details/hotel_details.dart';
import 'package:nibbles/views/widgets/custom_subtitle.dart';

import '../directory.dart';

class DirectoryTile extends StatelessWidget {
  const DirectoryTile({
    Key? key,
    required this.data,
    required this.widget,
    required this.whichOffer,
  }) : super(key: key);

  final RestaurentModel data;
  final DirectoryPage widget;
  final String whichOffer;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 2),
      child: InkWell(
        onTap: () {
          print('OFFER IS ${widget.isOffersPage}');
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => HotelDetailsBottomSheet(
                  whichOffer: whichOffer,
                  isOffersPage: widget.isOffersPage,
                  restaurent: data));
        },
        child: Row(
          children: [
            //PICTURE
            CircleAvatar(
              radius: SizeConfig.widthMultiplier * 7,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: data.photos!.isNotEmpty
                  ? NetworkImage(
                      GooglePhotoService.getPhotoURL(data.photos![0]))
                  : null,
            ),
            SizedBox(
              width: SizeConfig.widthMultiplier * 4,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //NAME
                SizedBox(
                  width: SizeConfig.widthMultiplier * 60,
                  child: Text(
                    data.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 0.5),
                //BOTTOM OPTIONS
                Row(
                  children: [
                    CustomSubtitle(text: data.cuisine!),
                    SizedBox(width: SizeConfig.widthMultiplier * 1),
                    CustomSubtitle(text: data.price!),
                    SizedBox(width: SizeConfig.widthMultiplier * 1),
                    CustomSubtitle(text: data.locality!)
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:nibbles/constants/images.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/pages/bottom%20nav%20bar/directory/directory.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/wishlist_tile.dart';

class OffersPage extends StatelessWidget {
  OffersPage({
    Key? key,
  });
  List offersdata = [
    {
      'Title': 'Cash Voucher',
      'Image': cashVouncher,
    },
    {
      'Title': 'Buffet Deals',
      'Image': buffetDeals,
    },
    {'Title': 'Set Deals', 'Image': setDeals}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            Row(
              children: [
                const CustomBackButton(),
                SizedBox(
                  width: SizeConfig.widthMultiplier * 6,
                ),
                Text(
                  'Offer Types',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.textMultiplier * 3.8),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 2,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: offersdata.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (_, index) => WishListHotelsTile(
                        onTap: () => Get.to(() =>  DirectoryPage(
                              isOffersPage: true,
                              whichOffer: offersdata[index]['Title'],
                            )),
                        image: offersdata[index]['Image'],
                        title: offersdata[index]['Title'],
                        isAssetImage: true,
                      )),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/models/place.dart';
import 'package:nibbles/models/restaurent_model.dart';
import 'package:nibbles/services/dynamic_links.dart';
import 'package:nibbles/services/google_photo_service.dart';
import 'package:nibbles/services/place_service.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/bottom%20sheet/hotel%20images/hotel_images.dart';
import 'package:nibbles/views/bottom%20sheet/reserve%20now/reserve_now.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/custom_shape_bottomsheet.dart';
import 'package:nibbles/views/widgets/custom_subtitle.dart';
import 'package:nibbles/views/widgets/loading.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/lower_body.dart';
import 'components/map_widget.dart';
import 'components/menu_button.dart';
import 'components/rating_tile.dart';
import 'components/rating_widget.dart';

class HotelDetailsBottomSheet extends StatelessWidget {
  const HotelDetailsBottomSheet(
      {Key? key,
      required this.restaurent,
      this.isOffersPage = false,
      this.whichOffer = ''})
      : super(key: key);
  final RestaurentModel restaurent;
  final bool isOffersPage;
  final String whichOffer;
  @override
  Widget build(BuildContext context) {
    final link = restaurent.reservationLink;

    print("Place ID ${restaurent.placeID}");
    return CustomNotchShapeBottomSheet(
      child: FutureBuilder<PlaceModel>(
          future: PlaceService.getPlace(restaurent.placeID ?? ""),
          builder: (context, snap) {
            return snap.connectionState == ConnectionState.waiting
                ? LoadingWidget(height: SizeConfig.heightMultiplier * 80)
                : Column(
                    children: [
                      const Spacer(),
                      Container(
                        height: SizeConfig.heightMultiplier * 82,
                        width: SizeConfig.widthMultiplier * 100,
                        color: Colors.white,
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.widthMultiplier * 7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //UPPER APPBAR
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const CustomBackButton(),
                                        Text(
                                          "Details",
                                          style: TextStyle(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      2.1),
                                        ),
                                        InkWell(
                                            onTap: () async {
                                            
                                              Share.share(
                                                  await DynamicLinkService
                                                      .createDynamicLink(
                                                          restaurent.id!));
                                            },
                                            child: const Icon(Icons.share))
                                      ],
                                    ),

                                    //NAME AND RATING
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              SizeConfig.heightMultiplier * 0.5,
                                          horizontal:
                                              SizeConfig.widthMultiplier * 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width:
                                                SizeConfig.widthMultiplier * 60,
                                            child: Text(
                                              restaurent.title ?? "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      3),
                                            ),
                                          ),
                                          RatingWidget(
                                            rating: snap.data?.result?.rating ??
                                                0.0,
                                            isAllRating: true,
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              SizeConfig.heightMultiplier * 0.5,
                                          horizontal:
                                              SizeConfig.widthMultiplier * 2),
                                      child: Row(
                                        children: [
                                          CustomSubtitle(
                                              text: restaurent.cuisine!),
                                          SizedBox(
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      1),
                                          CustomSubtitle(
                                              text: restaurent.price!),
                                          SizedBox(
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      1),
                                          CustomSubtitle(
                                              text: restaurent.locality!),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.heightMultiplier * 1,
                                    ),
                                    //MAP
                                    MapWidget(
                                      id: restaurent.id!,
                                      lat: snap.data!.result!.geometry!
                                          .location!.lat!,
                                      lng: snap.data!.result!.geometry!
                                          .location!.lng!,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        List<String> images = [];
                                        restaurent.photos!.forEach((val) =>
                                            images.add(
                                                GooglePhotoService.getPhotoURL(
                                                    val)));
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (_) =>
                                                HotelImagesBS(images: images));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                SizeConfig.heightMultiplier *
                                                    0.5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'More Photos',
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      1.8,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(width: 10),
                                            const Icon(
                                                Icons.arrow_right_alt_rounded)
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.heightMultiplier * 1.5,
                                    ),
                                    //RATINGS AND REVIEWS HEADING
                                    Row(
                                      children: [
                                        Text(
                                          "Ratings & Reviews",
                                          style: TextStyle(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      2.1),
                                        ),
                                        SizedBox(
                                          width: SizeConfig.widthMultiplier * 2,
                                        ),
                                        Text(
                                          "(${snap.data!.result!.reviews!.length})",
                                          style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      1.3),
                                        )
                                      ],
                                    ),
                                    //RATINGS AND REVIEWS LIST
                                    SizedBox(
                                      height: SizeConfig.heightMultiplier * 2,
                                    ),
                                    //REVIEWS LIST
                                    ListView.builder(
                                        itemCount:
                                            snap.data!.result!.reviews!.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.widthMultiplier * 2),
                                        itemBuilder: (_, index) => RatingTile(
                                              index: index,
                                              reviews: snap.data!.result!
                                                  .reviews![index],
                                            )),

                                    SizedBox(
                                      height: SizeConfig.heightMultiplier * 1,
                                    ),
                                    LowerHotelDetailsBody(
                                      showHours:
                                          snap.data?.result?.openingHours ==
                                                  null
                                              ? false
                                              : true,
                                      restaurent: restaurent,
                                      openingHours:
                                          snap.data?.result?.openingHours ??
                                              CurrentOpeningHours(),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.heightMultiplier * 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: MenuButton(
                                  isOffersPage: isOffersPage,
                                  isActive: isOffersPage
                                      ? false
                                      : link != ''
                                          ? false
                                          : true,
                                  onTap: () async {
                                    if (isOffersPage) {
                                      print(whichOffer);
                                      if (whichOffer == 'CashVouncher') {
                                        _launchUrl(restaurent.cashVouncher!);
                                      }
                                      if (whichOffer == 'BuffetDeals') {
                                        print(
                                            'GELLO ${restaurent.buffetDeals!}');
                                        _launchUrl(restaurent.buffetDeals!);
                                      }
                                      if (whichOffer == 'SetDeals') {
                                        print('GELLO ${restaurent.setDeals!}');
                                        _launchUrl(restaurent.setDeals!);
                                      }
                                    } else {
                                      _launchUrl(link!);
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
          }),
    );
  }

  void _launchUrl(String link) async {
    if (link != '') {
      if (!await launchUrl(
        Uri.parse(link),
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch url';
      }
    } else {
      print('No Reservation Link');
    }
  }
}

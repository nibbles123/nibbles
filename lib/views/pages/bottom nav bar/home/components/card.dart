import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/constants/icons.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/controllers/restaurents_controller.dart';
import 'package:nibbles/models/restaurent_model.dart';
import 'package:nibbles/services/database.dart';
import 'package:nibbles/services/like.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/bottom%20sheet/hotel%20details/hotel_details.dart';
import 'package:nibbles/views/pages/authflow/filter/filter.dart';
import 'package:nibbles/views/pages/bottom%20nav%20bar/home/components/icon_rowInfo.dart';
import 'package:nibbles/views/pages/bottom%20nav%20bar/home/components/restaurent_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RestaurentCard extends StatelessWidget {
  RestaurentCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final RestaurentModel item;
  final buttonCont = Get.find<ButtonController>();
  final authCont = Get.find<AuthController>();
  final restaurentCont = Get.find<RestaurentsController>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.heightMultiplier * 70,
      width: SizeConfig.widthMultiplier * 100,
      child: Stack(
        children: [
          //RESTAYRENT image widget
          RestaurentImage(
            item: item,
          ),

          Positioned(
            right: SizeConfig.widthMultiplier * 10,
            left: SizeConfig.widthMultiplier * 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier * 3,
                ),
                //PROFILE PICTURE
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          buttonCont.bnbSelectedIndex.value = 3;
                        },
                        child: Container(
                          height: SizeConfig.heightMultiplier * 7,
                          width: SizeConfig.widthMultiplier * 14,
                          decoration: BoxDecoration(
                              border: Border.all(color: kPrimaryColor),
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                              image: DecorationImage(
                                  image: NetworkImage(Get.find<AuthController>()
                                      .userInfo
                                      .imageURL!))),
                        )),

                    //IMAGE INDICATORS
                    Obx(
                      () => AnimatedSmoothIndicator(
                        activeIndex: restaurentCont.currentImageIndex.value,
                        count:
                            item.photos!.length >= 5 ? 5 : item.photos!.length,
                        effect: WormEffect(
                            spacing: 8.0,
                            radius: 7,
                            dotWidth: 8,
                            dotHeight: 8,
                            paintStyle: PaintingStyle.fill,
                            strokeWidth: 1.5,
                            dotColor: Colors.white.withOpacity(0.6),
                            activeDotColor: Colors.white),
                      ),
                    ),

                    InkWell(
                        onTap: () {
                          Get.to(
                              () => const FilterPage(
                                    heading: "Applied Filters",
                                  ),
                              transition: Transition.leftToRight);
                        },
                        child: const Icon(
                          Icons.filter_alt,
                          color: Colors.white,
                          size: 30,
                        ))
                  ],
                ),
              ],
            ),
          ),
          //LOWER HOTEL NAME ADDRESS AND PRICE DETAILS
          Positioned(
              left: SizeConfig.widthMultiplier * 8,
              right: SizeConfig.widthMultiplier * 8,
              bottom: SizeConfig.heightMultiplier * 3,
              child: Column(
                children: [
                  //NAME AND LIKE BUTTON
                  Row(
                    children: [
                      SizedBox(
                        width: SizeConfig.widthMultiplier * 60,
                        child: Text(
                          item.title ?? "",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 3.5,
                              shadows: const [
                                BoxShadow(color: Colors.black, blurRadius: 50)
                              ],
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => authCont.isLoading.value?print('LIKING'):LikeService.addRestaurentToLikes(item),
                        icon: Image.asset(
                          authCont.userInfo.likedRestaurents!.contains(item.id)
                              ? heartFilled
                              : heartNotFilled,
                          color: Colors.redAccent,
                          height: SizeConfig.heightMultiplier * 2.7,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 1,
                  ),
                  //PRICE
                  IconRowInfo(
                    text: item.price!,
                    icon: price,
                    color: Colors.lightGreen,
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 1,
                  ),
                  IconRowInfo(
                    text: item.locality ?? "",
                    icon: localtion,
                    color: Colors.redAccent,
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 1,
                  ),
                  Row(
                    children: [
                      IconRowInfo(
                        text: item.cuisine ?? "",
                        icon: foodType,
                        color: Colors.grey.shade700,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => HotelDetailsBottomSheet(
                                    restaurent: item,
                                  ));
                        },
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 25,
                        ),
                      )
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

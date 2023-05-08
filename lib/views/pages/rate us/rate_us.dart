import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/constants/icons.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/services/rate_us.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/widgets/custom_button.dart';

import '../../widgets/show_loading.dart';

class RateUsPage extends StatelessWidget {
  const RateUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ShowLoading(
        inAsyncCall: Get.find<AuthController>().isLoading.value,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                  InkWell(
                    onTap: () {
                      Get.find<ButtonController>().isRateUsPage.value = false;
                      Get.back();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.heightMultiplier * 2),
                      child: Image.asset(backIcon,height: SizeConfig.heightMultiplier*2.5,),
                    ),
                  ),
                  Text(
                    "Share Your Feedback",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.textMultiplier * 4),
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 1),
                  //RATING BARS
                  const CustomRatingBars(
                      whichRating: 0,
                      startText: 'Very Unsatisfied',
                      endText: 'Very Satisfied',
                      heading: 'How satisfied are you with Nibbles?'),
                  const CustomRatingBars(
                      whichRating: 1,
                      startText: 'Very Unlikely',
                      endText: 'Very Likely',
                      heading:
                          'How likely are you to visit a recommended restaurent?'),
                  const CustomRatingBars(
                      whichRating: 2,
                      startText: 'Definitely Not',
                      endText: 'Definitely Yes',
                      heading: 'Would you recommend Nibbles?'),
                  const CustomRatingBars(
                      whichRating: 3,
                      startText: '          Poor',
                      endText: 'Excellent     ',
                      heading:
                          'Rate the design and user experience of the app'),
                  const CustomRatingBars(
                      whichRating: 4,
                      startText: 'Very Unlikely',
                      endText: 'Very Likely',
                      heading:
                          'How likely are you to use Nibbles again in the future?'),
                  SizedBox(height: SizeConfig.heightMultiplier * 4),

                  CustomButton(
                      onTap: () => RateUsService.giveFeedBack(), text: 'Submit')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRatingBars extends StatelessWidget {
  const CustomRatingBars(
      {Key? key,
      required this.whichRating,
      required this.startText,
      required this.endText,
      required this.heading})
      : super(key: key);
  final int whichRating;
  final String startText, endText, heading;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.textMultiplier * 1.6),
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4),
            child: RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: SizeConfig.heightMultiplier * 6,
              itemPadding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 1.5),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: kPrimaryColor,
              ),
              unratedColor: Colors.grey.shade300,
              onRatingUpdate: (rating) {
                final buttonCont = Get.find<ButtonController>();
                if (whichRating == 0) {
                  buttonCont.satisfiedRating.value = rating;
                }
                if (whichRating == 1) {
                  buttonCont.likelyToVisitRest.value = rating;
                }
                if (whichRating == 2) {
                  buttonCont.recommendedRating.value = rating;
                }
                if (whichRating == 3) {
                  buttonCont.designRating.value = rating;
                }
                if (whichRating == 4) {
                  buttonCont.useAgainRating.value = rating;
                }
                print(rating);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 4,
                right: SizeConfig.widthMultiplier * 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  startText,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: SizeConfig.textMultiplier * 1),
                ),
                Text(
                  endText,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: SizeConfig.textMultiplier * 1),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

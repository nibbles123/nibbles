import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/controllers/filter_controller.dart';
import 'package:nibbles/controllers/restaurents_controller.dart';
import 'package:nibbles/services/database.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/bottom%20sheet/locations/locations.dart';
import 'package:nibbles/views/bottom%20sheet/reserve%20now/components/guests_slider.dart';
import 'package:nibbles/views/pages/authflow/filter/components/selected_options_list.dart';
import 'package:nibbles/views/pages/bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/next_button.dart';
import '../../../../constants/constants.dart';
import 'components/choose_button.dart';
import 'components/choose_choices.dart';
import 'components/distance_slider.dart';
import '../../../widgets/horizontal_calendar.dart';
import 'components/price_ranges.dart';
import '../../../widgets/time_tile.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key, required this.heading}) : super(key: key);
  final String heading;

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final filterCont = Get.find<FilterController>();
  final buttonCont = Get.find<ButtonController>();
  final restCont = Get.find<RestaurentsController>();
  @override
  void initState() {
    super.initState();
    if (widget.heading == "Tell us more") {
      Get.lazyPut(() => AuthController());
      Get.lazyPut(() => FilterController());
    } else {
      Future.delayed(Duration.zero, () => filterCont.getFilterData());
    }
  }

  onFilterSaved() {
    DataBase().addFilter(
        filterCont.selectedPrice,
        filterCont.distanceSliderVal.value.toInt(),
        filterCont.selectedDate.value,
        filterCont.selectedTime.value,
        filterCont.filterChoices,
        filterCont.selectedLocality,
        filterCont.selectedDateIndex.value,
        filterCont.isNearby.value);
  }

  onClearAllFilter() {
    filterCont.selectedPrice.value = [];
    filterCont.selectedDateIndex.value = (-1);
    filterCont.selectedTimeIndex.value = (-1);
    filterCont.selectedTime.value = "";
    filterCont.filterChoices.clear();
    filterCont.distanceSliderVal.value = 0;
    filterCont.guestSliderVal.value = 0;
    filterCont.selectedLocality.value = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: widget.heading == "Tell us more"
          ? Container(
              height: SizeConfig.heightMultiplier * 14,
              width: SizeConfig.widthMultiplier * 100,
              color: Colors.white,
              child: Center(
                  child: Padding(
                padding:
                    EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 2),
                child: NextButton(onTap: () async {
                  await onFilterSaved();
                  filterCont.getFilterData();
                  restCont.cardCont.value!.currentIndex = 0;
                  buttonCont.onCardComplete.value = false;
                  Get.to(() => BottomNavBar(),
                      transition: Transition.rightToLeft);
                }),
              )),
            )
          : const SizedBox(),
      body: Obx(
        () => SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 6),
              child: Row(
                children: [
                  const CustomBackButton(),
                  widget.heading == "Tell us more"
                      ? const SizedBox()
                      : const Spacer(),
                  widget.heading == "Tell us more"
                      ? const SizedBox()
                      : TextButton(
                          onPressed: () async {
                            await onFilterSaved();
                            filterCont.getFilterData();
                            restCont.cardCont.value!.currentIndex = 0;
                            buttonCont.onCardComplete.value = false;
                            Get.back();
                          },
                          child: Text(
                            'Apply',
                            style: TextStyle(
                                fontSize: 16,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w500),
                          ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 6),
              child: Text(
                widget.heading,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.textMultiplier * 3.4),
              ),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 1,
            ),
            //PRICE
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 8),
              child: Row(
                children: [
                  Text(
                    "Price Range".toUpperCase(),
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.6,
                        fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => onClearAllFilter(),
                    child: Text(
                      "Clear ALl".toUpperCase(),
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 1.5,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            const PriceRanges(),
            //DISTANCE
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 8),
              child: Row(
                children: [
                  Text(
                    "Distance".toUpperCase(),
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.6,
                        fontWeight: FontWeight.w700),
                  ),
                  // const Spacer(),
                  SizedBox(width: SizeConfig.widthMultiplier * 2),
                  Text(
                    "(${filterCont.distanceSliderVal.value.toInt()}km)",
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.5,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  //IS NEARBY SWITCH
                  Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                        value: filterCont.isNearby.value,
                        activeColor: kPrimaryColor,
                        onChanged: (val) {
                          filterCont.isNearby.value = val;
                        }),
                  )
                ],
              ),
            ),
            //DISTANCE SLIDER
            DistanceSlider(buttonCont: filterCont),

            //LOCALITY
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.heightMultiplier * 1,
                  horizontal: SizeConfig.widthMultiplier * 9),
              child: Text(
                "Locality".toUpperCase(),
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 1.6,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Center(
              child: CustomChooseButton(
                text: "Choose Locality",
                onTap: () {
                  if (!filterCont.isNearby.value) {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const LocationBottomSheet());
                  }
                },
              ),
            ),
            Obx(
              () => SelectedOptionList(
                  list: filterCont.selectedLocality.value,
                  isGrey: filterCont.isNearby.value ? true : false),
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            //DATE
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 8,
              ),
              child: Text(
                "Date".toUpperCase(),
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 1.6,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            const HorizontalCalendar(),
            //TIME
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 8,
                  vertical: SizeConfig.heightMultiplier * 2),
              child: Text(
                "Time".toUpperCase(),
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 1.6,
                    fontWeight: FontWeight.w700),
              ),
            ),
            //TIME GRID
            SizedBox(
              height: SizeConfig.heightMultiplier * 20,
              width: SizeConfig.widthMultiplier * 100,
              child: AnimationLimiter(
                child: GridView.count(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 6),
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: SizeConfig.widthMultiplier * 3,
                  mainAxisSpacing: SizeConfig.heightMultiplier * 1.2,
                  childAspectRatio: 2.7,
                  children: List.generate(
                    timeList.length,
                    (int index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        columnCount: 2,
                        child: ScaleAnimation(
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: FadeInAnimation(
                            child: TimeTile(
                              text: timeList[index],
                              index: index,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            widget.heading == "Tell us more"
                ? const SizedBox()
                : const ChooseChoices(),
            //GUESTS
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 9),
              child: Row(
                children: [
                  Text(
                    "Guests".toUpperCase(),
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.6,
                        fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Text(
                    "${filterCont.guestSliderVal.value.toInt()} guests",
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.5,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 3),
              child: GuestsSlider(buttonCont: filterCont),
            ),
            SizedBox(
              height: widget.heading == "Tell us more"
                  ? SizeConfig.heightMultiplier * 30
                  : SizeConfig.heightMultiplier * 10,
            ),
          ]),
        ),
      ),
    );
  }
}

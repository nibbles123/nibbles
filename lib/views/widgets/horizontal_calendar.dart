import 'package:animated_horizontal_calendar/utils/calender_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/controllers/filter_controller.dart';
import 'package:nibbles/utils/size_config.dart';

class HorizontalCalendar extends StatefulWidget {
  const HorizontalCalendar({
    Key? key,
  }) : super(key: key);

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  DateTime? _startDate;
  var selectedCalenderDate;
  @override
  void initState() {
    super.initState();
    selectedCalenderDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final buttonCont = Get.find<FilterController>();
    double width = MediaQuery.of(context).size.width;

    DateTime findFirstDateOfTheWeek(DateTime dateTime) {
      if (dateTime.weekday == 7) {
        return dateTime;
      } else {
        if (dateTime.weekday == 1 || dateTime.weekday == 2) {}
        return dateTime.subtract(Duration(days: dateTime.weekday));
      }
    }

    _startDate = findFirstDateOfTheWeek(selectedCalenderDate);
    return SizedBox(
      height: SizeConfig.heightMultiplier * 14,
      width: SizeConfig.widthMultiplier * 100,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 30,
                padding: const EdgeInsets.all(0),
                itemBuilder: (_, index) {
                  DateTime? _date = _startDate?.add(Duration(days: index));

                  return GestureDetector(
                    onTap: () {
                      
                      buttonCont.selectedDateIndex.value = index;
                      buttonCont.selectedDate.value = _date.toString();
                    },
                    child: Obx(
                      () => AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        height: SizeConfig.heightMultiplier * 11,
                        width: SizeConfig.widthMultiplier * 22,
                        margin: EdgeInsets.only(
                            left:
                                index == 0 ? SizeConfig.widthMultiplier * 6 : 0,
                            right: SizeConfig.widthMultiplier * 3,
                            bottom: SizeConfig.heightMultiplier * 2),
                        decoration: BoxDecoration(
                            color: buttonCont.selectedDateIndex.value == index
                                ? selectedTileColor
                                : Colors.white,
                            boxShadow: buttonCont.selectedDateIndex.value ==
                                    index
                                ? [
                                    BoxShadow(
                                        color:
                                            selectedTileColor.withOpacity(0.6),
                                        blurRadius: 15,
                                        offset: const Offset(5, 8))
                                  ]
                                : null,
                            borderRadius: BorderRadius.circular(10),
                            border: buttonCont.selectedDateIndex.value == index
                                ? null
                                : Border.all(color: Colors.grey.shade300)),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Utils.getDayOfMonth(_date!),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeConfig.textMultiplier * 2.8),
                            ),
                            SizedBox(
                              height: SizeConfig.heightMultiplier * 1.5,
                            ),
                            Text(
                              Utils.getDayOfWeek(_date).toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: SizeConfig.textMultiplier * 1.1),
                            )
                          ],
                        )),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

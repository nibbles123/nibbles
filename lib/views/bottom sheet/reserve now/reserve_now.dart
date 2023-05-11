import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/constants.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/controllers/filter_controller.dart';
import 'package:nibbles/models/reserved_hotels.dart';
import 'package:nibbles/models/restaurent_model.dart';
import 'package:nibbles/models/timeslots_model.dart';
import 'package:nibbles/services/database.dart';
import 'package:nibbles/services/google_photo_service.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/bottom%20sheet/reserve%20now/components/guests_slider.dart';
import 'package:nibbles/views/widgets/custom_shape_bottomsheet.dart';
import 'package:nibbles/views/widgets/horizontal_calendar.dart';
import 'package:nibbles/views/widgets/show_loading.dart';
import 'package:nibbles/views/widgets/time_tile.dart';
import 'package:nibbles/views/pages/bottom%20nav%20bar/home/components/reserve_button.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:http/http.dart' as http;

class ReserveNowBottomSheet extends StatefulWidget {
  const ReserveNowBottomSheet(
      {Key? key,
      required this.isUpdate,
      required this.title,
      required this.img,
      required this.address,
      required this.id,
      this.reservedModel,
      this.model})
      : super(key: key);
  // final dynamic restaurentModel;
  final bool isUpdate;
  final String title, img, address, id;
  final ReservedModel? reservedModel;
  final RestaurentModel? model;
  @override
  State<ReserveNowBottomSheet> createState() => _ReserveNowBottomSheetState();
}

class _ReserveNowBottomSheetState extends State<ReserveNowBottomSheet> {
  final filterCont = Get.find<FilterController>();
  final authCont = Get.find<AuthController>();

  @override
  void dispose() {
    super.dispose();
    clearingValues();
  }

  Future<TimeslotsModel> getTimeSlot() async {
    var date = DateTime.parse(filterCont.selectedDate.value);
    print(date.millisecondsSinceEpoch);

    var chopeID = widget.model!.chopeID!;
    var id = widget.model!.id!;
    print(filterCont.selectedDate.toString());
    print(filterCont.selectedTime.toString());
    // return;
    print("ChopeID $chopeID");
    print("restaurantID $id");

    //Convert 1:30 AM to DateTime
    // var time = DateTime(2023, 5, 18, 13, 02);

    // var time = DateTime.now();

    // var date = DateTime.parse(filterCont.selectedDate.value);

    //there is not the code of getting name , phone number , email , and notes so I do the static in url
    //get name
    var url =
        "https://chopeapi.zhuo88.com/bookings/timeslots?restaurant_id=$chopeID&date_time=${date.millisecondsSinceEpoch}&adults=${filterCont.guestSliderVal.value.toString()}&children=0&language=en_US";

    print(url);
    final response = await http.get(Uri.parse(url),
        //add headers
        headers: {
          'Authorization': 'Bearer NeJeVHEmWR86T0ZTaNtMXGSlZiKEDDCTcMzyXiZT',
        }).catchError((error) {
      debugPrint(error);

      return error;
    });

    print(response.statusCode);
    if (response.statusCode == 200) {
      // yield json.decode(response.body);
      var jsonResponse = json.decode(response.body);

      TimeslotsModel model = TimeslotsModel.fromJson(jsonResponse);
      return model;
    } else {
      return Future.error(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      Future.delayed(Duration.zero, () => getReservedHotelDetail());
    }
    // _stream = _controller.stream;
    // if (widget.model != null) {
    //   getTimeSlot();
    // }
  }

  getReservedHotelDetail() {
    filterCont.guestSliderVal.value =
        double.parse(widget.reservedModel!.guests!);
    filterCont.selectedDate.value = widget.reservedModel!.reservedDate!;
    filterCont.selectedDateIndex.value = widget.reservedModel!.dateIndex!;
    filterCont.selectedTime.value = widget.reservedModel!.time!;
    for (int t = 0; t < timeList.length; t++) {
      if (timeList[t] == widget.reservedModel!.time) {
        filterCont.selectedTimeIndex.value = t;
        break;
      }
    }
  }

  final StreamController<TimeslotsModel> _controller = StreamController();
  late Stream<TimeslotsModel> _stream;

  @override
  Widget build(BuildContext context) {
    return CustomNotchShapeBottomSheet(
      child: Obx(
        () => ShowLoading(
          opacity: 0.01,
          inAsyncCall: authCont.isLoading.value,
          child: Column(children: [
            SizedBox(
              height: SizeConfig.heightMultiplier * 4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomBackButton(),
                  Text(
                    "Review Details",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: SizeConfig.textMultiplier * 2.1),
                  ),
                  SizedBox(
                    width: SizeConfig.widthMultiplier * 8,
                  )
                ],
              ),
            ),
            //HOTEL IMAGE
            Container(
              height: SizeConfig.heightMultiplier * 13,
              width: SizeConfig.widthMultiplier * 90,
              margin: EdgeInsets.only(
                  bottom: SizeConfig.heightMultiplier * 3,
                  top: SizeConfig.heightMultiplier * 0.5),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  image: DecorationImage(
                      image: NetworkImage(
                          GooglePhotoService.getPhotoURL(widget.img)),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(22)),
            ),
            //GUESTS
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 6),
              child: Row(
                children: [
                  Text(
                    "Guests".toUpperCase(),
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.6,
                        fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Obx(
                    () => Text(
                      "${filterCont.guestSliderVal.value.toInt()} guests",
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 1.5,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),

            //GUEST SLIDER
            GuestsSlider(buttonCont: filterCont),
            SizedBox(
              height: SizeConfig.heightMultiplier * 3,
            ),
            const HorizontalCalendar(),
            SizedBox(
              height: SizeConfig.heightMultiplier * 2,
            ),
            //TIME GRID

            // widget.model != null
            //     ? Expanded(
            //         child: StreamBuilder<TimeslotsModel>(
            //             builder: (context, snapshot) {
            //               if (snapshot.connectionState ==
            //                   ConnectionState.waiting) {
            //                 return const Center(
            //                   child: CircularProgressIndicator(),
            //                 );
            //               }
            //               if (snapshot.hasData) {
            //                 var timeList = snapshot.data!.result!.timeslots!
            //                     .map((e) => e.time)
            //                     .toList();
            //                 print(timeList);
            //                 return SizedBox(
            //                   height: SizeConfig.heightMultiplier * 21,
            //                   width: SizeConfig.widthMultiplier * 100,
            //                   child: AnimationLimiter(
            //                     child: GridView.count(
            //                       padding: EdgeInsets.symmetric(
            //                           vertical: SizeConfig.heightMultiplier * 1,
            //                           horizontal:
            //                               SizeConfig.widthMultiplier * 6),
            //                       physics: const NeverScrollableScrollPhysics(),
            //                       crossAxisCount: 3,
            //                       crossAxisSpacing:
            //                           SizeConfig.widthMultiplier * 3,
            //                       mainAxisSpacing:
            //                           SizeConfig.heightMultiplier * 1.2,
            //                       childAspectRatio: 2.7,
            //                       children: List.generate(
            //                         snapshot.data!.result!.timeslots!.length,
            //                         (int index) {
            //                           return AnimationConfiguration
            //                               .staggeredGrid(
            //                             position: index,
            //                             duration:
            //                                 const Duration(milliseconds: 500),
            //                             columnCount: 2,
            //                             child: ScaleAnimation(
            //                               duration:
            //                                   const Duration(milliseconds: 900),
            //                               curve: Curves.fastLinearToSlowEaseIn,
            //                               child: FadeInAnimation(
            //                                 child: TimeTile(
            //                                   text: snapshot.data!.result!
            //                                       .timeslots![index].time
            //                                       .toString(),
            //                                   index: index,
            //                                 ),
            //                               ),
            //                             ),
            //                           );
            //                         },
            //                       ),
            //                     ),
            //                   ),
            //                 );

            //                 // return ListView.builder(
            //                 //     itemBuilder: (context, index) {
            //                 //   var model = snapshot.data;
            //                 //   return TimeTile(
            //                 //     text: model!.result!.timeslots![index].time!
            //                 //         .toString(),
            //                 //     index: index,
            //                 //   );
            //                 // });
            //               }

            //               return Container();
            //             },
            //             stream: _stream),
            //       )
            //     :
            SizedBox(
              height: SizeConfig.heightMultiplier * 21,
              width: SizeConfig.widthMultiplier * 100,
              child: AnimationLimiter(
                child: GridView.count(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.heightMultiplier * 1,
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
            ReserveButton(
                isUpdate: widget.isUpdate,
                isReserved: false,
                onTap: () async {
                  if (filterCont.selectedDate.value.isNotEmpty &&
                      filterCont.selectedTimeIndex.value != -1) {
                    print(filterCont.selectedTime.value.toString());
                    // return;
                    if (widget.isUpdate) {
                      DataBase().updateReservation(
                          widget.reservedModel!.id!,
                          filterCont.guestSliderVal.value.toString(),
                          filterCont.selectedDate.value,
                          filterCont.selectedDateIndex.value,
                          filterCont.selectedTime.value);
                      return;
                    }

                    authCont.isLoading.value = true;

                    if (widget.model == null) {
                      return;
                    }

                    await getTimeSlot().then((value) {
                      if (value.result?.status == "CLOSE") {
                        authCont.isLoading.value = false;
                        Get.snackbar("Sorry", "This restaurant is closed",
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                        return;
                      }
                      //2023-05-08 20:57:50.919072 to DateTime
                      var date = DateTime.parse(filterCont.selectedDate.value);
                      print(date.millisecondsSinceEpoch);

                      //convert date to timestamp

                      var time = Timestamp.fromDate(date);
                      print(time);
                      // return;

                      var chopeID = widget.model!.chopeID!;
                      var id = widget.model!.id!;
                      print(filterCont.selectedDate.toString());
                      print(filterCont.selectedTime.toString());
                      // return;
                      print("ChopeID $chopeID");
                      print("restaurantID $id");

                      // var time = DateTime.now();

                      //there is not the code of getting name , phone number , email , and notes so I do the static in url
                      //get name
                      var url =
                          "https://chopeapi.zhuo88.com/bookings/calendar?restaurant_id=${chopeID}&start_date=${date.millisecondsSinceEpoch}&adults=${filterCont.guestSliderVal.value.toString()}&children=0&language=en_US";
                      // https: //chopeapi.zhuo88.com

//for now on I add the API but it's not working as expected ...
                      http.get(Uri.parse(url), headers: {
                        "Authorization":
                            "Bearer NeJeVHEmWR86T0ZTaNtMXGSlZiKEDDCTcMzyXiZT"
                      }).catchError((e) {
                        authCont.isLoading.value = false;
                        Get.snackbar("Please try again", e.toString(),
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white);
                        return e;
                      }).then((response) {
                        authCont.isLoading.value = false;
                        print(response.statusCode);
                        if (response.statusCode == 200) {
                          Get.snackbar(
                              "Booking Success", "Your booking is success",
                              backgroundColor: Colors.green,
                              colorText: Colors.white);
                          // Get.back();
                          var jsonResponse = json.decode(response.body);
                          print("Success");
                          print(jsonResponse);

                          // return model;
                        } else {
                          var jsonResponse = json.decode(response.body);
                          print('Request failed with status: $jsonResponse.');
                          Get.snackbar("Please try again", "Error",
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white);
                          // Get.back();
                        }
                      }).catchError((e) {
                        print(e);
                        Get.snackbar("Please try again", e.toString(),
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white);
                        authCont.isLoading.value = false;
                        return e;
                      });
                    }).catchError((e) {
                      authCont.isLoading.value = false;
                      print(e);
                    });
                  } else {
                    Get.snackbar(
                        "Please try again", "Select all the required data",
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white);
                  }
                })
          ]),
        ),
      ),
    );
  }

  clearingValues() {
    filterCont.selectedDate.value = "";
    filterCont.selectedDateIndex.value = -1;
    filterCont.guestSliderVal.value = 6;
    filterCont.selectedTimeIndex.value = -1;
  }
}

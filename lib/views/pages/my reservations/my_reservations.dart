import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/controllers/reserve_hotels.dart';
import 'package:nibbles/models/restaurent_model.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/bottom%20sheet/hotel%20details/hotel_details.dart';
import 'package:nibbles/views/bottom%20sheet/reserve%20now/reserve_now.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:intl/intl.dart';
import 'package:nibbles/views/widgets/loading.dart';
import 'package:nibbles/views/widgets/no_data.dart';

class MyReservationsPage extends StatelessWidget {
  const MyReservationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, dd,yy');
    final reserveHotels = Get.put(ReserveHotelsCont());
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
                  "Reservations",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.textMultiplier * 3.8),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 2,
            ),
            Obx(
              () => reserveHotels.getReserveHotels == null
                  ? LoadingWidget(height: SizeConfig.heightMultiplier * 75)
                  : reserveHotels.getReserveHotels!.isEmpty
                      ? NoDataWidget(
                          noDataText: "No Reservations Yet!",
                          height: SizeConfig.heightMultiplier * 75)
                      : Expanded(
                          child: ListView.builder(
                              itemCount: reserveHotels.getReserveHotels!.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (_, index) {
                                final hotel =
                                    reserveHotels.getReserveHotels![index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right:
                                              SizeConfig.widthMultiplier * 10,
                                          left: SizeConfig.widthMultiplier * 5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:
                                                SizeConfig.widthMultiplier * 60,
                                            child: Text(
                                              hotel.hotelName ?? "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      2,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () => showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor: Colors
                                                    .transparent,
                                                builder: (_) =>
                                                    ReserveNowBottomSheet(
                                                        reservedModel: hotel,
                                                        isUpdate: true,
                                                        title:
                                                            hotel.hotelName ??
                                                                "",
                                                        img: hotel.imgURL ?? "",
                                                        address: hotel
                                                                .hotelLocation ??
                                                            "",
                                                        id: "")),
                                            child: const Icon(
                                              Icons.edit,
                                              size: 20,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.heightMultiplier * 1,
                                    ),
                                    Container(
                                      height: SizeConfig.heightMultiplier * 13,
                                      width: SizeConfig.widthMultiplier * 90,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  hotel.imgURL ?? ""),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(22)),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.heightMultiplier * 1,
                                    ),
                                    //LOCATION AND DATE
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              SizeConfig.heightMultiplier * 1,
                                          horizontal:
                                              SizeConfig.widthMultiplier * 5),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_outlined,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: SizeConfig.widthMultiplier *
                                                2.5,
                                          ),
                                          Text(
                                            "${dateFormat.format(DateTime.parse(hotel.reservedDate!))}, ${hotel.time}",
                                            style: TextStyle(
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        1.4,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width:
                                                SizeConfig.widthMultiplier * 3,
                                          ),
                                          Text(
                                            "${double.parse(hotel.guests.toString()).toInt()} guests",
                                            style: TextStyle(
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        1.3,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              SizeConfig.heightMultiplier * 0.5,
                                          horizontal:
                                              SizeConfig.widthMultiplier * 4.5),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 19,
                                          ),
                                          SizedBox(
                                            width: SizeConfig.widthMultiplier *
                                                2.5,
                                          ),
                                          SizedBox(
                                            width:
                                                SizeConfig.widthMultiplier * 65,
                                            child: Text(
                                              hotel.hotelLocation ?? "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      1.4,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: SizeConfig.heightMultiplier * 1.5,
                                    ),
                                    index == 0
                                        ? const SizedBox()
                                        : Divider(
                                            height:
                                                SizeConfig.heightMultiplier * 1,
                                          )
                                  ],
                                );
                              }),
                        ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/controllers/filter_controller.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/custom_shape_bottomsheet.dart';
import 'package:nibbles/views/widgets/loading.dart';

class LocationBottomSheet extends StatefulWidget {
  const LocationBottomSheet({Key? key}) : super(key: key);

  @override
  State<LocationBottomSheet> createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet> {
  final filterCont = Get.find<FilterController>();

  @override
  void initState() {
    super.initState();
    filterCont.isGetLocation.value = true;
    Future.delayed(Duration.zero, () {
      if (filterCont.allLocalities.isEmpty) {
        filterCont
            .gettingallLocalities()
            .then((value) => filterCont.isGetLocation.value = false);
      } else {
        filterCont.isGetLocation.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomNotchShapeBottomSheet(
      isBigSheet: false,
      child: Obx(
        () => Column(
          children: [
            SizedBox(
              height: SizeConfig.heightMultiplier * 2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.heightMultiplier * 2,
                  horizontal: SizeConfig.widthMultiplier * 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomBackButton(),
                  Text(
                    "Choose Locality",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: SizeConfig.textMultiplier * 2.1),
                  ),
                  SizedBox(
                    width: SizeConfig.widthMultiplier * 8,
                  ),
                ],
              ),
            ),
            filterCont.isGetLocation.value
                ? LoadingWidget(height: SizeConfig.heightMultiplier * 30)
                : Expanded(
                    child: ListView.builder(
                        itemCount: filterCont.allLocalities.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.widthMultiplier * 9),
                        itemBuilder: (_, index) => Padding(
                              padding: EdgeInsets.only(
                                  bottom: SizeConfig.heightMultiplier * 1),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => InkWell(
                                      onTap: () {
                                        if (filterCont.selectedLocality
                                            .contains(filterCont
                                                .allLocalities[index])) {
                                          filterCont.selectedLocality.remove(
                                              filterCont.allLocalities[index]);
                                        } else {
                                          filterCont.selectedLocality.add(
                                              filterCont.allLocalities[index]);
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        height:
                                            SizeConfig.heightMultiplier * 1.8,
                                        width: SizeConfig.widthMultiplier * 4,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(1),
                                            color: filterCont.selectedLocality
                                                    .contains(filterCont
                                                        .allLocalities[index])
                                                ? selectedTileColor
                                                : Colors.white,
                                            border: filterCont.selectedLocality
                                                    .contains(filterCont
                                                        .allLocalities[index])
                                                ? null
                                                : Border.all(
                                                    color: Colors.black)),
                                        child: filterCont.selectedLocality
                                                .contains(filterCont
                                                    .allLocalities[index])
                                            ? const Icon(
                                                Icons.done,
                                                size: 14,
                                                color: Colors.white,
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.widthMultiplier * 4,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.widthMultiplier * 70,
                                    child: Text(
                                      filterCont.allLocalities[index]
                                          .toString()
                                          .split(", Singapore")[0],
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.textMultiplier * 1.7,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            )))
          ],
        ),
      ),
    );
  }
}

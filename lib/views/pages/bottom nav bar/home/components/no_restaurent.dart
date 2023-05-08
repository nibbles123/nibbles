import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/pages/authflow/filter/filter.dart';
import 'package:nibbles/views/widgets/custom_button.dart';
import 'package:nibbles/views/widgets/no_data.dart';

class NoRestaurents extends StatelessWidget {
  const NoRestaurents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NoDataWidget(
              noDataText: "No Items Found!",
              height:
                  SizeConfig.heightMultiplier * 28),
          CustomButton(
              onTap: () =>
                  Get.to(() => const FilterPage(
                        heading: 'Filter',
                      )),
              text: "Change Filter"),
        ],
      )));
  }
}

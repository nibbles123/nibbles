import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/controllers/filter_controller.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DistanceSlider extends StatelessWidget {
  const DistanceSlider({
    Key? key,
    required this.buttonCont,
  }) : super(key: key);

  final FilterController buttonCont;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 2),
      child: Obx(
        () => SfSlider(
          min: 0.0,
          max: 100.0,
          value: buttonCont.distanceSliderVal.value.toInt(),
          interval: 20,
          showTicks: false,
          showLabels: false,
          activeColor: selectedTileColor,
          inactiveColor: Colors.grey.shade300,
          thumbIcon: Container(
            height: SizeConfig.heightMultiplier * 6,
            width: SizeConfig.widthMultiplier * 10,
            decoration: BoxDecoration(
                color: selectedTileColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8)
                ]),
          ),
          enableTooltip: true,
          minorTicksPerInterval: 1,
          onChanged: (dynamic value) {
            buttonCont.distanceSliderVal.value = value;
          },
        ),
      ),
    );
  }
}

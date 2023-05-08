import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/filter_controller.dart';
import 'package:nibbles/utils/size_config.dart';

class TimeTile extends StatelessWidget {
  const TimeTile({
    Key? key,
    required this.text,
    required this.index,
  }) : super(key: key);
  final String text;
  final int index;
  @override
  Widget build(BuildContext context) {
    final buttonCont = Get.find<FilterController>();
    return GestureDetector(
      onTap: () {
        buttonCont.selectedTime.value = text;
        buttonCont.selectedTimeIndex.value = index;
      },
      child: Obx(
        () => AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
                boxShadow: buttonCont.selectedTimeIndex.value == index
                    ? [
                        BoxShadow(
                            color: selectedTileColor.withOpacity(0.6),
                            blurRadius: 15,
                            offset: const Offset(5, 8))
                      ]
                    : null,
                color: buttonCont.selectedTimeIndex.value == index
                    ? selectedTileColor
                    : Colors.white,
                border: buttonCont.selectedTimeIndex.value == index
                    ? null
                    : Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: buttonCont.selectedTimeIndex.value == index
                        ? Colors.white
                        : Colors.black,
                    fontSize: SizeConfig.textMultiplier * 1.5),
              ),
            )),
      ),
    );
  }
}

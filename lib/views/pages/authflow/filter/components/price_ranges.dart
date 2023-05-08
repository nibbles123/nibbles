import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/controllers/filter_controller.dart';
import 'package:nibbles/utils/size_config.dart';

class PriceRanges extends StatelessWidget {
  const PriceRanges({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> prices = ["\$", "\$\$", "\$\$\$", "\$\$\$\$"];
    final buttonCont = Get.find<FilterController>();

    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
              prices.length,
              (index) => GestureDetector(
                    onTap: () {
                      if (buttonCont.selectedPrice.contains(prices[index])) {
                        buttonCont.selectedPrice.remove(prices[index]);
                      } else {
                        buttonCont.selectedPrice.add(prices[index]);
                      }
                    },
                    child: Obx(
                      () => AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        height: SizeConfig.heightMultiplier * 7,
                        width: SizeConfig.widthMultiplier * 14,
                        margin: EdgeInsets.only(
                            left: index == 0
                                ? SizeConfig.widthMultiplier * 6
                                : SizeConfig.widthMultiplier * 3,
                            right: index == prices.length - 1
                                ? SizeConfig.widthMultiplier * 6
                                : 0,
                            top: SizeConfig.heightMultiplier * 1,
                            bottom: SizeConfig.heightMultiplier * 5),
                        decoration: BoxDecoration(
                            color: buttonCont.selectedPrice
                                    .contains(prices[index])
                                ? selectedTileColor
                                : const Color(0xFFF8F8F8),
                            boxShadow: buttonCont.selectedPrice
                                    .contains(prices[index])
                                ? [
                                    BoxShadow(
                                        color:
                                            selectedTileColor.withOpacity(0.6),
                                        blurRadius: 15,
                                        offset: const Offset(5, 8))
                                  ]
                                : null,
                            border:
                                buttonCont.selectedPrice.contains(prices[index])
                                    ? null
                                    : Border.all(
                                        color: const Color(0xFF979797)
                                            .withOpacity(0.2)),
                            shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            prices[index],
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 1.6,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ))
        ],
      ),
    );
  }
}

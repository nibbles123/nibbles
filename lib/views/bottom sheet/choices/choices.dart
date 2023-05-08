import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/filter_controller.dart';
import 'package:nibbles/models/choices.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/pages/authflow/choices/components/tile.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/custom_shape_bottomsheet.dart';

class CuisineChoicesBottomSheet extends StatefulWidget {
  const CuisineChoicesBottomSheet({Key? key}) : super(key: key);

  @override
  State<CuisineChoicesBottomSheet> createState() => _CuisineChoicesBottomSheetState();
}

class _CuisineChoicesBottomSheetState extends State<CuisineChoicesBottomSheet> {
    final buttonCont = Get.find<FilterController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      buttonCont.selectedChoices.value=[];
      buttonCont.selectedChoices.addAll(buttonCont.filterChoices);
    });
  }
  @override
  Widget build(BuildContext context) {
    return CustomNotchShapeBottomSheet(
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.heightMultiplier * 2,
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: SizeConfig.heightMultiplier * 2,
                left: SizeConfig.widthMultiplier * 8,
                right: SizeConfig.widthMultiplier * 4,
                top: SizeConfig.heightMultiplier * 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomBackButton(),
                Text(
                  "Select preffered cuisines",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.textMultiplier * 2.1),
                ),
                TextButton(
                    onPressed: () {
                
                      buttonCont.filterChoices.value=[];
                      buttonCont.filterChoices.addAll(buttonCont.selectedChoices);
                      Get.back();
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: kPrimaryColor),
                    ))
              ],
            ),
          ),
          Expanded(
            child: AnimationLimiter(
              child: GridView.count(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.heightMultiplier * 0.5,
                    horizontal: SizeConfig.widthMultiplier * 6),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                crossAxisCount: 2,
                childAspectRatio: 2.1,
                children: List.generate(
                  choicesList.length,
                  (int index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      columnCount: 2,
                      child: ScaleAnimation(
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: FadeInAnimation(
                          child: ChoicesTile(index: index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 5,
          )
        ],
      ),
    );
  }
}

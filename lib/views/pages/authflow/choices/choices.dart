import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/controllers/filter_controller.dart';
import 'package:nibbles/models/choices.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/pages/authflow/filter/filter.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/next_button.dart';

import 'components/tile.dart';

class ChoicesPage extends StatelessWidget {
  const ChoicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FilterController());
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 5,
              ),
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 6),
                child: const CustomBackButton(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 6),
                child: Text(
                  "Cuisine Choices",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.textMultiplier * 3.4),
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 8),
                child: Text(
                  "Select preffered cuisines",
                  style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.6,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 3,
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
                height: SizeConfig.heightMultiplier * 10,
              ),
            ],
          ),
          Positioned(
              bottom: SizeConfig.heightMultiplier * 4,
              left: SizeConfig.widthMultiplier * 5,
              right: SizeConfig.widthMultiplier * 5,
              child: NextButton(
                onTap: () {
                  final buttonCont = Get.find<FilterController>();
                  buttonCont.filterChoices.value = [];
                  buttonCont.filterChoices.addAll(buttonCont.selectedChoices);
                  Get.to(
                      () => const FilterPage(
                            heading: "Tell us more",
                          ),
                      transition: Transition.leftToRight);
                },
              ))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/filter_controller.dart';
import 'package:nibbles/models/choices.dart';
import 'package:nibbles/utils/size_config.dart';

class ChoicesTile extends StatelessWidget {
  const ChoicesTile({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    final buttonCont = Get.find<FilterController>();
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (buttonCont.selectedChoices.contains(choicesList[index].name)) {
            buttonCont.selectedChoices.remove(choicesList[index].name);
          } else {
            buttonCont.selectedChoices.add(choicesList[index].name);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: EdgeInsets.only(
              left: index.isOdd ? SizeConfig.widthMultiplier * 3 : 0,
              bottom: SizeConfig.heightMultiplier * 2,
              right: index.isEven ? SizeConfig.widthMultiplier * 3 : 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color:
                  buttonCont.selectedChoices.contains(choicesList[index].name)
                      ? selectedTileColor
                      : Colors.white,
              boxShadow:
                  buttonCont.selectedChoices.contains(choicesList[index].name)
                      ? [
                          BoxShadow(
                              color: selectedTileColor.withOpacity(0.6),
                              blurRadius: 15,
                              offset: const Offset(5, 8))
                        ]
                      : null,
              border:
                  buttonCont.selectedChoices.contains(choicesList[index].name)
                      ? null
                      : Border.all(color: const Color(0xFFE8E6EA))),
          child: Row(
            children: [
              SizedBox(
                width: SizeConfig.widthMultiplier * 3,
              ),
              Image.asset(
                choicesList[index].image,
                height: SizeConfig.heightMultiplier * 3.2,
              ),
              SizedBox(
                width: SizeConfig.widthMultiplier * 2,
              ),
              SizedBox(
                width: SizeConfig.widthMultiplier * 28,
                child: Text(
                  choicesList[index].name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.6,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

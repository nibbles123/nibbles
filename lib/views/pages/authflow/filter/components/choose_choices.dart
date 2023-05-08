import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/filter_controller.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/bottom%20sheet/choices/choices.dart';
import 'package:nibbles/views/pages/authflow/filter/components/choose_button.dart';
import 'package:nibbles/views/pages/authflow/filter/components/selected_options_list.dart';

class ChooseChoices extends StatelessWidget {
  const ChooseChoices({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonCont = Get.find<FilterController>();
    return Obx(
      ()=> Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SELECT CUISINE CHOICES
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 8),
            child: Text(
              "Cuisine Choices".toUpperCase(),
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 1.6,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 2,
          ),
    
          Center(
            child: CustomChooseButton(
              text: "Choose Cuisine",
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const CuisineChoicesBottomSheet());
              },
            ),
          ),
           SelectedOptionList(list: buttonCont.filterChoices,isGrey: false,),
             
           
          
           SizedBox(
                height: buttonCont.filterChoices.isEmpty
                    ? SizeConfig.heightMultiplier * 2
                    : 0,
              )
        ],
      ),
    );
  }
}

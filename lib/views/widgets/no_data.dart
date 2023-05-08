
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nibbles/utils/size_config.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    Key? key,required this.noDataText,required this.height,
  }) : super(key: key);
final String noDataText;
final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: SizeConfig.widthMultiplier*100,
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/images/no_data.json",
                    height: SizeConfig.heightMultiplier * 20),
                Text(
                 noDataText,
                  style: TextStyle(
                      fontSize:
                          SizeConfig.textMultiplier * 1.8,
                      fontWeight: FontWeight.w500),
                )
              ]),
        ),
      );
  }
}

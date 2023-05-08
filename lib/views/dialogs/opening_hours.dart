import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import '../../../../utils/size_config.dart';

class OpeningHoursDialog extends StatefulWidget {
  const OpeningHoursDialog({
    Key? key,
    required this.openingHours,
  });
  final List openingHours;
  @override
  State<StatefulWidget> createState() => OpeningHoursDialogState();
}

class OpeningHoursDialogState extends State<OpeningHoursDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  TextEditingController nameCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container(
            height: 37 * SizeConfig.heightMultiplier,
            width: 80 * SizeConfig.widthMultiplier,
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.heightMultiplier * 2,
                horizontal: SizeConfig.widthMultiplier * 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Opening Hours",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.textMultiplier * 2,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 20,
                        ))
                  ],
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 3,
                ),
                ListView.builder(
                    itemCount: widget.openingHours.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (_, index) => OpeningHoursRowInfo(
                        title: widget.openingHours[index]["Day"].split(",")[0],
                        isDivider: index == widget.openingHours.length - 1
                            ? false
                            : true,
                        subtitle: widget.openingHours[index]["Time"]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OpeningHoursRowInfo extends StatelessWidget {
  const OpeningHoursRowInfo({
    Key? key,
    required this.title,
    this.isDivider = true,
    required this.subtitle,
  }) : super(key: key);
  final String title, subtitle;
  final bool isDivider;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.textMultiplier * 1.4,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.textMultiplier * 1.4,
                  color: Colors.grey.shade600),
            )
          ],
        ),
        isDivider ? const Divider() : const SizedBox()
      ],
    );
  }
}

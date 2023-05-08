import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/utils/size_config.dart';

class CustomNotchShapeBottomSheet extends StatelessWidget {
  const CustomNotchShapeBottomSheet(
      {Key? key, required this.child, this.isBigSheet = true})
      : super(key: key);
  final Widget child;
  final bool isBigSheet;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isBigSheet
          ? SizeConfig.heightMultiplier * 87
          : SizeConfig.heightMultiplier * 50,
      width: SizeConfig.widthMultiplier * 100,
      child: Stack(
        children: [
          Column(
            children: [
              //CUSTOM SHAPE
              SizedBox(
                height: SizeConfig.heightMultiplier * 8,
                width: SizeConfig.widthMultiplier * 100,
                child: CustomPaint(
                  size: Size(
                      Get.width,
                      SizeConfig.heightMultiplier *
                          6), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                  painter: CustomNotch(),
                ),
              ),
              //BODY
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: isBigSheet
                  ? SizeConfig.heightMultiplier * 81
                  : SizeConfig.heightMultiplier * 45,
              width: SizeConfig.widthMultiplier * 100,
              color: Colors.white,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class CustomNotch extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(size.width * 0.1224000, 0);
    path0.quadraticBezierTo(size.width * 0.0172167, size.height * -0.0279000,
        size.width * 0.0003083, size.height * 0.2940000);
    path0.quadraticBezierTo(
        size.width * 0.0003313, size.height * 0.2943583, 0, size.height);
    path0.lineTo(size.width, size.height);
    path0.quadraticBezierTo(size.width, size.height * 0.2916667, size.width,
        size.height * 0.2900000);
    path0.quadraticBezierTo(size.width * 0.9829917, size.height * -0.0144667,
        size.width * 0.8695167, 0);
    path0.lineTo(size.width * 0.5852667, size.height * 0.0001000);
    path0.quadraticBezierTo(size.width * 0.5019250, size.height * 0.4174333,
        size.width * 0.4132250, size.height * 0.0017333);
    path0.quadraticBezierTo(size.width * 0.3309354, size.height * 0.0016583,
        size.width * 0.1224000, 0);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

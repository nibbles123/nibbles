import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/utils/size_config.dart';

class ImageViewerPage extends StatefulWidget {
  const ImageViewerPage({Key? key, required this.images, required this.index})
      : super(key: key);
  final List images;
  final int index;

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late PageController _controller;
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            PageView.builder(
                controller: _controller,
                itemCount: widget.images.length,
                itemBuilder: (_, index) => InteractiveViewer(
                  clipBehavior: Clip.none,
                    child: Image.network(widget.images[index]))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                sliderButton(() {
                  _controller.previousPage(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn);
                }, Icons.arrow_back_ios_rounded),
                sliderButton(() {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn);
                }, Icons.arrow_forward_ios_rounded)
              ],
            )
          ],
        ));
  }

  GestureDetector sliderButton(VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.heightMultiplier * 6,
        width: SizeConfig.widthMultiplier * 12,
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 6)]),
        child: Center(
          child: Icon(
            icon,
            size: 20,
          ),
        ),
      ),
    );
  }
}

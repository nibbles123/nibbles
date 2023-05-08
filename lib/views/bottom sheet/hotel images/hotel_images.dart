import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/pages/image%20viewer/image_viewer.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/custom_shape_bottomsheet.dart';

class HotelImagesBS extends StatelessWidget {
  const HotelImagesBS({Key? key, required this.images}) : super(key: key);
  final List<String> images;
  @override
  Widget build(BuildContext context) {
    return CustomNotchShapeBottomSheet(
      child: SizedBox(
        height: SizeConfig.heightMultiplier * 85,
        width: SizeConfig.widthMultiplier * 100,
        child: Column(
          children: [
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomBackButton(),
                  Text(
                    "Photos",
                    style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.1),
                  ),
                  SizedBox(
                    width: SizeConfig.widthMultiplier * 5,
                  )
                ],
              ),
            ),
            Expanded(
              child: StaggeredGridView.count(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 2),
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  children: List.generate(images.length, (int index) {
                    return _Tile(index, images[index], images);
                  }),
                  staggeredTiles: List.generate(images.length, (int index) {
                    return const StaggeredTile.fit(1);
                  })),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final int index;
  final String url;
  final List<String> images;

  _Tile(this.index, this.url, this.images);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        child: Stack(children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
                child: const CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
                alignment: Alignment.center,
                height: 60),
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                Get.to(() => ImageViewerPage(images: images, index: index));
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ]));
  }
}

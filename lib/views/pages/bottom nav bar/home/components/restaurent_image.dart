import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/restaurents_controller.dart';
import 'package:nibbles/models/restaurent_model.dart';
import 'package:nibbles/services/google_photo_service.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/widgets/loading.dart';

class RestaurentImage extends StatelessWidget {
  const RestaurentImage({
    Key? key,
    required this.item,
  }) : super(key: key);

  final RestaurentModel item;
  @override
  Widget build(BuildContext context) {
    final restaurent = Get.find<RestaurentsController>();
    return Obx(
      () => Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: SizeConfig.heightMultiplier * 80,
            width: SizeConfig.widthMultiplier * 100,
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                imageUrl: GooglePhotoService.getPhotoURL(
                    item.photos![restaurent.currentImageIndex.value]),
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                    child:
                        LoadingWidget(height: SizeConfig.heightMultiplier * 4)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (restaurent.currentImageIndex.value > 0) {
                      restaurent.currentImageIndex.value--;
                    }
                  },
                  child: Container(
                    height: SizeConfig.heightMultiplier * 80,
                    width: SizeConfig.widthMultiplier * 43,
                    color: Colors.transparent,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (restaurent.currentImageIndex.value < 4) {
                      restaurent.currentImageIndex.value++;
                    } else {
                      restaurent.currentImageIndex.value = 0;
                    }
                  },
                  child: Container(
                    height: SizeConfig.heightMultiplier * 80,
                    width: SizeConfig.widthMultiplier * 43,
                    color: Colors.transparent,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

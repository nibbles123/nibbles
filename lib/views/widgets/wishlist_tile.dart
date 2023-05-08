import 'package:flutter/material.dart';
import 'package:nibbles/utils/size_config.dart';

class WishListHotelsTile extends StatelessWidget {
  const WishListHotelsTile({
    Key? key,
    required this.title,
    required this.image,
    required this.onTap,
    this.isAssetImage = false,
  }) : super(key: key);

  final String title;
  final String image;
  final VoidCallback onTap;
  final bool isAssetImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 5),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 2, color: Colors.grey),
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 1,
          ),
          Container(
            height: SizeConfig.heightMultiplier * 13,
            width: SizeConfig.widthMultiplier * 90,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                image: isAssetImage
                    ? DecorationImage(
                        image: AssetImage(image), fit: BoxFit.cover)
                    : DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(22)),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 1.5,
          )
        ],
      ),
    );
  }
}

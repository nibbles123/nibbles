import 'package:flutter/material.dart';
import 'package:nibbles/models/place.dart';
import 'package:nibbles/utils/size_config.dart';

import 'rating_widget.dart';

class RatingTile extends StatelessWidget {
  const RatingTile({
    Key? key,
    required this.index,
    required this.reviews,
  }) : super(key: key);
  final int index;
  final Reviews reviews;
  @override
  Widget build(BuildContext context) {
    List<String> ratingPictures = [
      "https://media.cntraveler.com/photos/5c180f59e223c55afc3e3b47/16:9/w_2580,c_limit/THE%20MURAKA_HERO_Undersea%20Bedroom_Architectural_Night_Credit%20Justin%20Nicholas.jpg",
      "https://skift.com/wp-content/uploads/2022/09/Radisson-Hotel-Danang.jpg",
      "https://www.ihgplc.com/-/media/ihg/images/brands/regent/regent_carousel_1.jpg",
      "https://media.cntraveler.com/photos/61d07e0d361139bfc50b29e3/master/w_3820,h_2546,c_limit/Hotel-Crescent-Court-HCC-Suite-Presidential-Living.jpg",
      "https://triplanco.com/wp-content/uploads/2019/01/hotel_triplanco.jpg",
    ];
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //USERNAME AND USERIMAGE AND RATING
          Row(
            children: [
              CircleAvatar(
                radius: SizeConfig.widthMultiplier * 3,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage(reviews.profilePhotoUrl ?? ""),
              ),
              SizedBox(
                width: SizeConfig.widthMultiplier * 4,
              ),
              SizedBox(
                width: SizeConfig.widthMultiplier * 60,
                child: Text(
                  reviews.authorName ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.7),
                ),
              ),
              const Spacer(),
              RatingWidget(rating: reviews.rating!.toDouble())
            ],
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 1,
          ),
          //USER REVIEW
          Text(
            reviews.text ?? "",
            style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.6),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 1,
          ),
          //IF RATING HAS IMAGES
          // index == 0
          //     ? SingleChildScrollView(
          //         scrollDirection: Axis.horizontal,
          //         child: Row(
          //           children: [
          //             ...List.generate(
          //                 ratingPictures.length,
          //                 (index) => Container(
          //                       height: SizeConfig.heightMultiplier * 6,
          //                       width: SizeConfig.widthMultiplier * 13,
          //                       decoration: BoxDecoration(
          //                           color: Colors.grey.shade200,
          //                           borderRadius: BorderRadius.circular(3),
          //                           image: DecorationImage(
          //                               image:
          //                                   NetworkImage(ratingPictures[index]),
          //                               fit: BoxFit.cover)),
          //                       margin: EdgeInsets.only(
          //                           right: SizeConfig.widthMultiplier * 1),
          //                     ))
          //           ],
          //         ),
          //       )
          //     : const SizedBox()
        ],
      ),
    );
  }
}

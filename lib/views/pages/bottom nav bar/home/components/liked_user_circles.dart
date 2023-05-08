import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nibbles/utils/size_config.dart';

class LikedUserCircles extends StatelessWidget {
  const LikedUserCircles({
    Key? key,
    required this.imageURL,
  }) : super(key: key);
  final String imageURL;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: SizeConfig.widthMultiplier * 2,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: NetworkImage(imageURL),
    );
  }
}

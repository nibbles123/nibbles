import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nibbles/utils/size_config.dart';
import 'liked_user_circles.dart';

class UsersWhoLiked extends StatelessWidget {
  const UsersWhoLiked({
    Key? key,
    required this.users,
  }) : super(key: key);
  final List users;
  @override
  Widget build(BuildContext context) {
    return users.isNotEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SOME USERS CIRCLE PICS
              SizedBox(
                width: SizeConfig.widthMultiplier * 10,
                child: Stack(
                  children: [
                    users.isNotEmpty
                        ? LikedUserCircles(
                            imageURL: users[0]['Photo'],
                          )
                        : const SizedBox(),
                    users.length >= 2
                        ? Positioned(
                            left: SizeConfig.widthMultiplier * 2.5,
                            child: LikedUserCircles(
                              imageURL: users[1]['Photo'],
                            ),
                          )
                        : const SizedBox(),
                    users.length >= 3
                        ? Positioned(
                            left: SizeConfig.widthMultiplier * 5,
                            child: LikedUserCircles(
                              imageURL: users[2]['Photo'],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),

              Text(
                "Liked by",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.textMultiplier * 1.4),
              ),
              SizedBox(
                width: SizeConfig.widthMultiplier * 1,
              ),
              //ONE USERNAME

              Text(
                users[0]['Name'],
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.textMultiplier * 1.4),
              ),
              SizedBox(
                width: SizeConfig.widthMultiplier * 1,
              ),
              Text(
                users.length > 1 ? "and" : "",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.textMultiplier * 1.4),
              ),
              SizedBox(
                width: SizeConfig.widthMultiplier * 1,
              ),
              //OTHERS USERS LENGTH
              users.length > 1
                  ? Text(
                      users.length - 1 == 1
                          ? "1 other"
                          : "${users.length-1} others",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: SizeConfig.textMultiplier * 1.4),
                    )
                  : const SizedBox(),
            ],
          )
        : Text(
            "No Likes",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.textMultiplier * 1.4),
          );
  }
}

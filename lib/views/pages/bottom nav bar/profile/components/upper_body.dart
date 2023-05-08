import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/services/firebase_api.dart';
import 'package:nibbles/views/dialogs/choose_source.dart';
import 'package:nibbles/views/pages/%20all%20users/all_users.dart';
import 'package:nibbles/views/pages/bottom%20nav%20bar/profile/components/profile_button.dart';
import 'package:nibbles/views/pages/offers/offers.dart';

import '../../../../../utils/size_config.dart';
import '../../../../widgets/custom_backbutton.dart';
import '../../../friends/friends.dart';
import '../../../my reservations/my_reservations.dart';
import '../../../wishlist/wishlist.dart';
import 'profile_picture.dart';

class UpperBody extends StatelessWidget {
  const UpperBody({
    Key? key,
    required this.isOtherUser,
    this.user,
  }) : super(key: key);
  final bool isOtherUser;
  final QueryDocumentSnapshot<Object?>? user;

  @override
  Widget build(BuildContext context) {
    final authCont = Get.find<AuthController>();
    return Container(
      height: isOtherUser
          ? SizeConfig.heightMultiplier * 44
          : SizeConfig.heightMultiplier * 47,
      width: SizeConfig.widthMultiplier * 100,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 6),
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.heightMultiplier * 5,
          ),
          isOtherUser
              ? const Align(
                  alignment: Alignment.topLeft, child: CustomBackButton())
              :  SizedBox(
                height: SizeConfig.heightMultiplier*3,
              ),
          !isOtherUser
              ? Obx(
                  () => Text(
                    authCont.userInfo.name ?? "",
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 3.6,
                        fontWeight: FontWeight.w700),
                  ),
                )
              : Text(
                  user?.get("Name") ?? "",
                  style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 3.6,
                      fontWeight: FontWeight.w700),
                ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 1.5,
          ),
          //PROFILE PICTURE
          ProfilePicture(
            isOtherUser: isOtherUser,
            otherUserImage: user?.get("ImageURL") ?? "",
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 1.5,
          ),
          //LOCATION
          Text("Singapore",
              style: TextStyle(
                fontSize: SizeConfig.textMultiplier * 1.7,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade500,
              )),
          SizedBox(
            height: isOtherUser
                ? SizeConfig.heightMultiplier * 1
                : SizeConfig.heightMultiplier * 4,
          ),
          //OPTIONS
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 0),
            child: Row(
              mainAxisAlignment: isOtherUser
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                ProfileButtons(
                  text: isOtherUser ? "Liked" : "Wishlist",
                  icon: isOtherUser ? FeatherIcons.heart : FeatherIcons.plus,
                  onTap: () => Get.to(
                      () => WishListPage(
                            isLiked: isOtherUser ? true : false,
                            userID:
                                isOtherUser ? user!.id : authCont.userss!.uid,
                          ),
                      transition: Transition.leftToRight),
                ),
                isOtherUser
                    ? SizedBox(
                        width: SizeConfig.widthMultiplier * 3,
                      )
                    : ProfileButtons(
                        text: "My Reservations",
                        icon: FeatherIcons.calendar,
                        onTap: () {
                          Get.to(() => const MyReservationsPage(),
                              transition: Transition.leftToRight);
                        },
                      ),
                isOtherUser
                    ? const SizedBox()
                    : ProfileButtons(
                        text: "Offers",
                        icon: FeatherIcons.percent,
                        onTap: () =>Get.to(()=> OffersPage()),
                      ),
                ProfileButtons(
                  text: "Friends",
                  icon: FeatherIcons.users,
                  onTap: () {
                    Get.to(
                        () => AllUsersPage(
                              userID: isOtherUser
                                  ? user?.id ?? ""
                                  : authCont.userss!.uid,
                              isOtherUser: isOtherUser,
                            ),
                        transition: Transition.leftToRight);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

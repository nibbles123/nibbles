import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/controllers/restaurents_controller.dart';
import 'package:nibbles/models/restaurent_model.dart';
import 'package:nibbles/services/database.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/pages/%20all%20users/all_users.dart';
import 'package:nibbles/views/widgets/loading.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../models/user_model.dart';
import '../../../bottom sheet/reserve now/reserve_now.dart';
import 'components/card.dart';
import 'components/no_restaurent.dart';
import 'components/reserve_button.dart';
import 'components/users_who_liked.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final restaurentCont = Get.find<RestaurentsController>();
  final buttonCont = Get.find<ButtonController>();
  final authCont = Get.find<AuthController>();

  //Here we take User Model as observable for showing the user data in the app
  Rx<UserModel> userModel = UserModel().obs;

  //Here we get and set the usermodel data for using anywhere in the app
  UserModel get userInfo => userModel.value;
  set userInfo(UserModel value) => userModel.value = value;

  @override
  void initState() {
    print("anas");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: buttonCont.onCardComplete.value
            ? const NoRestaurents()
            : Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 6,
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 72,
                        width: SizeConfig.widthMultiplier * 100,
                        child: GetX<RestaurentsController>(
                          init: RestaurentsController(),
                          builder: (restaurent) {
                            return restaurent.getRestaurents == null
                                ? LoadingWidget(
                                    height: SizeConfig.heightMultiplier * 70)
                                : restaurent.getRestaurents!.isEmpty
                                    ? const NoRestaurents()
                                    : Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: SwipableStack(
                                            itemCount: restaurent
                                                .getRestaurents!.length,
                                            detectableSwipeDirections: const {
                                              SwipeDirection.right,
                                              SwipeDirection.left,
                                            },
                                            controller:
                                                restaurentCont.cardCont.value,
                                            stackClipBehaviour: Clip.none,
                                            onSwipeCompleted:
                                                (index, direction) {
                                              if (direction ==
                                                  SwipeDirection.right) {
                                                restaurentCont.isLiked.value =
                                                    true;
                                                //IF SWIPING IS RIGHT THEN LIKE THE RESTAURENT
                                                DataBase()
                                                    .addRestaurentToWishList(
                                                        restaurent
                                                                .getRestaurents![
                                                            index])
                                                    .then((value) {
                                                  restaurentCont.isLiked.value =
                                                      false;
                                                });
                                              }
                                              restaurent
                                                  .currentImageIndex.value = 0;
                                              if (index ==
                                                  restaurent.getRestaurents!
                                                          .length -
                                                      1) {
                                                buttonCont.onCardComplete
                                                    .value = true;
                                              }
                                              setState(() {});
                                            },
                                            horizontalSwipeThreshold: 0.8,
                                            verticalSwipeThreshold: 0.8,
                                            builder: (context, properties) {
                                              final index = properties.index;
                                              final item = restaurent
                                                  .getRestaurents![index];

                                              return RestaurentCard(
                                                item: item,
                                              );
                                            }));
                          },
                        ),
                      ),
                      Obx(
                        () => restaurentCont.getRestaurents == null
                            ? const SizedBox()
                            : restaurentCont.getRestaurents!.isEmpty
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            SizeConfig.heightMultiplier * 0.5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          List likedUsers = [];
                                          restaurentCont
                                              .getRestaurents![restaurentCont
                                                  .cardCont.value!.currentIndex]
                                              .likedBY!
                                              .forEach((element) {
                                            likedUsers.add(element['id']);
                                          });
                                          if (likedUsers.isNotEmpty) {
                                            Get.to(() => AllUsersPage(
                                                userID:
                                                    Get.find<AuthController>()
                                                        .userss!
                                                        .uid,
                                                likedUsers: likedUsers,
                                                isLikedUsers: true,
                                                isOtherUser: false));
                                          }
                                        },
                                        child: UsersWhoLiked(
                                            users: restaurentCont
                                                .getRestaurents![restaurentCont
                                                    .cardCont
                                                    .value!
                                                    .currentIndex]
                                                .likedBY!),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.heightMultiplier * 1,
                                      ),
                                      GetX<RestaurentsController>(
                                          init: RestaurentsController(),
                                          builder: (restaurant) {
                                            return ReserveButton(
                                              isUpdate: false,
                                              isReserved: restaurentCont
                                                          .getRestaurents![
                                                              restaurentCont
                                                                  .cardCont
                                                                  .value!
                                                                  .currentIndex]
                                                          .reservationLink ==
                                                      ''
                                                  ? true
                                                  : false,
                                              onTap: () {
                                                print(
                                                    'THIS ${restaurentCont.cardCont.value!.currentIndex}');

                                                print(restaurentCont
                                                    .getRestaurents![
                                                        restaurentCont
                                                            .cardCont
                                                            .value!
                                                            .currentIndex]
                                                    .chopeID);

                                                //http://chopeapi.chope.info/bookings/create?restaurant_id=sandboxreztype1&language=en_US&date_time=1546002900&title=MR.&first_name=XXX&last_name=YYY&phone_cc=65&mobile=12345678&email=xxx@gmail.com&adults=6&children=1&notes=Birthday celebration&content={"653":"I need 10 napkins","654":"checked","655":"Highchair"}&membership_id=9309&callback_url=http://test.chope.co/&agree_receive_email=1

                                                //if restaurant have chope id

                                                if (restaurentCont
                                                    .getRestaurents![
                                                        restaurentCont
                                                            .cardCont
                                                            .value!
                                                            .currentIndex]
                                                    .chopeID!
                                                    .isNotEmpty) {
                                                  RestaurentModel? mo =
                                                      restaurentCont
                                                              .getRestaurents![
                                                          restaurentCont
                                                              .cardCont
                                                              .value!
                                                              .currentIndex];
                                                  showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (_) =>
                                                          ReserveNowBottomSheet(
                                                              model: mo,
                                                              isUpdate: false,
                                                              title: mo.title ??
                                                                  "",
                                                              img:
                                                                  mo.photos![0],
                                                              address: mo
                                                                  .locality
                                                                  .toString(),
                                                              id: ""));
                                                  return;
                                                }
                                                final link = restaurentCont
                                                    .getRestaurents![
                                                        restaurentCont
                                                            .cardCont
                                                            .value!
                                                            .currentIndex]
                                                    .reservationLink;
                                                print(link);
                                                if (link != '') {
                                                  _launchUrl(link!);
                                                } else {
                                                  print('No reservation link');
                                                }
                                              },
                                            );
                                          }),
                                    ],
                                  ),
                      )
                    ],
                  ),
                  restaurentCont.isLiked.value
                      ? Positioned(
                          child: Lottie.asset(
                          'assets/images/added.json',
                        ))
                      : const SizedBox()
                ],
              ),
      ),
    );
  }

  _launchUrl(String url) async {
    print(url);
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}

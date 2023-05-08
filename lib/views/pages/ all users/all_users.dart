import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/all_users_controller.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/services/database.dart';
import 'package:nibbles/services/push_notification.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/pages/bottom%20nav%20bar/profile/profile.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/custom_searchfield.dart';
import 'package:nibbles/views/widgets/loading.dart';
import 'package:nibbles/views/widgets/no_data.dart';

class AllUsersPage extends StatefulWidget {
  AllUsersPage(
      {Key? key,
      required this.userID,
      required this.isOtherUser,
      this.isLikedUsers = false,
      this.likedUsers})
      : super(key: key);
  final String userID;
  final bool isOtherUser;
  final bool? isLikedUsers;
  final List? likedUsers;
  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  TextEditingController searchCont = TextEditingController();
  AllUsersController users = Get.find<AllUsersController>();

  @override
  Widget build(BuildContext context) {
    print(DateTime.now().toString());
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 6),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 5,
              ),
              Row(
                children: [
                  const CustomBackButton(),
                  SizedBox(
                    width: SizeConfig.widthMultiplier * 6,
                  ),
                  Text(
                    widget.isLikedUsers! ? 'Likes' : "Friends",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.textMultiplier * 3.8),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),
              CustomSearchField(
                hintText: widget.isLikedUsers! ? 'Search users' : "Add friends",
                controller: searchCont,
                onChange: (val) {
                  setState(() {});
                },
              ),
              SizedBox(
                height:
                    widget.isLikedUsers! ? 0 : SizeConfig.heightMultiplier * 2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 4),
                child: Text(
                  widget.isOtherUser
                      ? "Friends"
                      : widget.isLikedUsers!
                          ? ''
                          : "My Friends",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.textMultiplier * 2.1),
                ),
              ),
              SizedBox(
                height:
                    widget.isLikedUsers! ? 0 : SizeConfig.heightMultiplier * 2,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: searchCont.text.isEmpty
                      ? widget.isLikedUsers!
                          ? FirebaseFirestore.instance
                              .collection("Users")
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection("Users")
                              .where("Friends", arrayContains: widget.userID)
                              .snapshots()
                      : FirebaseFirestore.instance
                          .collection("Users")
                          .where("searchKey",
                              isGreaterThanOrEqualTo:
                                  searchCont.text.toLowerCase())
                          .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? LoadingWidget(
                            height: SizeConfig.heightMultiplier * 30)
                        : snapshot.data!.docs.isEmpty
                            ? NoDataWidget(
                                noDataText: "No Friends Yet!",
                                height: SizeConfig.heightMultiplier * 50)
                            : Expanded(
                                child: AnimationLimiter(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.widthMultiplier * 4),
                                  physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return AnimationConfiguration.staggeredList(
                                        position: index,
                                        delay:
                                            const Duration(milliseconds: 100),
                                        child: SlideAnimation(
                                          duration: const Duration(
                                              milliseconds: 2500),
                                          curve: Curves.fastLinearToSlowEaseIn,
                                          child: FadeInAnimation(
                                            curve:
                                                Curves.fastLinearToSlowEaseIn,
                                            duration: const Duration(
                                                milliseconds: 2500),
                                            child: widget.isLikedUsers!
                                                ? widget.likedUsers!.contains(
                                                        snapshot.data!
                                                            .docs[index].id)
                                                    ? FriendsTile(
                                                        user: snapshot
                                                            .data!.docs[index],
                                                      )
                                                    : const SizedBox()
                                                : FriendsTile(
                                                    user: snapshot
                                                        .data!.docs[index],
                                                  ),
                                          ),
                                        ));
                                  },
                                ),
                              ));
                  }),
            ])));
  }
}

class FriendsTile extends StatelessWidget {
  const FriendsTile({
    Key? key,
    required this.user,
  }) : super(key: key);
  final QueryDocumentSnapshot<Object?> user;
  @override
  Widget build(BuildContext context) {
    final authCont = Get.find<AuthController>();

    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 3),
      child: InkWell(
        onTap: () {
          if (user.id == authCont.userss!.uid) {
            Get.to(
                () => const ProfilePage(
                      isOtherUser: false,
                    ),
                transition: Transition.leftToRight);
          } else {
            Get.to(
                () => ProfilePage(
                      isOtherUser: true,
                      user: user,
                    ),
                transition: Transition.leftToRight);
          }
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: SizeConfig.widthMultiplier * 7.5,
              backgroundColor: Colors.grey.shade100,
              backgroundImage: NetworkImage(user.get("ImageURL") ?? ""),
            ),
            SizedBox(
              width: SizeConfig.widthMultiplier * 4,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.id == authCont.userss!.uid
                      ? "${user.get("Name")}   (Me)"
                      : user.get("Name") ?? "",
                  style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.8,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 0.4,
                ),
                Text(
                  "${user.get("Friends")!.length} Friends",
                  style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.4,
                      color: Colors.grey.shade600),
                )
              ],
            ),
            const Spacer(),
            user.id == authCont.userss!.uid
                ? const SizedBox()
                : Obx(
                    () => InkWell(
                        onTap: () {
                          if (!authCont.userInfo.friends!.contains(user.id)) {
                            onAddingUser();
                          } else {
                            print("Already Friend");
                          }
                        },
                        child: authCont.userInfo.friends!.contains(user.id)
                            ? const Icon(Icons.done)
                            : const Icon(Icons.person_add)),
                  ),
          ],
        ),
      ),
    );
  }

  onAddingUser() async {
    final authCont = Get.find<AuthController>();
    var body = "You have a new friend ${authCont.userInfo.name}";
    List otherFriendList = user.get("Friends");
    List myFriendList = authCont.userInfo.friends!;
    otherFriendList.add(authCont.userss!.uid);
    myFriendList.add(user.id);

    PushNotificationService.sendPushCommunityMessage(
        user.get("FCMtoken"), body, "Community");
    DataBase().addMyNotification("Community", body, "community", user.id, true);
    DataBase().addMyNotification(
        "Community",
        "You have a new friend ${user.get("Name")}",
        "community",
        authCont.userss!.uid,
        true);

    //UPDATING OTHER USER FRIEND LIST
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.id)
        .update({"Friends": otherFriendList});
    //UPDATING MY FRIEND LIST
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(authCont.userss!.uid)
        .update({"Friends": myFriendList});
    authCont.getUser();
  }
}

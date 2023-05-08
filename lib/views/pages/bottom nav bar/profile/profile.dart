import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/controllers/button_controller.dart';
import 'package:nibbles/services/database.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/widgets/custom_button.dart';
import 'package:nibbles/views/widgets/show_loading.dart';
import 'components/all_options.dart';
import 'components/column_info.dart';
import 'components/upper_body.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.isOtherUser, this.user})
      : super(key: key);
  final bool isOtherUser;
  final QueryDocumentSnapshot<Object?>? user;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //GETX CONTROLLERS
  final authCont = Get.find<AuthController>();
  final buttonCont = Get.find<ButtonController>();
  String? tosURL, faqUrl;
  //TEXT EDITORS
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController friends = TextEditingController();
  TextEditingController followers = TextEditingController();
  TextEditingController socialURL = TextEditingController();
  ////////////////////
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (!widget.isOtherUser) {
        getPdfsUrls();
        getUserCurrentData();
      } else {
        getOtherUserData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    buttonCont.isEdit.value = false;
  }

  getUserCurrentData() {
    name.text = authCont.userInfo.name ?? "";
    email.text = authCont.userInfo.email ?? "";
    friends.text = "${authCont.userInfo.friends?.length} Friends";
    followers.text = "${authCont.userInfo.friends?.length} Followers";
    socialURL.text = authCont.userInfo.socialURL ?? "";
  }

  getPdfsUrls() async {
    await FirebaseFirestore.instance.collection('Pdfs').get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i].id == 'TOS') {
          tosURL = value.docs[i].get('URL');
        } else {
          faqUrl = value.docs[i].get('URL');
        }
      }
    });
  }

  getOtherUserData() {
    name.text = widget.user?.get("Name");
    email.text = widget.user?.get("Email");
    friends.text = "${widget.user?.get("Friends").length} Friends";
    followers.text = "${widget.user?.get("Friends").length} Followers";
    socialURL.text = widget.user?.get("SocialURL");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ShowLoading(
        inAsyncCall: authCont.isLoading.value,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  children: [
                    //UPPER BODY
                    UpperBody(
                      isOtherUser: widget.isOtherUser,
                      user: widget.user,
                    ),
                    Divider(
                      height: SizeConfig.heightMultiplier * 4,
                      thickness: SizeConfig.heightMultiplier * 1,
                      color: const Color(0xFFFFF0F0),
                    ),
                    //LOWER BODY
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          Row(
                            children: [
                              Text(
                                "About",
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2.1),
                              ),
                              SizedBox(
                                width: SizeConfig.widthMultiplier * 4,
                              ),
                              widget.isOtherUser
                                  ? const SizedBox()
                                  : GestureDetector(
                                      onTap: () =>
                                          buttonCont.isEdit.value = true,
                                      child: Icon(Icons.edit,
                                          size:
                                              SizeConfig.textMultiplier * 2.4),
                                    )
                            ],
                          ),
                          //USER INFO
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 3,
                          ),

                          ProfileColumnInfo(
                            title: "Full Name",
                            isEnableField: buttonCont.isEdit.value,
                            controller: name,
                            isFocus: true,
                          ),

                          Divider(
                            height: SizeConfig.heightMultiplier * 3,
                            thickness: 1,
                            color: Colors.grey.shade200,
                          ),
                          ProfileColumnInfo(
                            title: "Email",
                            isEnableField: false,
                            controller: email,
                          ),

                          Divider(
                            height: SizeConfig.heightMultiplier * 3,
                            thickness: 1,
                            color: Colors.grey.shade200,
                          ),
                          Row(
                            children: [
                              ProfileColumnInfo(
                                title: "Following",
                                isEnableField: false,
                                controller: friends,
                              ),
                              SizedBox(
                                width: SizeConfig.widthMultiplier * 15,
                              ),
                              ProfileColumnInfo(
                                title: "Followers",
                                isEnableField: false,
                                controller: followers,
                              ),
                            ],
                          ),
                          Divider(
                            height: SizeConfig.heightMultiplier * 3,
                            thickness: 1,
                            color: Colors.grey.shade200,
                          ),
                          ProfileColumnInfo(
                            title: "Social URL",
                            isEnableField: buttonCont.isEdit.value,
                            controller: socialURL,
                          ),
                          Divider(
                            height: SizeConfig.heightMultiplier * 3,
                            thickness: 1,
                            color: Colors.grey.shade200,
                          ),
                          //PROFILE OPTIONSS
                          widget.isOtherUser
                              ? const SizedBox()
                              : AllProfileOptions(
                                  tosURL: tosURL ?? '',
                                  faqsUrl: faqUrl ?? '',
                                  isOtherUser: widget.isOtherUser,
                                  user: widget.user,
                                )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeIn,
                top: SizeConfig.heightMultiplier * 83,
                right: buttonCont.isEdit.value
                    ? SizeConfig.widthMultiplier * 5
                    : -SizeConfig.widthMultiplier * 50,
                child: SaveChangesButton(
                  onTap: () =>
                      DataBase().onProfileEdit(name.text, socialURL.text),
                )),
          ],
        ),
      ),
    );
  }
}

class SaveChangesButton extends StatelessWidget {
  const SaveChangesButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.heightMultiplier * 4.5,
        width: SizeConfig.widthMultiplier * 40,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: selectedTileColor.withOpacity(0.6),
                blurRadius: 15,
                offset: const Offset(5, 8))
          ],
        ),
        child: Center(
          child: Text(
            "Save Changes".toUpperCase(),
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/services/database.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/bottom%20sheet/change%20password/change_password.dart';
import 'package:nibbles/views/dialogs/confirmation_dialog.dart';
import 'package:nibbles/views/pages/bottom%20nav%20bar/profile/components/profile_options.dart';
import 'package:nibbles/views/pages/bottom%20nav%20bar/directory/directory.dart';
import 'package:nibbles/views/pages/pdf%20viewer/pdf_viewer.dart';
import 'package:nibbles/views/pages/rate%20us/rate_us.dart';
import 'package:nibbles/views/pages/settings/settings.dart';
import 'package:nibbles/views/pages/wishlist/wishlist.dart';

class AllProfileOptions extends StatelessWidget {
  AllProfileOptions({
    Key? key,
    required this.isOtherUser,
    this.user,
    required this.tosURL,
    required this.faqsUrl,
  }) : super(key: key);
  final bool isOtherUser;
  final String tosURL, faqsUrl;
  final QueryDocumentSnapshot<Object?>? user;
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmNewPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileOptions(
          onTap: () => Get.to(() => WishListPage(
                isLiked: true,
                userID: isOtherUser
                    ? user!.id
                    : Get.find<AuthController>().userss!.uid,
              )),
          title: "Liked restaurants",
          icon: FeatherIcons.heart,
        ),
        // ProfileOptions(
        //   onTap: () {},
        //   title: "Referral Code",
        //   icon: FeatherIcons.codesandbox,
        // ),
        // ProfileOptions(
        //   onTap: () {},
        //   title: "Account info",
        //   icon: FeatherIcons.user,
        // ),
        // ProfileOptions(
        //   onTap: () {},
        //   title: "Contact List",
        //   icon: FeatherIcons.users,
        // ),
        // ProfileOptions(
        //   onTap: () {},
        //   title: "Language",
        //   icon: FeatherIcons.globe,
        // ),
        ProfileOptions(
          onTap: () => Get.to(() => const SettingsPage()),
          title: "General Setting",
          icon: FeatherIcons.settings,
        ),
        ProfileOptions(
          onTap: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  builder: (_) => ChangePasswordBottomSheet(
                      oldPass: oldPass,
                      newPass: newPass,
                      confirmNewPass: confirmNewPass,
                      onUpdate: () => DataBase().onChangePassword(
                          oldPass.text, newPass.text, confirmNewPass.text)))
              .then((value) {
            oldPass.clear();
            newPass.clear();
            confirmNewPass.clear();
          }),
          title: "Change Password",
          icon: FeatherIcons.lock,
        ),

        ProfileOptions(
          onTap: () => Get.to(PDFviewer(pdfURL: faqsUrl, title: "FAQ's")),
          title: "FAQs",
          icon: Icons.question_mark_sharp,
        ),
        ProfileOptions(
          onTap: () =>
              Get.to(PDFviewer(pdfURL: tosURL, title: "Terms of services")),
          title: "Terms of services",
          icon: FeatherIcons.file,
        ),
        ProfileOptions(
          onTap: () => Get.find<AuthController>().userInfo.isRated!
              ? Get.snackbar('Thanks for your previous feedback',
                  'You cannot rate us twice',
                  backgroundColor: Colors.redAccent, colorText: Colors.white)
              : Get.to(() => const RateUsPage()),
          title: "Rate Us",
          icon: FeatherIcons.star,
        ),
        ProfileOptions(
          onTap: () => Get.dialog(ConfirmationDialog(
            text: 'are you sure you want to delete your account?',
            onConfirm: () => Get.find<AuthController>().deleteAccount(),
            note: 'Your all data will be deleted from our database',
            isNote: true,
          )),
          title: "Delete Account",
          icon: Icons.delete_outline_rounded,
        ),
        ProfileOptions(
          onTap: () {
            Get.find<AuthController>().onSignOut();
          },
          title: "Sign out",
          icon: FeatherIcons.logOut,
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 10,
        )
      ],
    );
  }
}

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

import '../../../../../utils/size_config.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key? key,
    required this.isOtherUser,
    this.otherUserImage,
  }) : super(key: key);

  final bool isOtherUser;
  final String? otherUserImage;
  @override
  Widget build(BuildContext context) {
    final buttonCont = Get.find<ButtonController>();
    final authCont = Get.find<AuthController>();

    return Obx(
      () => GestureDetector(
        onTap: () {
          if (!isOtherUser) {
            Get.dialog(ChooseSourceDialog(
                onGalleryPress: () => onImgSelected(ImageSource.gallery),
                onCameraPress: () => onImgSelected(ImageSource.camera)));
          }
        },
        child: Stack(
          children: [
            isOtherUser
                ?
                //OTHER USER
                CircleAvatar(
                    radius: SizeConfig.widthMultiplier * 13,
                    backgroundColor: kLightPink,
                    backgroundImage: NetworkImage(otherUserImage!),
                  )
                : buttonCont.pickedImage.value == ""
                    ?
                    //IF IMAGE IS NOT PICKED
                    CircleAvatar(
                        radius: SizeConfig.widthMultiplier * 13,
                        backgroundColor: kLightPink,
                        backgroundImage: NetworkImage(
                            Get.find<AuthController>().userInfo.imageURL ?? ""),
                      )
                    :
                    //IF IMAGE IS PICKED
                    CircleAvatar(
                        radius: SizeConfig.widthMultiplier * 13,
                        backgroundColor: kLightPink,
                        backgroundImage:
                            FileImage(File(buttonCont.pickedImage.value)),
                      ),
            isOtherUser
                ? const SizedBox()
                : Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: SizeConfig.widthMultiplier * 3.7,
                      backgroundColor: Colors.deepPurple.withOpacity(0.3),
                      child: Icon(
                        FeatherIcons.camera,
                        color: Colors.white,
                        size: SizeConfig.textMultiplier * 2,
                      ),
                    )),
            authCont.isLoading.value ? const SizedBox() : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future onImgSelected(ImageSource source) async {
    final authCont = Get.find<AuthController>();
    //FOR SELECTING IMAGES AND SHOWING ON UI
    //Picking from the files

    final buttonCont = Get.find<ButtonController>();
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: source);
    Get.back();
    if (image != null) {
      final croppedImage = await ImageCropper().cropImage(
          sourcePath: image.path,
          androidUiSettings: const AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: kPrimaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          compressQuality: 70,
          compressFormat: ImageCompressFormat.jpg,
          aspectRatio: const CropAspectRatio(ratioX: 0.5, ratioY: 0.5),
          aspectRatioPresets: [CropAspectRatioPreset.ratio16x9]);

      croppedImage != null
          ? buttonCont.pickedImage.value = croppedImage.path
          : buttonCont.pickedImage.value = image.path;

      authCont.isLoading.value = true;
      FirebaseApi.onImageUploaded(File(buttonCont.pickedImage.value))
          .then((value) async {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(authCont.userss!.uid)
            .update({"ImageURL": value});
        authCont.isLoading.value = false;
        clearingValues();
        await authCont.getUser();
        authCont.updateLikeUserInfo();
      });
    } else {
      Get.snackbar("Please try again", "Image was not selected :(",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  clearingValues() {
    final buttonCont = Get.find<ButtonController>();
    buttonCont.pickedImage.value = "";
    buttonCont.imageURL.value = "";
  }
}

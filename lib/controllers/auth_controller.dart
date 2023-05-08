import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nibbles/constants/login_methods.dart';
import 'package:nibbles/services/database.dart';
import 'package:nibbles/models/user_model.dart';
import 'package:nibbles/services/send_email.dart';
import 'package:nibbles/utils/root.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/pages/authflow/login/login.dart';
import 'package:nibbles/views/pages/authflow/otp/otp.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

class AuthController extends GetxController {
  //FIREBASE METHODS
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  RxBool isDeletingAccount = false.obs;
  RxBool wishListLoading = false.obs;
  //FOR USER LOCATION
  RxDouble userLat = 0.0.obs;
  RxDouble userLng = 0.0.obs;

  //Here we take FirebaseUser as observable
  final Rxn<User> _firebaseUser = Rxn<User>();
  //FOR RESET PASSWORD ROOT
  RxBool isResetPassword = false.obs;
  RxString forgotPassEmail = ''.obs;
  //FOR VERIFICATION CODE
  RxString verificationCode = ''.obs;
  //Here we use getter for making the user data email to call anywhere in the app
  String? get user => _firebaseUser.value?.email;

  //Here we take User Model as observable for showing the user data in the app
  Rx<UserModel> userModel = UserModel().obs;

  //Here we get and set the usermodel data for using anywhere in the app
  UserModel get userInfo => userModel.value;
  set userInfo(UserModel value) => userModel.value = value;

  //Here we are getting the userData
  User? get userss => _firebaseUser.value;

  @override
  // ignore: type_annotate_public_apis
  onInit() {
    //Here we bind the stream which is used getting the data in the stream which have more then one type of data it is only used on observable list only
    _firebaseUser.bindStream(_auth.authStateChanges());

    super.onInit();
  }

  getUser() async {
    try {
      //It is getting data from the collection of "Users" which is in the database(uid is the unique id of each user in the app)
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userss!.uid)
          .get();
      userInfo = UserModel.fromDocumentSnapshot(doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> onSignup(
      String name, String phone, String email, String password) async {
    isLoading.value = true;
    try {
      final UserCredential _authResult = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      //creating user in the database
      //UserModel is the model where the data of the user
      //goes and then we show the user data from the model
      //class by the user controller in the app
      final UserModel _user = UserModel(
          id: _authResult.user?.uid,
          name: name,
          email: email,
          loginMethod: LoginMethod.simple,
          phone: phone,
          imageURL:
              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
          password: password);

      // if a user is successfully created then it goes to the homepage
      if (await DataBase().createUser(_user)) {
        Get.put(AuthController(), permanent: true);
        Navigator.pushAndRemoveUntil<dynamic>(
          Get.overlayContext!,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const Root(),
          ),
          (route) => false,
        );
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Please try again", "$e".split("]")[1].trim(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  onSignOut() async {
    try {
      if (userInfo.loginMethod == LoginMethod.google) {
        GoogleSignIn().signOut();
      }
      if (userInfo.loginMethod == LoginMethod.facebook) {
        FacebookAuth.instance.logOut();
      }

      await _auth
          .signOut()
          .then((value) => Navigator.pushAndRemoveUntil<dynamic>(
                Get.overlayContext!,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => const Root(),
                ),
                (route) => false,
              ));
    } catch (e) {
      Get.snackbar("Error", "$e".split("]")[1]);
    }
  }

  Future<void> onSignIn(String email, String password, bool isResetPass) async {
    try {
      isLoading.value = true;
      //if the sign in done successfully then it will go to the homepage otherwise it shows error
      final authUser = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Get.put(AuthController());
        getUser();
      }).then((value) => isLoading.value = false);
      isResetPass
          ? print('RESET PASSWORD')
          : Navigator.pushAndRemoveUntil<dynamic>(
              Get.overlayContext!,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const Root(),
              ),
              (route) => false,
            );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Please try again", "$e".split("]")[1].trim(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  onForgotPassword(String email) async {
    try {
      isLoading.value = true;
      forgotPassEmail.value = email;
      //FIRST CHECK EMAIL EXISTS OR NOT IN DATABASE
      await FirebaseFirestore.instance
          .collection('Users')
          .where('Email', isEqualTo: email)
          .get()
          .then((users) {
        if (users.docs.isNotEmpty) {
          //EMAIL EXISTS
          sendOtpEmail().then((value) {
            isLoading.value = false;
            Get.snackbar("Reset Email Send Successfully",
                "Please check your email for reset password",
                backgroundColor: Colors.green, colorText: Colors.white);
            Get.off(() => OTPpage(), transition: Transition.leftToRight);
          });
        } else {
          isLoading.value = false;
          //EMAIL DOES NOT EXISTS
          Get.snackbar(
              "Please try again", "Your email for reset password doesn't exist",
              backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      });
    } catch (e) {
      Get.snackbar("Please try again", "$e".split("]")[1],
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  onResetPass(String newPass) async {
    try {
      isLoading.value = true;
      isResetPassword.value = true;
      print('EMAIL IS ${forgotPassEmail.value}');
      await FirebaseFirestore.instance
          .collection('Users')
          .where('Email', isEqualTo: forgotPassEmail.value)
          .get()
          .then((value) {
        onSignIn(forgotPassEmail.value, value.docs[0].get('Password'), true)
            .then((val) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(value.docs[0].id)
              .update({'Password': newPass});
          userss!.updatePassword(newPass).then((value) => onSignOut());
          print('PassChange');
          Get.off(LoginPage(), transition: Transition.leftToRight);
          isLoading.value = false;
          isResetPassword.value = false;
        });
      });
    } catch (e) {
      Get.snackbar("Please try again", "$e".split("]")[1].trim(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  onFacebookSignin() async {
    try {
      isLoading.value = true;
      final result = await FacebookAuth.i.login(permissions: ['email']);
      if (result.status == LoginStatus.success) {
        //LOGIN QUERY

        final credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final value = await _auth.signInWithCredential(credential);
        await checkUserAlreadyExists(value, LoginMethod.facebook);

        Get.lazyPut(() => AuthController());
        await getUser();
        isLoading.value = false;
      } else {
        isLoading.value = false;
        print("No Facebook");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Please try again", "$e".split("]")[1].trim(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  //GOOGLE AUTHENTICATION
  Rxn<GoogleSignInAccount> currentUser = Rxn<GoogleSignInAccount>();

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final GoogleSignInAccount? googleSignIn = await GoogleSignIn().signIn();

      if (googleSignIn != null) {
        final GoogleSignInAuthentication gAuth =
            await googleSignIn.authentication;
        final googleCredential = GoogleAuthProvider.credential(
            accessToken: gAuth.accessToken, idToken: gAuth.idToken);

        final value = await _auth.signInWithCredential(googleCredential);
        await checkUserAlreadyExists(value, LoginMethod.google);
        // Get.put(AuthController(), permanent: true);
        await getUser();
        Navigator.pushAndRemoveUntil<dynamic>(
          Get.overlayContext!,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const Root(),
          ),
          (route) => false,
        );
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      print("Google  Error$e");
      Get.snackbar('Error', '$e');
    }
  }

  //SIGNIN WITH APPLE

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void appleAuthentication() async {
    isLoading.value = true;
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    try {
      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final value =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      await checkUserAlreadyExists(value, LoginMethod.apple);
      await getUser();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      final snackBar = SnackBar(
        margin: const EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content: Text(e.toString()),
        backgroundColor: (Colors.redAccent),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(snackBar);
    }
  }

  //sending email
  Future<String?> sendOtpEmail() async {
    try {
      Random rand = Random();
      var code = rand.nextInt(9000) + 1000;
      print("This is the thing $code");
      verificationCode.value = code.toString();
      SendEmailService.sendOtpEmail(
          forgotPassEmail.value, "Nibbles", "This is your otp code $code");
    } catch (e) {
      print("sentOtpEmail func error occured ${e.toString()}");
      return null;
    }
  }

  //DELETE ACCOUNT
  Future<void> deleteAccount() async {
    try {
      isDeletingAccount.value = true;
      await deleteUserLikes();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userss!.uid)
          .delete();
      await _auth.currentUser!.delete();
      Get.back();
      isDeletingAccount.value = false;
    } catch (e) {
      isDeletingAccount.value = false;
      print(e);
    }
  }

  //CHECK USER ALREADY EXISTS OR NOT
  Future<void> checkUserAlreadyExists(
      UserCredential value, String loginMethod) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: value.user!.email)
        .get()
        .then((allUsers) async {
      if (allUsers.docs.isEmpty) {
        print(
            'USER NOT EXIST ${value.user?.uid} ${value.user?.displayName} ${value.user?.email}');
        //IF USER NOT EXITS
        final UserModel _user = UserModel(
            id: value.user!.uid,
            name: value.user?.displayName ?? 'Unknown',
            loginMethod: loginMethod,
            email: value.user!.email,
            imageURL: value.user?.photoURL ??
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
            phone: "Social Signin Doesn't allow to show number",
            password: "Social Signin Doesn't allow to show password");

        await DataBase().createUser(_user);
      } else {
        print('USER EXIST');

        //IF USER EXIST
        final data = allUsers.docs[0];
        final UserModel _user = UserModel(
            id: value.user!.uid,
            friends: data.get('Friends'),
            followers: data.get('Followers'),
            likedRestaurents: data.get('LikedRestaurents'),
            name: data.get('Name'),
            loginMethod: loginMethod,
            email: value.user!.email,
            imageURL: data.get('ImageURL'),
            phone: "Social Signin Doesn't allow to show number",
            password: "Social Signin Doesn't allow to show password");

        await DataBase().createUser(_user);
      }
    });
    
  }

  //UPDATE USERINFO EVERYWHERE
  Future<void> updateLikeUserInfo() async {
    try {
      if (userInfo.likedRestaurents!.isNotEmpty) {
        userInfo.likedRestaurents!.forEach((element) async {
          final data = await FirebaseFirestore.instance
              .collection('Restaurents')
              .doc(element)
              .get();
          Map likes = data.get('LikedBy');
          likes[userss!.uid] = {
            'id': userss!.uid,
            'Photo': userInfo.imageURL,
            'Name': userInfo.name
          };
          //UPDATING
          await FirebaseFirestore.instance
              .collection('Restaurents')
              .doc(element)
              .update({'LikedBy': likes});
        });
      }
    } catch (e) {
      print(e);
    }
  }

  //DELETE USERS LIKES
  Future<void> deleteUserLikes() async {
    try {
      if (userInfo.likedRestaurents!.isNotEmpty) {
        userInfo.likedRestaurents!.forEach((element) async {
          final data = await FirebaseFirestore.instance
              .collection('Restaurents')
              .doc(element)
              .get();
          Map likes = data.get('LikedBy');
          likes.remove(userss!.uid);
          //UPDATING
          await FirebaseFirestore.instance
              .collection('Restaurents')
              .doc(element)
              .update({'LikedBy': likes});
        });
      }
    } catch (e) {}
  }
}

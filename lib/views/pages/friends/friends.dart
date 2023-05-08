// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:get/get.dart';
// import 'package:nibbles/constants/colors.dart';
// import 'package:nibbles/utils/size_config.dart';
// import 'package:nibbles/views/pages/bottom%20nav%20bar/profile/profile.dart';
// import 'package:nibbles/views/widgets/custom_backbutton.dart';

// class FriendsPage extends StatelessWidget {
//   TextEditingController searchCont = TextEditingController();

//   FriendsPage({Key? key, required this.whichUser}) : super(key: key);
//   final String whichUser;
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: SizeConfig.widthMultiplier * 6),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               SizedBox(
//                 height: SizeConfig.heightMultiplier * 5,
//               ),
//               Row(
//                 children: [
//                   const CustomBackButton(),
//                   SizedBox(
//                     width: SizeConfig.widthMultiplier * 6,
//                   ),
//                   Text(
//                     "Friends",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: SizeConfig.textMultiplier * 3.8),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: SizeConfig.heightMultiplier * 2,
//               ),
//               FriendsSearchField(controller: searchCont),
//               SizedBox(
//                 height: SizeConfig.heightMultiplier * 1,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: SizeConfig.widthMultiplier * 4),
//                 child: Text(
//                   whichUser=="Other" ? "Found" : "My Friends",
//                   style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: SizeConfig.textMultiplier * 2.1),
//                 ),
//               ),
//               SizedBox(
//                 height: SizeConfig.heightMultiplier * 3,
//               ),
//               Expanded(
//                   child: AnimationLimiter(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: 10,
//                   padding: EdgeInsets.symmetric(
//                       horizontal: SizeConfig.widthMultiplier * 4),
//                   physics: const BouncingScrollPhysics(
//                       parent: AlwaysScrollableScrollPhysics()),
//                   itemBuilder: (BuildContext context, int index) {
//                     return AnimationConfiguration.staggeredList(
//                       position: index,
//                       delay: const Duration(milliseconds: 100),
//                       child: SlideAnimation(
//                         duration: const Duration(milliseconds: 2500),
//                         curve: Curves.fastLinearToSlowEaseIn,
//                         child: FadeInAnimation(
//                             curve: Curves.fastLinearToSlowEaseIn,
//                             duration: const Duration(milliseconds: 2500),
//                             child: FriendsTile(whichUser: whichUser),
//                       ),
//                     ));
//                   },
//                 ),
//               )),

//             ])));
//   }
// }

// class FriendsTile extends StatelessWidget {
//   const FriendsTile({
//     Key? key,
//     required this.whichUser,
//   }) : super(key: key);
//   final String whichUser;
//   @override
//   Widget build(BuildContext context) {
//     print(whichUser);
//     return Padding(
//       padding: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 3),
//       child: InkWell(
//         onTap: () {
//           Get.to(
//               () => const ProfilePage(
//                     isOtherUser: true,
//                   ),
//               transition: Transition.leftToRight);
//         },
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: SizeConfig.widthMultiplier * 7.5,
//               backgroundColor: Colors.grey.shade100,
//               backgroundImage: NetworkImage( whichUser=="Other"
//                   ? "https://www.whatsappprofiledpimages.com/wp-content/uploads/2021/11/alone-Best-Dp-Profile-Images-For-Instagram-photo.gif"
//                   : "https://thypix.com/wp-content/uploads/2021/10/anime-avatar-profile-picture-thypix-m.jpg"),
//             ),
//             SizedBox(
//               width: SizeConfig.widthMultiplier * 4,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   whichUser=="Other" ? "Sam jon" : "Linda John",
//                   style: TextStyle(
//                       fontSize: SizeConfig.textMultiplier * 1.8,
//                       fontWeight: FontWeight.w600,
//                       color: kPrimaryColor),
//                 ),
//                 SizedBox(
//                   height: SizeConfig.heightMultiplier * 0.4,
//                 ),
//                 Text(
//                   whichUser=="Other" ? "150 Friends" : "348 Friends",
//                   style: TextStyle(
//                       fontSize: SizeConfig.textMultiplier * 1.4,
//                       color: Colors.grey.shade600),
//                 )
//               ],
//             ),
//             const Spacer(),
//             whichUser=="Other" ? const Icon(Icons.person_add) : const SizedBox(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FriendsSearchField extends StatelessWidget {
//   const FriendsSearchField({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   final TextEditingController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         height: SizeConfig.heightMultiplier * 6,
//         width: SizeConfig.widthMultiplier * 80,
//         decoration: BoxDecoration(
//             color: Colors.grey.shade100,
//             borderRadius: BorderRadius.circular(12)),
//         padding:
//             EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 4),
//         child: Row(
//           children: [
//             Icon(
//               FeatherIcons.search,
//               color: Colors.grey.shade600,
//             ),
//             SizedBox(
//               width: SizeConfig.widthMultiplier * 3,
//             ),
//             Expanded(
//                 child: TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.all(0),
//                   hintText: "Add friends",
//                   hintStyle: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey.shade400)),
//             ))
//           ],
//         ),
//       ),
//     );
//   }
// }

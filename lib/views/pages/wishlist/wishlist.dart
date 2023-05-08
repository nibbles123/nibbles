import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/controllers/restaurents_controller.dart';
import 'package:nibbles/models/restaurent_model.dart';
import 'package:nibbles/services/database.dart';
import 'package:nibbles/services/google_photo_service.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/bottom%20sheet/hotel%20details/hotel_details.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/loading.dart';
import 'package:nibbles/views/widgets/no_data.dart';
import 'package:nibbles/views/widgets/wishlist_tile.dart';

import '../../widgets/show_loading.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key, required this.userID, required this.isLiked})
      : super(key: key);
  final String userID;
  final bool isLiked;

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  final wishListCont = Get.find<RestaurentsController>();
  final authCont = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    print('USER ${widget.userID} && MY ID ${authCont.userss!.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  widget.isLiked ? 'Liked' : "Wishlist",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.textMultiplier * 3.8),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 2,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: widget.isLiked
                    ? FirebaseFirestore.instance
                        .collection('Users')
                        .doc(widget.userID)
                        .collection('Likes')
                        .orderBy('Date', descending: true)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('Users')
                        .doc(widget.userID)
                        .collection('WishList')
                        .orderBy('Date', descending: true)
                        .snapshots(),
                builder: (_, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting
                    ? LoadingWidget(height: SizeConfig.heightMultiplier * 80)
                    : snapshot.data!.docs.isEmpty
                        ? NoDataWidget(
                            height: SizeConfig.heightMultiplier * 75,
                            noDataText: widget.isLiked
                                ? 'No Liked Items Found!'
                                : "No Wishlist Items Found!",
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (_, index) => WishListHotelsTile(
                                      onTap: () async {
                                        final data = await FirebaseFirestore
                                            .instance
                                            .collection('Restaurents')
                                            .doc(snapshot.data!.docs[index]
                                                .get('id'))
                                            .get();
                                        final restaurentInfo = RestaurentModel
                                            .fromDocumentSnapshot(data);

                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (_) =>
                                                HotelDetailsBottomSheet(
                                                    whichOffer: '',
                                                    isOffersPage: false,
                                                    restaurent:
                                                        restaurentInfo));
                                      },
                                      image: GooglePhotoService.getPhotoURL(
                                        snapshot.data!.docs[index].get('Image'),
                                      ),
                                      title: snapshot.data!.docs[index]
                                          .get('Name'),
                                    )),
                          )),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/controllers/directory_cont.dart';
import 'package:nibbles/models/restaurent_model.dart';
import 'package:nibbles/services/google_photo_service.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:nibbles/views/bottom%20sheet/hotel%20details/hotel_details.dart';
import 'package:nibbles/views/widgets/custom_backbutton.dart';
import 'package:nibbles/views/widgets/custom_searchfield.dart';
import 'package:nibbles/views/widgets/custom_subtitle.dart';
import 'package:nibbles/views/widgets/loading.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'components/tile.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage(
      {Key? key, required this.isOffersPage, required this.whichOffer})
      : super(key: key);
  final bool isOffersPage;
  final String whichOffer;
  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  TextEditingController searchCont = TextEditingController();

  final cont = Get.find<DirectoryCont>();
  @override
  void initState() {
    super.initState();
    if (widget.isOffersPage) {
      Future.delayed(
          Duration.zero, () => cont.getOffersRestaurents(offerType()));
    }
  }

  String getOfferFieldName() {
    if (widget.whichOffer == 'Buffet Deals') return 'BuffetDeals';
    if (widget.whichOffer == 'Cash Voucher') return 'CashVouncher';
    if (widget.whichOffer == 'Set Deals')
      return 'SetDeals';
    else
      return '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.heightMultiplier * 90,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  widget.isOffersPage
                      ? const CustomBackButton()
                      : const SizedBox(),
                  SizedBox(
                      width: widget.isOffersPage
                          ? SizeConfig.widthMultiplier * 5
                          : 0),
                  Text(
                    widget.isOffersPage ? widget.whichOffer : "Directory",
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
                hintText: "Search for restaurents",
                controller: searchCont,
                onChange: (val) {
                  // if (val.isNotEmpty) {
                  //   cont.searchRestaurents(offersType, val);
                  // }
                  setState(() {});
                },
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),
              searchCont.text.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 4),
                      child: Text(
                        "Restaurants",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: SizeConfig.textMultiplier * 2.1),
                      ),
                    ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),
              if (!widget.isOffersPage) ...[
                searchCont.text.isNotEmpty
                    ?
                    //IF SEARCH
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Restaurents')
                            .where('BuffetDeals',
                                isNotEqualTo: widget.isOffersPage ? '' : null)
                            .where('searchKey',
                                isGreaterThanOrEqualTo:
                                    searchCont.text.toLowerCase())
                            .limit(10)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return Expanded(
                              child: snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      color: kPrimaryColor,
                                    ))
                                  : ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (_, index) {
                                        final data = RestaurentModel
                                            .fromDocumentSnapshot(
                                                snapshot.data!.docs[index]);
                                        return DirectoryTile(
                                            whichOffer: getOfferFieldName(),
                                            data: data,
                                            widget: widget);
                                      }));
                        })
                    :
                    //IF SEARCH IS NOT
                    Expanded(
                        child: PaginateFirestore(
                          itemBuilderType: PaginateBuilderType.listView,
                          isLive: true,
                          query: FirebaseFirestore.instance
                              .collection('Restaurents')
                              .orderBy('Rank'),
                          initialLoader: Center(
                              child: CircularProgressIndicator(
                                  color: kPrimaryColor)),
                          padding: EdgeInsets.zero,
                          bottomLoader: Center(
                              child: CircularProgressIndicator(
                                  color: kPrimaryColor)),
                          itemBuilder: (context, documentSnapshot, index) {
                            final data = RestaurentModel.fromDocumentSnapshot(
                                documentSnapshot[index]);
                            return DirectoryTile(
                                whichOffer: widget.whichOffer,
                                data: data,
                                widget: widget);
                          },
                        ),
                      ),
              ]

              //IF IT IS OFFERS PAGE
              else ...[
                Obx(
                  () => cont.isLoading.value
                      ? LoadingWidget(height: SizeConfig.heightMultiplier * 60)
                      : Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: searchCont.text.isNotEmpty
                                  ? cont
                                      .searchRestaurent(
                                          searchCont.text.toLowerCase(),
                                          offerType())
                                      .length
                                  : offerRestaurens().length,
                              shrinkWrap: true,
                              itemBuilder: (_, index) => DirectoryTile(
                                  data: searchCont.text.isNotEmpty
                                      ? cont.searchRestaurent(
                                          searchCont.text.toLowerCase(),
                                          offerType())[index]
                                      : offerRestaurens()[index],
                                  widget: widget,
                                  whichOffer: getOfferFieldName())),
                        ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  OffersType offerType() {
    if (widget.whichOffer == 'Buffet Deals') {
      return OffersType.BUFFET;
    }
    if (widget.whichOffer == 'Cash Voucher') {
      return OffersType.CASH;
    }
    if (widget.whichOffer == 'Set Deals') {
      return OffersType.SETDEALS;
    } else {
      return OffersType.NONE;
    }
  }

  List<RestaurentModel> offerRestaurens() {
    if (offerType() == OffersType.BUFFET) {
      return cont.getbuffetDeals!;
    }
    if (offerType() == OffersType.CASH) {
      return cont.getcashVouncher!;
    }
    if (offerType() == OffersType.SETDEALS) {
      return cont.getSetDeals!;
    } else {
      return [];
    }
  }
}

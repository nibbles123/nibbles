import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nibbles/models/restaurent_model.dart';

class DirectoryCont extends GetxController {
  final cashVouncher = <RestaurentModel>[].obs;
  List<RestaurentModel>? get getcashVouncher => cashVouncher;
  final buffetDeals = <RestaurentModel>[].obs;
  List<RestaurentModel>? get getbuffetDeals => buffetDeals;
  final setDeals = <RestaurentModel>[].obs;
  List<RestaurentModel>? get getSetDeals => setDeals;
  RxBool isLoading = false.obs;

  DocumentSnapshot? lastVisibleSimple = null;

  List<RestaurentModel> searchRestaurent(String query, OffersType offerType) {
    if (offerType == OffersType.BUFFET) {
      return buffetDeals
          .where((person) =>
              person.searckKey!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    if (offerType == OffersType.CASH) {
      return cashVouncher
          .where((person) =>
              person.searckKey!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    if (offerType == OffersType.SETDEALS) {
      return setDeals
          .where((person) =>
              person.searckKey!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      return [];
    }
  }

  getOffersRestaurents(OffersType offerType) async {
    try {
      print(offerType);
      isLoading.value = true;
      //BUFFET DEALS
      if (offerType == OffersType.BUFFET) {
       
        if (buffetDeals.isEmpty) {
          final data = await FirebaseFirestore.instance
              .collection('Restaurents')
              .where('BuffetDeals', isNull: false)
              .get();

          data.docs.forEach((element) {
            buffetDeals.add(RestaurentModel.fromDocumentSnapshot(element));
          });
           print('Buffet ${buffetDeals.length}');
        }
      }
      //CASH VOUCHER
      if (offerType == OffersType.CASH) {
        if (cashVouncher.isEmpty) {
          final data = await FirebaseFirestore.instance
              .collection('Restaurents')
              .where('CashVouncher', isNull: false)
              .get();

          data.docs.forEach((element) {
            cashVouncher.add(RestaurentModel.fromDocumentSnapshot(element));
          });
           print('CASH ${cashVouncher.length}');

        }
      }
      //SET DEALS
      if (offerType == OffersType.SETDEALS) {
        if (setDeals.isEmpty) {
          final data = await FirebaseFirestore.instance
              .collection('Restaurents')
              .where('SetDeals', isNull: false)
              .get();

          data.docs.forEach((element) {
            setDeals.add(RestaurentModel.fromDocumentSnapshot(element));
          });
           print('SET DEALS ${setDeals.length}');

        }
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }
}

enum OffersType { NONE, BUFFET, CASH, SETDEALS }

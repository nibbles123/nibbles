import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nibbles/controllers/restaurents_controller.dart';

import '../controllers/auth_controller.dart';
import '../controllers/filter_controller.dart';
import '../models/restaurent_model.dart';
import 'current_location.dart';

class RestaurentService {
  final authCont = Get.find<AuthController>();
  final filterCont = Get.find<FilterController>();

  final restCont = Get.find<RestaurentsController>();

  //FOR SHOWING RESTAURENTS
  Stream<List<RestaurentModel>> streamForRestaurents() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    restCont.isLoading.value = true;
    // int pageSize = 10;
    
    return _firestore
        .collection("Restaurents")
       .orderBy('Rank')
        .snapshots()
        .map((QuerySnapshot query) {
      return getFileredData(query);
      
    });
  }

  getFileredData(QuerySnapshot query) {
    List<RestaurentModel> restaurents = [];
    for (int i = 0; i < query.docs.length; i++) {
      if (filterCont.filterChoices.isNotEmpty) {
        if (filterCont.filterChoices.contains(query.docs[i].get("Cuisine"))) {
          if (filterCont.selectedPrice.isNotEmpty) {
            //IF PRICE CONTAINS -
            if (query.docs[i].get('Price').contains('-')) {
              if (filterCont.selectedPrice
                  .contains(query.docs[i].get('Price').split('-')[0].trim())) {
                if (filterCont.selectedLocality.isNotEmpty) {
                  if (filterCont.selectedLocality
                      .contains(query.docs[i].get('Locality'))) {
                    if (filterCont.isNearby.value) {
                      if (CurrentLocationService().distance(
                              authCont.userLat.value,
                              authCont.userLng.value,
                              query.docs[i].get('Lat'),
                              query.docs[i].get('Lng'),
                              'K') <=
                          filterCont.distanceSliderVal.value) {
                        restaurents.add(RestaurentModel.fromDocumentSnapshot(
                            query.docs[i]));
                      }
                    } else {
                      restaurents.add(
                          RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                    }
                  }
                } else {
                  if (filterCont.isNearby.value) {
                    if (CurrentLocationService().distance(
                            authCont.userLat.value,
                            authCont.userLng.value,
                            query.docs[i].get('Lat'),
                            query.docs[i].get('Lng'),
                            'K') <=
                        filterCont.distanceSliderVal.value) {
                      restaurents.add(
                          RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                    }
                  } else {
                    restaurents.add(
                        RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                  }
                }
              }
            }
            //IF PRICE IS NORMAL
            if (filterCont.selectedPrice.contains(query.docs[i].get("Price"))) {
              if (filterCont.selectedLocality.isNotEmpty) {
                if (filterCont.selectedLocality
                    .contains(query.docs[i].get('Locality'))) {
                  if (filterCont.isNearby.value) {
                    if (CurrentLocationService().distance(
                            authCont.userLat.value,
                            authCont.userLng.value,
                            query.docs[i].get('Lat'),
                            query.docs[i].get('Lng'),
                            'K') <=
                        filterCont.distanceSliderVal.value) {
                      restaurents.add(
                          RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                    }
                  } else {
                    restaurents.add(
                        RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                  }
                }
              } else {
                if (filterCont.isNearby.value) {
                  if (CurrentLocationService().distance(
                          authCont.userLat.value,
                          authCont.userLng.value,
                          query.docs[i].get('Lat'),
                          query.docs[i].get('Lng'),
                          'K') <=
                      filterCont.distanceSliderVal.value) {
                    restaurents.add(
                        RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                  }
                } else {
                  restaurents
                      .add(RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                }
              }
            }
          } else {
            if (filterCont.selectedLocality.isNotEmpty) {
              if (filterCont.selectedLocality
                  .contains(query.docs[i].get('Locality'))) {
                if (filterCont.isNearby.value) {
                  if (CurrentLocationService().distance(
                          authCont.userLat.value,
                          authCont.userLng.value,
                          query.docs[i].get('Lat'),
                          query.docs[i].get('Lng'),
                          'K') <=
                      filterCont.distanceSliderVal.value) {
                    restaurents.add(
                        RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                  }
                } else {
                  restaurents
                      .add(RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                }
              }
            } else {
              if (filterCont.isNearby.value) {
                if (CurrentLocationService().distance(
                        authCont.userLat.value,
                        authCont.userLng.value,
                        query.docs[i].get('Lat'),
                        query.docs[i].get('Lng'),
                        'K') <=
                    filterCont.distanceSliderVal.value) {
                  restaurents
                      .add(RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                }
              } else {
                restaurents
                    .add(RestaurentModel.fromDocumentSnapshot(query.docs[i]));
              }
            }
          }
        }
      } else {
        if (filterCont.selectedPrice.isNotEmpty) {
          //IF PRICE CONTAINS -
          if (query.docs[i].get('Price').contains('-')) {
            if (filterCont.selectedPrice.contains(
                    query.docs[i].get('Price').split('-')[0].trim()) ||
                filterCont.selectedPrice.contains(
                    query.docs[i].get('Price').split('-')[1].trim())) {
              if (filterCont.selectedLocality.isNotEmpty) {
                if (filterCont.selectedLocality
                    .contains(query.docs[i].get('Locality'))) {
                  if (filterCont.isNearby.value) {
                    if (CurrentLocationService().distance(
                            authCont.userLat.value,
                            authCont.userLng.value,
                            query.docs[i].get('Lat'),
                            query.docs[i].get('Lng'),
                            'K') <=
                        filterCont.distanceSliderVal.value) {
                      restaurents.add(
                          RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                    }
                  } else {
                    restaurents.add(
                        RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                  }
                }
              } else {
                if (filterCont.isNearby.value) {
                  if (CurrentLocationService().distance(
                          authCont.userLat.value,
                          authCont.userLng.value,
                          query.docs[i].get('Lat'),
                          query.docs[i].get('Lng'),
                          'K') <=
                      filterCont.distanceSliderVal.value) {
                    restaurents.add(
                        RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                  }
                } else {
                  restaurents
                      .add(RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                }
              }
            }
          }
          //IF PRICE IS NORMAL
          if (filterCont.selectedPrice.contains(query.docs[i].get("Price"))) {
            if (filterCont.selectedLocality.isNotEmpty) {
              if (filterCont.selectedLocality
                  .contains(query.docs[i].get('Locality'))) {
                if (filterCont.isNearby.value) {
                  if (CurrentLocationService().distance(
                          authCont.userLat.value,
                          authCont.userLng.value,
                          query.docs[i].get('Lat'),
                          query.docs[i].get('Lng'),
                          'K') <=
                      filterCont.distanceSliderVal.value) {
                    restaurents.add(
                        RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                  }
                } else {
                  restaurents
                      .add(RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                }
              }
            } else {
              if (filterCont.isNearby.value) {
                if (CurrentLocationService().distance(
                        authCont.userLat.value,
                        authCont.userLng.value,
                        query.docs[i].get('Lat'),
                        query.docs[i].get('Lng'),
                        'K') <=
                    filterCont.distanceSliderVal.value) {
                  restaurents
                      .add(RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                }
              } else {
                restaurents
                    .add(RestaurentModel.fromDocumentSnapshot(query.docs[i]));
              }
            }
          }
        } else {
          if (filterCont.selectedLocality.isNotEmpty) {
            if (filterCont.selectedLocality
                .contains(query.docs[i].get('Locality'))) {
              if (filterCont.isNearby.value) {
                if (CurrentLocationService().distance(
                        authCont.userLat.value,
                        authCont.userLng.value,
                        query.docs[i].get('Lat'),
                        query.docs[i].get('Lng'),
                        'K') <=
                    filterCont.distanceSliderVal.value) {
                  restaurents
                      .add(RestaurentModel.fromDocumentSnapshot(query.docs[i]));
                }
              } else {
                restaurents
                    .add(RestaurentModel.fromDocumentSnapshot(query.docs[i]));
              }
            }
          } else {
            if (filterCont.isNearby.value) {
              if (CurrentLocationService().distance(
                      authCont.userLat.value,
                      authCont.userLng.value,
                      query.docs[i].get('Lat'),
                      query.docs[i].get('Lng'),
                      'K') <=
                  filterCont.distanceSliderVal.value) {
                restaurents
                    .add(RestaurentModel.fromDocumentSnapshot(query.docs[i]));
              }
            } else {
              restaurents
                  .add(RestaurentModel.fromDocumentSnapshot(query.docs[i]));
            }
          }
        }
      }
    }

    return restaurents;
  }
}

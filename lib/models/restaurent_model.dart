import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurentModel {
  String? id,
      title,
      address,
      locality,
      cuisine,
      // imgURL,
      phone,
      website,
      placeID,
      //I add this value
      chopeID,
      reservationLink,
      searckKey,
      price,
      cashVouncher,
      buffetDeals,
      setDeals;
  int? rank, postalCode;
  double? lat, lng;
  List? openingHours, photos, wishList;
  List? likedBY;
  RestaurentModel({
    this.address,
    this.locality,
    this.reservationLink,
    // this.city,
    this.wishList,
    this.photos,
    this.searckKey,
    this.cuisine,
    this.id,
    this.likedBY,
    this.cashVouncher,
    this.buffetDeals,
    this.setDeals,
    // this.imgURL,
    this.lat,
    this.lng,
    this.phone,
    this.placeID,
    this.postalCode,
    this.price,
    this.rank,
    this.title,
    this.website,
    this.chopeID,
  });
  RestaurentModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc.id;
    address = doc["Address"];
    locality = doc['Locality'];
    // city = doc["City"];
    cuisine = doc["Cuisine"];
    // imgURL = doc["ImgURL"];
    reservationLink = doc['ReservationLink'] ?? '';
    setDeals = doc['SetDeals'];
    buffetDeals = doc['BuffetDeals'];
    cashVouncher = doc['CashVouncher'];
    lat = doc["Lat"];
    lng = doc["Lng"];
    wishList = doc['WishList'];
    chopeID = doc['ChopeID'].toString();
    if (doc["LikedBy"] != null) {
      likedBY = doc["LikedBy"].values.toList();
    }

    phone = doc["Phone"];
    placeID = doc["PlaceID"];
    price = doc["Price"];
    rank = doc["Rank"];

    title = doc["Title"];
    website = doc["Website"];
    openingHours = doc["OpeningHours"];
    photos = doc["Photos"];
    searckKey = doc['searchKey'];
  }
}

class OpeningHours {
  String? day, time;
  OpeningHours({this.day, this.time});
  OpeningHours.fromJson(Map<String, dynamic> doc) {
    day = doc["Day"];
    time = doc["Time"];
  }
}

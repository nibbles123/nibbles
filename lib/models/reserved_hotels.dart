import 'package:cloud_firestore/cloud_firestore.dart';

class ReservedModel {
  String? id,
      createdAt,
      reservedDate,
      hotelLocation,
      hotelName,
      imgURL,
      guests,
      time;
  int? dateIndex;
  ReservedModel(
      {this.createdAt,
      this.guests,
      this.hotelLocation,
      this.hotelName,
      this.imgURL,
      this.id,
      this.dateIndex,
      this.reservedDate,
      this.time});
  ReservedModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc.id;
    createdAt = doc["CreatedAt"];
    reservedDate = doc["Date"];
    hotelLocation = doc["HotelLocation"];
    hotelName = doc["HotelName"];
    imgURL = doc["HotelPicture"];
    dateIndex=doc["DateIndex"];
    guests = doc["NumberOfGuests"];
    time = doc["Time"];
  }
}

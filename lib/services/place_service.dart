import 'package:nibbles/models/place.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PlaceService {
  static Future<PlaceModel> getPlace(String placeID) async {
    String myGoogleApiKey = "AIzaSyBwAY3XYiLYN3caL2ZBphWg7PwVmyzVHDM";
    
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$myGoogleApiKey");
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    // print(json);
    return PlaceModel.fromJson(json);
  }

  // static Future<String> photoURL(String photoRef) async {
  //   String myGoogleApiKey = "";
  //   var url = Uri.parse(
  //       "");
  //   var response = await http.get(url);
  //   return response.body;
  // }
}

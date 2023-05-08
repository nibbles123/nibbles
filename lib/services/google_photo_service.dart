class GooglePhotoService {
  static String getPhotoURL(String photoRef) {
    String photoURl =
        "https://maps.googleapis.com/maps/api/place/photo?maxheight=1600&photo_reference=$photoRef&key=AIzaSyBwAY3XYiLYN3caL2ZBphWg7PwVmyzVHDM";
    return photoURl;
  }
}

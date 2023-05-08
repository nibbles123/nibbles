import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/constants/icons.dart';
import 'package:nibbles/controllers/auth_controller.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    Key? key,
    required this.lat,
    required this.lng,
    required this.id,
  }) : super(key: key);
  final double lat, lng;
  final String id;
  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final authCont = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,
        () => loadPlaces().then((value) => authCont.isLoading.value = false));
  }

  //FOR SHOWING PROPERTIES ON MAPS
  List<Marker> markers = <Marker>[];
  Future<void> loadPlaces() async {
    authCont.isLoading.value = true;
    final Uint8List markerIcon =
        await getBytesFromAsstes(restaurentMarker, 130);

    markers.add(Marker(
      markerId: MarkerId(widget.id.toString()),
      // onTap: () {},
      icon: BitmapDescriptor.fromBytes(markerIcon),
      position: LatLng(widget.lat, widget.lng),
    ));

    print("Markers ${markers.length} ${widget.lat} ${widget.lng}");
  }

  //MAKING CUSTOM MARKER
  Future<Uint8List> getBytesFromAsstes(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: SizeConfig.heightMultiplier * 25,
          width: SizeConfig.widthMultiplier * 90,
          child: Obx(
            () => ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: authCont.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    )
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                            widget.lat,
                            widget.lng,
                          ),
                          zoom: 16),
                      zoomGesturesEnabled: false,
                      mapType: MapType.normal,
                      markers: Set<Marker>.of(markers),
                      zoomControlsEnabled: false,
                      onMapCreated: (cont) {},
                    ),
            ),
          ),
        ),
        InkWell(
          onTap: () => openMap(widget.lat, widget.lng),
          child: SizedBox(
            height: SizeConfig.heightMultiplier * 25,
            width: SizeConfig.widthMultiplier * 90,
          ),
        )
      ],
    );
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
}

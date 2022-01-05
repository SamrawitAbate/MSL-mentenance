import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maintenance/services/rout.dart';

class MapPage extends StatefulWidget {
  final GeoPoint position;
  final GeoPoint destination;
  const MapPage({
    required this.position,
    required this.destination,
    Key? key,
  }) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;

  final List<LatLng> polyPoints = []; // For holding Co-ordinates as LatLng
  final Set<Polyline> polyLines = {}; // For holding instance of Polyline
  final Set<Marker> markers = {}; // For holding instance of Marker
  var data;

  // Dummy Start and Destination Points
  double? startLat;
  double? startLng;
  double? endLat;
  double? endLng;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController?.setMapStyle(_mapStyle);
    setMarkers();
  }

  setMarkers() {
    markers.add(
      Marker(
        markerId: const MarkerId("Home"),
        position: LatLng(startLat!, startLng!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
          title: "Home",
          snippet: "Home Sweet Home",
        ),
      ),
    );

    markers.add(Marker(
      markerId: const MarkerId("Destination"),
      position: LatLng(endLat!, endLng!),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(
        title: "Masjid",
        snippet: "5 star ratted place",
      ),
    ));
    setState(() {});
  }

  void getJsonData() async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format

    NetworkHelper network = NetworkHelper(
      startLat: startLat!,
      startLng: startLng!,
      endLat: endLat!,
      endLng: endLng!,
    );

    try {
      // getData() returns a json Decoded data
      data = await network.getData();

      // We can reach to our desired JSON data manually as following
      LineString ls =
          LineString(data['features'][0]['geometry']['coordinates']);

      for (int i = 0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      if (polyPoints.length == ls.lineString.length) {
        setPolyLines();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  setPolyLines() {
    Polyline polyline = Polyline(
      polylineId: const PolylineId("polyline"),
      color: Colors.lightBlue,
      points: polyPoints,
    );
    polyLines.add(polyline);
    setState(() {});
  }

  String? _mapStyle;
  @override
  void initState() {
    super.initState();
    startLat = widget.position.latitude;
    startLng = widget.position.longitude;
    endLat = widget.destination.latitude;
    endLng = widget.destination.longitude;
    getJsonData();
    rootBundle.loadString('assets/file/mapstyle.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          // appBar: AppBar(),
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(startLat!, startLng!),
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            markers: markers,
            polylines: polyLines,
          ),
        ),
      ),
    );
  }
}

//Create a new class to hold the Co-ordinates we've received from the response data

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}

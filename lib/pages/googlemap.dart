import 'package:flutter/material.dart';
import 'dart:async';

// the map
import 'package:google_maps_flutter/google_maps_flutter.dart';

// location
import 'package:geolocator/geolocator.dart';

//snake bar
import 'snackBars.dart';

//language support
import 'package:lost/app_localizations.dart';

class ChooseMap extends StatefulWidget {
  @override
  _ChooseMapState createState() => _ChooseMapState();
}

class _ChooseMapState extends State<ChooseMap> {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 2,
  );

  Set<Marker> markers = Set();

  // creating a new MARKER
  Marker getMarker(lat, lng) => Marker(
        markerId: MarkerId('user'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: 'selected Location', snippet: null),
        draggable: true,
        onDragEnd: (position) {
          setState(() {
            // delete the old marker and add it again in the new the postion
            Marker userNewMarker =
                getMarker(position.latitude, position.longitude);
            markers.clear();
            markers.add(userNewMarker);
          });
        },
      );

  Completer<GoogleMapController> _controller = Completer();

  void getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final GoogleMapController controller = await _controller.future;

    CameraPosition userPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 16,
    );

    controller.animateCamera(CameraUpdate.newCameraPosition(userPosition));
    Marker userMarker = getMarker(position.latitude, position.longitude);
    setState(() {
      markers.add(userMarker);
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Builder(
              // build new context to show snake bar
              builder: (BuildContext context) => GoogleMap(
                myLocationEnabled: true,
                initialCameraPosition: _kGooglePlex,
                onTap: (position) {
                  // delete the old marker and add it again in the new the postion
                  Marker userNewMarker =
                      getMarker(position.latitude, position.longitude);
                  setState(() {
                    markers.clear();
                    markers.add(userNewMarker);
                  });
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  Scaffold.of(context)
                      .showSnackBar(chooseLocationSnackBar(context));
                },
                markers: markers,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 80),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Text(
                        AppLocalizations.of(context).translate('map_location'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 25,
                      ),
                    )
                  ],
                ),
                onPressed: () {
                  Marker element = markers.elementAt(0);
                  Navigator.of(context).pop({
                    'lat': element.position.latitude,
                    'lng': element.position.longitude
                  });
                },
              ),
            )
          ]),
    );
  }
}

Future<bool> checkGps() async {
  bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();

  return Future.value(isLocationEnabled);
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData? _currentLocation;
  Set<Marker> _markers = {};
  List<LatLng> _polylinePoints = [];
  PolylineId _polylineId = PolylineId('polylineId');

  Location location = Location();
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      var currentLocation = await location.getLocation();
      _updateLocation(currentLocation);
      _animateToUser();
    } catch (e) {
      print("Error getting current location: $e");
    }

    Timer.periodic(Duration(seconds: 10), (timer) async {
      try {
        var currentLocation = await location.getLocation();
        _updateLocation(currentLocation);
      } catch (e) {
        print("Error getting current location: $e");
      }
    });
  }

  void _updateLocation(LocationData locationData) {
    setState(() {
      _currentLocation = locationData;
      _markers = {
        Marker(
          markerId: MarkerId('location-id'),
          position: LatLng(locationData.latitude!, locationData.longitude!),
          infoWindow: InfoWindow(
            title: 'My current location',
            snippet:
            'Lat: ${locationData.latitude}, Lng: ${locationData.longitude}',
          ),
        ),
      };
      _polylinePoints.add(LatLng(locationData.latitude!, locationData.longitude!));
      _updatePolyline();
    });
  }

  void _animateToUser() {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _currentLocation?.latitude ?? 0,
            _currentLocation?.longitude ?? 0,
          ),
          zoom: 18,
        ),
      ),
    );
  }

  void _updatePolyline() {
    setState(() {
      _polylineId = PolylineId('polyline-id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location & Map Widgets Assignment'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(22.387836582924823, 91.86467267127456),
          zoom: 15,
        ),
        myLocationEnabled: true,
        markers: _markers,
        polylines: {
          Polyline(
            polylineId: _polylineId,
            color: Colors.blue,
            points: _polylinePoints,
          ),
        },
      ),
    );
  }
}

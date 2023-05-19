import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  void _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await _requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      Scaffold.of(context).setState(() {
        const SnackBar(content: Text(
            'kindly go to app setting and allow location permission'),);
      });
      return;
    }
    _getCurrentLocation();
  }

  _requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      const SnackBar(content: Text(
          'kindly give us permission so we can recomendation of nearby places'),);
    return;
  };
    if (permission == LocationPermission.deniedForever) {
      Scaffold.of(context).setState(() {
        const SnackBar(content: Text(
            'kindly go to app setting and allow location permission'),);
      });
      return;
    }
    _getCurrentLocation();

  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
    _getNearbyPlaces();
  }

  void _getNearbyPlaces() async {

    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition?.latitude},${_currentPosition?.longitude}&radius=50000&type=book_store&libraries&key=AIzaSyCArdlqNVBAhP_gG4LvNfcSTcGpJifTDOQ'));
    //Parse the response and add markers for each nearby place
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var place in data['results']) {
        double lat = place['geometry']['location']['lat'];
        double lng = place['geometry']['location']['lng'];
        String name = place['name'];
        _addMarker(lat, lng, name);
      }
    }
  }

  void _addMarker(double lat, double lng, String name) {
    LatLng position = LatLng(lat, lng);
    Marker marker = Marker(
      markerId: MarkerId(name),
      position: position,
      infoWindow: InfoWindow(title: name),
    );
    setState(() {
      _markers.add(marker);
    });
  }
  double zoom = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Book Shop'),
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          zoom: zoom,
        ),
        markers: Set<Marker>.from(_markers),
      ),
    );
  }
}
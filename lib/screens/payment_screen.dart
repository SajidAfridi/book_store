// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
//
// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     super.initState();
//     Stripe.publishableKey = 'YOUR_PUBLISHABLE_KEY';
//     Stripe.merchantIdentifier = 'YOUR_MERCHANT_IDENTIFIER';
//   }
//
//   Future<void> _processPayment() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//
//       try {
//         final paymentMethod = await Stripe.instance.createPaymentMethod(
//             params: PaymentMethodParams.card(paymentMethodData: PaymentMethodData(),
//         ),
//     );
//     // Send the payment method ID to your backend for processing
//     // Process the payment on the server and handle the response
//     // Show success message or handle any errors
//     } catch (error) {
//     // Handle error during payment processing
//     }
//   }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payment'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               CardField(
//                 onCardChanged: (card) {
//                   // Handle card changes if needed
//                 },
//               ),
//               ElevatedButton(
//                 onPressed: _processPayment,
//                 child: const Text('Pay'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ______________________________________________________________________
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController? _mapController;
//   Position? _currentPosition;
//   List<Marker> _markers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     _getNearbyPlaces();
//   }
//
//   void _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _currentPosition = position;
//     });
//   }
//
//   void _getNearbyPlaces() async {
//
//     final response = await http.get(Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition?.latitude},${_currentPosition?.longitude}&radius=5000&type=book_store,library&key=AIzaSyCArdlqNVBAhP_gG4LvNfcSTcGpJifTDOQ'));
//     print(response.body);
//     //Parse the response and add markers for each nearby place
//     if (response.statusCode == 200) {
//       print('here1');
//       final data = jsonDecode(response.body);
//       for (var place in data['results']) {
//         double lat = place['geometry']['location']['lat'];
//         double lng = place['geometry']['location']['lng'];
//         String name = place['name'];
//         _addMarker(lat, lng, name);
//       }
//     }
//   }
//
//   void _addMarker(double lat, double lng, String name) {
//     LatLng position = LatLng(lat, lng);
//     Marker marker = Marker(
//       markerId: MarkerId(name),
//       position: position,
//       infoWindow: InfoWindow(title: name),
//     );
//     setState(() {
//       _markers.add(marker);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Nearby: Book Stores /Libraries'),
//       ),
//       body: _currentPosition == null
//           ? const Center(child: CircularProgressIndicator())
//           : GoogleMap(
//         onMapCreated: (controller) {
//           setState(() {
//             _mapController = controller;
//           });
//         },
//         initialCameraPosition: CameraPosition(
//           target: LatLng(
//             _currentPosition!.latitude,
//             _currentPosition!.longitude,
//           ),
//           zoom: 15,
//         ),
//         markers: Set<Marker>.from(_markers),
//       ),
//     );
//   }
// }
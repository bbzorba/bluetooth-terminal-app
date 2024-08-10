import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Traveler App'),
        ),
        body: MapSample(),
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  List<Marker> _markers = [];
  List<String> _visitedCountries = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(51.5074, 0.1278),
              zoom: 2.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: _markers,
              ),
            ],
          ),
        ),
        RaisedButton(
          onPressed: () {
            _addVisitedCountry(LatLng(51.5074, 0.1278), 'United Kingdom');
          },
          child: Text('Add Visited Country'),
        ),
      ],
    );
  }

  void _addMarker(LatLng location, String countryName) {
    final Marker marker = Marker(
      width: 80.0,
      height: 80.0,
      point: location,
      builder: (ctx) => Container(
        child: Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 40.0,
        ),
      ),
    );
    setState(() {
      _markers.add(marker);
    });
  }

  // This function will add the visited country to the map.
  // You need to pass the LatLng of the country and the country name.
  // Example: _addVisitedCountry(LatLng(51.5074, 0.1278), 'United Kingdom');
  void _addVisitedCountry(LatLng location, String countryName) {
    _addMarker(location, countryName);
    setState(() {
      _visitedCountries.add(countryName);
    });
  }
}

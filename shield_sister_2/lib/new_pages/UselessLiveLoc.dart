import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class MyMap extends StatefulWidget {
  final String user_id;
  MyMap(this.user_id);

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  StreamSubscription<loc.LocationData>? _locationSubscription;
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Location Map'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back to the home page
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('location').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (_added) {
                      mymap(snapshot);
                    }
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return GoogleMap(
                      mapType: MapType.normal,
                      markers: {
                        Marker(
                          position: LatLng(
                            snapshot.data!.docs.singleWhere(
                                (element) => element.id == widget.user_id)['latitude'],
                            snapshot.data!.docs.singleWhere(
                                (element) => element.id == widget.user_id)['longitude'],
                          ),
                          markerId: MarkerId('id'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueMagenta),
                        ),
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          snapshot.data!.docs.singleWhere(
                              (element) => element.id == widget.user_id)['latitude'],
                          snapshot.data!.docs.singleWhere(
                              (element) => element.id == widget.user_id)['longitude'],
                        ),
                        zoom: 15,
                      ),
                      onMapCreated: (GoogleMapController controller) async {
                        setState(() {
                          _controller = controller;
                          _added = true;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _getLocation,
                      icon: Icon(Icons.my_location),
                      label: Text('Add Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _listenLocation,
                      icon: Icon(Icons.location_on),
                      label: Text('Enable Live'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _stopListening,
                      icon: Icon(Icons.stop),
                      label: Text('Stop Live'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
        snapshot.data!.docs.singleWhere(
            (element) => element.id == widget.user_id)['latitude'],
        snapshot.data!.docs.singleWhere(
            (element) => element.id == widget.user_id)['longitude'],
      ),
      zoom: 18,
    )));
  }

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': 'Shradha',
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentLocation) async {
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
        'name': 'Shradha', // Replace with a dynamic username if required
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }
}
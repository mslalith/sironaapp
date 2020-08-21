import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:medical_shop/helpers/location_helper.dart';


import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final Place initialLocation;
  final bool isSelecting;
  
  MapScreen({this.initialLocation = const Place(latitude: 37.22, longitude: -122.20, address: ' '), this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  LatLng _pickedLocation;
  bool isInit = true;
  bool isLoading = true;

  double lat;
  double lng;

  Future<void> _getCurrentLocation() async {

   final locData = await Location().getLocation();   
   final LatLng pos = LatLng(locData.latitude,locData.longitude);

   _pickedLocation = pos;

    setState(() {
       Marker(markerId: MarkerId('m1'), position: _pickedLocation);
      this.lat = locData.latitude;
      this.lng = locData.longitude;
      isLoading = false;
      isInit = false;
    });

  }

void _selectLocation(LatLng position) {
  setState(() {
    _pickedLocation = position;
  });
}



  @override
  Widget build(BuildContext context) {
  
  if(isInit) {
  _getCurrentLocation() ;
  }

  
    return Scaffold(

     appBar: AppBar(title: Text('Pick Your Address'),
     actions: <Widget> [

       IconButton(icon: Icon(Icons.add_location),
       onPressed: _getCurrentLocation,
       ),

       if(widget.isSelecting) 
         IconButton(icon: Icon(Icons.check), onPressed: _pickedLocation == null? null : () {
           Navigator.of(context).pop(_pickedLocation);
         })  
     ],
     ), 

     body: isLoading ? CircularProgressIndicator() :
     GoogleMap(initialCameraPosition: CameraPosition(target: LatLng(this.lat, this.lng),
     zoom: 12),

     onTap: widget.isSelecting ? _selectLocation : null,
     markers: {
       Marker(markerId: MarkerId('m1'), position: _pickedLocation),
     },
    ),
      
    );
  }
}
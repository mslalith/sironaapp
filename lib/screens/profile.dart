import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medical_shop/helpers/location_helper.dart';
import 'package:medical_shop/models/person.dart';
import 'package:medical_shop/providers/profile.dart';
import 'package:medical_shop/screens/mapScreen.dart';
import 'package:medical_shop/screens/splashScreen.dart';
import 'package:provider/provider.dart';

import 'addProfile.dart';

class ProfileDetail extends StatefulWidget {
  static const routeName = '/profileDetail';
   
  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}



class _ProfileDetailState extends State<ProfileDetail> {

  String mode = 'view';
  String dUrl, hUrl;
  bool home = true;
  bool del = false;

  void addProfile(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(AddProfile.routeName, 
    arguments: {'mode' : 'add'});
  }

  void editProfile() {
   Navigator.of(context).pushNamed(AddProfile.routeName, arguments: {
     'mode' : 'edit'});
  }

  Future<void> _selectOnMap(BuildContext context, double lat, double lng) async {

    print('$lat $lng');
    
    setState(() {
    final LatLng pos = LatLng(lat,lng);
    Navigator.of(context).push
     (MaterialPageRoute(builder: (ctx) =>
    Scaffold(

     appBar: AppBar(title: Text('Your Address'),
     ), 
     body:
     GoogleMap(initialCameraPosition: CameraPosition(target: LatLng(lat, lng),
     zoom: 12),
    markers: {
       Marker(markerId: MarkerId('m1'), position: pos),
     },
    ),
    )
    ))
    ;    
    });
  }

  @override
  Widget build(BuildContext context) {


final deviceSize = MediaQuery.of(context).size;

  final profileData = Provider.of<Profile>(context);
  Person person = profileData.getPerson;


if(person != null ) {
//   hUrl = LocationHelper.previewImage(latitude: person.homeLat,longitude:person.homeLong); 
//  dUrl = LocationHelper.previewImage(latitude: person.delLat,longitude:person.delLong);

}

    return Scaffold(
        backgroundColor: Color(0xffF2EFEF),
   
       appBar: AppBar(      
        title: Text('Profile Details', style: TextStyle(color: Colors.white),),
         backgroundColor: Color(0xff83BB40),
      ),
      
      body: person == null ? 
      SplashScreen()
      : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
        Container(
           height: deviceSize.height * 0.01,
        ),
        Center(
          child: Stack(
            children: <Widget>[                
              Center(
                child: Container(
                 width: deviceSize.width * 0.9,
                 height: deviceSize.height * 0.4, 
                 child: Center(
                   child: Container(
               height: deviceSize.height * 0.3,
                     decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                     color: Colors.black,
                      blurRadius: 5.0,
                          ),],
                        borderRadius: BorderRadius.circular(4) ,
                       color: Colors.white
                      ),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         Padding(
                           padding: const EdgeInsets.fromLTRB(20,50,20,5 ),
                           child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                             children: <Widget>[
                               Container(
                                 width: deviceSize.width * 0.4,
                                 child: Text('Name',
                                 style: TextStyle(
                                   fontSize: deviceSize.height * 0.023,
                                  color: Colors.green
                                 ),),
                               ),
           //                    Text('${person.phone}',
                                Expanded(
                                  child: Text('${person.name}',
                               style: TextStyle(
                                   fontSize: deviceSize.height * 0.023,
                                  color: Colors.black
                               ),),
                                ),  
                             ],
                           ),
                         ),
                         Container(
                               height: 1,
                               width: deviceSize.width * 0.8,
                               color: Colors.grey,
                             ),

                      Padding(
                           padding: const EdgeInsets.fromLTRB(20,10,20,5 ),
                           child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                             children: <Widget>[
                               Container(
                                 width: deviceSize.width * 0.4,
                                 child: Text('Phone',
                                 style: TextStyle(
                                  fontSize: deviceSize.height * 0.023,
                                  color: Colors.green
                                 ),),
                               ),
                         //      Text('${person.phone}',
                                Container(
                                  child: Text('${person.phone}',
                               style: TextStyle(
                                   fontSize: deviceSize.height * 0.023,
                                  color: Colors.black
                               ),),
                                ),  
                             ],
                           ),
                         ),
                         Container(
                               height: 1,
                               width: deviceSize.width * 0.8,
                               color: Colors.grey,
                             ),

                     Padding(
                           padding: const EdgeInsets.fromLTRB(20,10,20,5 ),
                           child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                             children: <Widget>[
                               Container(
                                  width: deviceSize.width * 0.4,
                                 child: Text('Alternate No.',
                                 style: TextStyle(
                                  fontSize: deviceSize.height * 0.023 ,
                                  color: Colors.green
                                 ),),
                               ),
                              //  Container(
                              //    width: deviceSize.width * 0.121,
                              //  ),
                      //         Text('${person.phone}',
                                Container(
                                  child: person.phone == null? Text('N/A',
                               style: TextStyle(
                                   fontSize: deviceSize.height * 0.023,
                                  color: Colors.black
                               ),) 
                               : Container(
                                 child: Text('${person.phone}',
                                 style: TextStyle(
                                     fontSize: deviceSize.height * 0.023,
                                    color: Colors.black
                                 ),),
                               ),
                                ),  
                             ],
                           ),
                         ),
                         Container(
                               height: 1,
                               width: deviceSize.width * 0.8,
                               color: Colors.grey,
                             ),
                              Padding(
                           padding: const EdgeInsets.fromLTRB(20,10,20,5 ),
                           child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                             children: <Widget>[
                               Container(
                                 width: deviceSize.width * 0.4,
                                 child: Text('e-Mail',

                                 style: TextStyle(
                                   fontSize: deviceSize.height * 0.023,
                                  color: Colors.green
                                 ),),
                               ),
                               
                          //     Text('${person.phone}',
                                Expanded(
                                  child: Text('${person.email}',
                               style: TextStyle(
                                  fontSize: deviceSize.height * 0.023,
                                  color: Colors.black
                               ),),
                                ),  
                             ],
                           ),
                         ),
                         Container(
                               height: 1,
                               width: deviceSize.width * 0.8,
                               color: Colors.grey,
                             ),
                       ],
                     ),
                   ),
                 ),
                  
                ),
              ),
            Center(
              child: Container(
                height: deviceSize.height * 0.11,
                width:  deviceSize.width * 0.21,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.0),
                ),
                child:Image.asset('lib/assets/images/user2.png',
                fit: BoxFit.contain,),
              ),
            ),

            Positioned(
            right: deviceSize.width * 0.03,
             bottom: deviceSize.height * 0.29 ,
            child: IconButton(
                      icon:Icon(Icons.edit,),
                      color: Colors.grey,
                      iconSize: 25,             
                      onPressed: editProfile,
                       ),
            ),
              
            ],

          ),    
        ),

        // For  Home Address
        Stack(         
          children: <Widget>[
            Container(           
            height: deviceSize.height * 0.15,
            width:  deviceSize.width * 0.9,
            decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                     color: Colors.black,
                      blurRadius: 5.0,
                          ),],
                        borderRadius: BorderRadius.circular(4) ,
                       color: Colors.white
                  ),
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width:  deviceSize.width * 0.8,
                  child: Text('Home Address', style: TextStyle(
                    color: Colors.green,
                    fontSize: deviceSize.height * 0.023
                  ),),
                ),
                Container(
                 width:  deviceSize.width * 0.8,
                  child: Text('${person.phone}', style: TextStyle(
                    color: Colors.black,
                    fontSize: deviceSize.height * 0.02
                  ),),
                ),
                Container(
                  height: deviceSize.height * 0.0005,
                  width: deviceSize.width * 0.8,
                  color: Colors.black,
                ),
                InkWell(                  
                  child: Container(
                    width:  deviceSize.width * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('View on Map ',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.blue,
                      ),
                      ),
                      Container(
                        height: deviceSize.height * 0.001,
                        width: deviceSize.width * 0.22,
                        color: Colors.blue
                      )
                      ],
                    ),
                  ),
                  onTap: () => _selectOnMap(context, 0 ,0)
                )
              ],
            ),
          ),
          ],

          ),

        // For Delievery Address

          Container(
           height: deviceSize.height * 0.03,
          ),

          Stack(         
          children: <Widget>[
            Container(           
            height: deviceSize.height * 0.15,
            width:  deviceSize.width * 0.9,
            decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                     color: Colors.black,
                      blurRadius: 5.0,
                          ),],
                        borderRadius: BorderRadius.circular(4) ,
                       color: Colors.white
                  ),
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width:  deviceSize.width * 0.8,
                  child: Text('Delivery Address', style: TextStyle(
                    color: Colors.green,
                    fontSize: deviceSize.height * 0.023
                  ),),
                ),
                Container(
                 width:  deviceSize.width * 0.8,
                  child: Text('${person.phone}', style: TextStyle(
                    color: Colors.black,
                    fontSize: deviceSize.height * 0.02
                  ),),
                ),
                Container(
                  height: deviceSize.height * 0.0005,
                  width: deviceSize.width * 0.8,
                  color: Colors.black,
                ),
                InkWell(                  
                  child: Container(
                    width:  deviceSize.width * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('View on Map ',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.blue,
                      ),
                      ),
                      Container(
                        height: deviceSize.height * 0.001,
                        width: deviceSize.width * 0.22,
                        color: Colors.blue
                      )
                      ],
                    ),
                  ),
                  onTap:  () => _selectOnMap(context, 0, 0)
                )
              ],
            ),
          ),
          ],

          ),
      
        ]
        ,
      )
    );
  }
}
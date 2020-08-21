import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:medical_shop/helpers/location_helper.dart';
import 'package:medical_shop/models/address.dart';
import 'package:medical_shop/models/item.dart';
import 'package:medical_shop/models/offer.dart';
import 'package:medical_shop/models/order.dart';
import 'package:medical_shop/models/person.dart';
import 'package:medical_shop/providers/addresses.dart';
import 'package:medical_shop/providers/offers.dart';
import 'package:medical_shop/providers/orders.dart';
import 'package:medical_shop/providers/profile.dart';
import 'package:medical_shop/screens/addPin.dart';
import 'package:medical_shop/screens/addProfile.dart';
import 'package:provider/provider.dart';

import 'confirmOrder.dart';
import 'mapScreen.dart';

class AddPlaceScreen extends StatefulWidget {

  static const routeName = '/addPlace';
  
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  final _couponController = TextEditingController();
  Offer offer;
  bool orderPlaced = false;
  bool orderSt = false;
  Person person;
  bool isInit = true;
  String _previewImageUrl;
  String title;
  String desc;
  List<PAddress> pAddresses = [];
  PAddress baseAddress;
  String dropdownValue ;
  PAddress dropAddr;
  List<Map<String, Object>> oImages;
  List<Item> oItems;
  Map<String,String> position;
  double lat;
  double lng;
  double disc;
  String imageInd;
  int selectedIndex = 0;
  String err = 'Please fill all details';
  
  
  Future<void> _getCurrentLocation() async {
    final locData =await Location().getLocation();  
    final pos = LatLng(locData.latitude,locData.longitude);
    final staticUrl = LocationHelper.previewImage(latitude: locData.latitude,longitude:locData.longitude);  
    setState(() {
      _previewImageUrl = staticUrl;
    this.lat = locData.latitude;
    this.lng = locData.longitude;
    });
  }

  Future<void> _selectOnMap(BuildContext context) async {
    final selectedLocation = await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>
    MapScreen(isSelecting: true,),));
  
    
   if (selectedLocation == null) {
     return;
   }
   final staticUrl = LocationHelper.previewImage(latitude: selectedLocation.latitude,longitude:selectedLocation.longitude);  
   print(selectedLocation);
   setState(() {
      _previewImageUrl = staticUrl;
  this.lat = selectedLocation.latitude;
   this.lng = selectedLocation.longitude;
    });
   
  }

  void removeOrder(BuildContext ctx, Item delItem) {
    setState(() {
          this.oItems.remove(delItem);
    });
  
    Navigator.of(context).pop(true);
    if(this.oItems.length == 0){
     Navigator.of(ctx).popUntil(ModalRoute.withName('/'));
    } 
  }

  void editProfile() {
   Navigator.of(context).pushNamed(AddProfile.routeName, arguments: {
     'mode' : 'edit'});
  }
  
  void addOrder(BuildContext ctx,String imageUrl1, String imageUrl2, String desc) async {
  
  // if (_addrController.text.trim() == '' || _addrController.text.length < 15 ) {
  //   setState(() {
  //     err = 'Please fill Valid address';
  //   });
  //   return;
  // } else if ( lat == null) {
  //   setState(() {
  //     err = 'Please Select location on Map';
  //   });
  //   return;
  // } else {

  Navigator.of(context).pop(true);
  imageInd = oItems[0].id == 1 ? 'YES' : 'NO' ;

  if (dropAddr.address.trim() == '') {
    this.err = 'Please enter valid address';
  } else {

    if (_couponController.text.trim() == '' ) {
      this.desc = ' ';
      this.disc = 0;
    } else {
    final offerData = Provider.of<OfferList>(context, listen: false);
    this.offer = offerData.getCoupon(_couponController.text.trim());
    this.desc = this.offer.code;
    this.disc = this.offer.disc;
    }
   

   final newOrder = Order(
    name: dropAddr.name,
    phone: person.phone,
    porder: dropAddr.phone,
    oDate: formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]),
    oTime: formatDate(DateTime.now(), [HH, ':', nn, ':', ss]),  
    lat: dropAddr.lat,
    imageInd: imageInd,
    lng: dropAddr.lng,
    deliveryAddr: dropAddr.address,
    delPerson: ' ',
    status: 'New Order',
    delCharge: 0,
    discCode: this.desc,
    discPerc: this.disc,
    remarks: ' ',
  );

 final ordersData = Provider.of<OrderList>(ctx,listen: false);
 orderSt = await ordersData.addOrder(newOrder, this.oItems, this.oImages);

 Navigator.of(context).pushNamed(ConfirmOrder.routeName);
  }

  }

  @override
  Widget build(BuildContext context) {
  final routeArgs = 
  ModalRoute.of(context).settings.arguments as Map<String,dynamic>;

   final addressData = Provider.of<AddressList>(context);
   pAddresses = addressData.getAddresses;
   baseAddress = addressData.baseAddress;
  
  final offerData = Provider.of<OfferList>(context);
   this.offer = offerData.getOffer();
   

   if(this.isInit) {
      this._couponController.text = this.offer == null ? ' ' : this.offer.code ;
   }

  final deviceSize = MediaQuery.of(context).size;

  void goAhead(BuildContext ctx) async {
    final deviceSize = MediaQuery.of(context).size;
    return showDialog(    
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: Container(
             width: deviceSize.width * 0.8,
             height: deviceSize.height * 0.25,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
              Container(
              width: deviceSize.width * 0.8,            
              child: Center(
                child: Text('PLEASE CLICK "YES" IF\nYOUR ORDER IS COMPLETE', 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: deviceSize.height * 0.02,
                  fontWeight: FontWeight.w500
                )),
              ),
            ),
            Container(
              height: deviceSize.height * 0.03,
            ),
              Container(
              height: deviceSize.height * 0.15,
              width: deviceSize.width * 0.4,
              child: Image.asset('lib/assets/images/sucConf.png', fit: BoxFit.contain ),
                 ),
               ],
             ),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
               FlatButton(
                child: Text('Yes'),
                onPressed: () => addOrder(context,' ',' ',' '),
              ),
            ],
          );
        });
  }

  void delConf(BuildContext ctx, Item delItem) async {
    final deviceSize = MediaQuery.of(context).size;
    return showDialog(    
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: Container(
             width: deviceSize.width * 0.8,
             height: deviceSize.height * 0.25,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
              Container(
              width: deviceSize.width * 0.8,            
              child: Center(
                child: Text('ARE YOU SURE YOU WANT\nTO REMOVE THIS ITEM?', 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: deviceSize.height * 0.02,
                  fontWeight: FontWeight.w500
                )),
              ),
            ),
            Container(
              height: deviceSize.height * 0.03,
            ),
              Container(
              height: deviceSize.height * 0.15,
              width: deviceSize.width * 0.4,
              child: Image.asset('lib/assets/images/delConf.png', fit: BoxFit.contain ),
                 ),
               ],
             ),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
               FlatButton(
                child: Text('Yes'),
                onPressed: () => removeOrder(context, delItem),
              ),
            ],
          );
        });
  }

  Future<void> _selectOnMap(BuildContext context, double lat, double lng) async {

    print('$lat $lng');
    
    setState(() {
    final LatLng pos = LatLng(lat,lng);
    Navigator.of(context).push
     (MaterialPageRoute(builder: (ctx) =>
    Scaffold(
      
     appBar: AppBar(title: Text('Your Address', style: TextStyle(
       color: Colors.white,
       fontSize: deviceSize.height * 0.023
     ),),
     backgroundColor: Color(0xff83BB40),
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

  final profileData = Provider.of<Profile>(context);
  this.person = profileData.getProfile;
  if(isInit){
    dropAddr = baseAddress ;
  isInit = false;
  }

  void _changeAddr(PAddress delAddr, int index){
    setState(() {
      this.selectedIndex = index;
      dropAddr = delAddr;
    });
  }
 

  this.oImages = routeArgs['images'];
  this.oItems = routeArgs['items'];
  print('in add place');
  print(this.oItems[0].imageUrl2);

    return Scaffold(
       backgroundColor: Color(0xffF2EFEF),
      appBar: AppBar(title: Text('Confirm Order'), backgroundColor: Color(0xff83BB40),),
      body: orderPlaced 
      ? Center(
       child: Stack(
         children: <Widget>[
          Image.asset('lib/assets/images/icon.png',
           height: deviceSize.height* 0.5,
           width: deviceSize.width * 0.5),
            Positioned(
             bottom: deviceSize.height* 0.2335,
             right: deviceSize.width* 0.2,
             child: CircularProgressIndicator()),
         ],
         )
      )
      : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[       
            Container(
            width: deviceSize.width,
              decoration: BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                       color: Color(0xff707070),
                        blurRadius: 5.0,
                            ),],
                          borderRadius: BorderRadius.circular(4) ,
                         color: Colors.white
                        ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[            
                Container(
                      height: deviceSize.height * 0.03,
                    ),

                 SingleChildScrollView(
                   child: Container(
                     width:  deviceSize.width * 0.97,
                     height: deviceSize.height * 0.2,
                     child: ListView.builder(
                     itemBuilder: (BuildContext ctxt, int index){
                          return Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                          //  Container(height: deviceSize.height * 0.05,),
                           Padding(
                             padding: EdgeInsets.only(top: deviceSize.height * 0.005),
                             child: Text('      ${index+1}.   ',
                             style: TextStyle(
                               fontSize: deviceSize.height * 0.023
                             ),),
                           ),
                           Container(
                             height: deviceSize.height * 0.03,
                             width: deviceSize.width * 0.03,                   
                     ),
                     Container(
                           width: deviceSize.width * 0.65,
                           height: deviceSize.width * 0.15,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: <Widget>[
                               Text('${oItems[index].desc}   ',style: TextStyle(
                             fontSize: deviceSize.height * 0.023
                           ),),
                           Container(
                             width: deviceSize.width * 0.65,
                             color: Colors.grey,
                             height: 1,
                           ),
                        
                           Row(
                    children: <Widget> [
                    Container(
                             child:
                          Text('${oItems[index].quantity} '
                          , style: TextStyle(fontSize: deviceSize.height * 0.017),)
                          ),
                          Container(
                             child:
                          Text('${oItems[index].type}'
                          , style: TextStyle(fontSize: deviceSize.height * 0.017, color: Color(0xffA2A2A2)),)
                          ),
                    ] ,
                  )
                             ],
                              ),
                     ),
                  Container(width: deviceSize.width * 0.05),
                          Padding(
                            padding:EdgeInsets.only(top: deviceSize.height * 0.005),
                            child: InkWell(
                              onTap: () => delConf(context, oItems[index]),
                              child: Image.asset('lib/assets/images/deIcon.png'),
                            ),
                          ) 
                     ],
                   )
                          ;
                     },
                     itemCount: oItems.length),
                   ),
                 ),
                ],
              ),
            ),

        Container(
                      height: deviceSize.height * 0.03,
                    ),

        Container(
          width: deviceSize.width * 0.97,
          height: deviceSize.height * 0.08,
          decoration: BoxDecoration(
            color: Colors.white,
          boxShadow: [
                        new BoxShadow(
                       color: Color(0xff707070),
                        blurRadius: 5.0,
                            ),],
            borderRadius: BorderRadius.circular(4) ,
          ),
          child: Row(
            children: <Widget>[
              Container(width: deviceSize.width * 0.01),
              Text('Enter Coupon Code (if any)', style: TextStyle(
                color: Color(0xff707070),
              ),),
              Container(width: deviceSize.width * 0.01),
              Flexible(
                      child: TextField(            
                        maxLength: 10,                                         
                      decoration: InputDecoration(      
                        counterText: "", 
                    enabledBorder: UnderlineInputBorder(      
	                 borderSide: BorderSide(color: Colors.grey),   
	               ),  
	              focusedBorder: UnderlineInputBorder(
	                borderSide: BorderSide(color: Colors.grey),
	              ),
            ),
                      textAlign: TextAlign.center,
                      controller: _couponController,                         
                      style: TextStyle(                       
                        fontSize: deviceSize.height * 0.025,
                        letterSpacing: 8,
                      ),
                      ),),
                      Container(width: deviceSize.width * 0.01),
            ],
          ),
        ),

         Container(
                      height: deviceSize.height * 0.03,
                    ),

          Container(
            height: deviceSize.height * 0.1,
            child: Row(
              children: <Widget>[
                Center(child: Text('  Deliver to:  ', style: TextStyle(color: Color(0xff707070)),)), 
              Container(
                width: deviceSize.width * 0.78,
                child: ListView.builder(
               scrollDirection: Axis.horizontal,
               itemBuilder: (BuildContext ctxt, int index){
               return 
                Padding(
                padding: EdgeInsets.fromLTRB(deviceSize.width * 0.03, deviceSize.height * 0.03, 0, deviceSize.height * 0.03),
              child: Container( 
               height: deviceSize.height * 0.03,
                width: deviceSize.width * 0.2,
                                       decoration: BoxDecoration(
                                             color:  this.selectedIndex == index ? Colors.white : Color(0xff83BB40),
                                              border: Border.all(color: Color(0xff83BB40)),
                                             borderRadius: BorderRadius.circular(20),      
                                           ),
                                      child: InkWell(      
                                        onTap: () => _changeAddr(pAddresses[index],index),
                                        child: Center(
                                          child: Text('${pAddresses[index].label}',
                                          style: TextStyle(color: this.selectedIndex == index ? Color(0xff83BB40) : Colors.white),
                                          ),
                                        )
                                        ),
                                    ),
                                  );
                             },
                             itemCount: pAddresses.length),
              ),                  
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
               InkWell(
                onTap: () => Navigator.of(context).pushNamed(AddPin.routeName,  arguments: {'mode' : 'add'}),              
                child: Column(
                  children: <Widget>[
                      Text('+ Add New', style: TextStyle(color: Colors.blue)),
                      Container(width: deviceSize.width * 0.18,
                      height: 1, color: Colors.blue)
                  ],
                )
              
              )   ,
              Container(width: deviceSize.width * 0.05)  
            ],
          ),
           Container(
                      height: deviceSize.height * 0.037,
                    ),
            Container(
               height: deviceSize.height * 0.27, 
              decoration: BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                       color: Color(0xff707070),
                        blurRadius: 5.0,
                            ),],
                          borderRadius: BorderRadius.circular(0) ,
                         color: Colors.white
                        ),
            child: Padding(
              padding: EdgeInsets.only(top : deviceSize.height * 0.03,left: deviceSize.width * 0.03),
              child: Column(
                children: <Widget>[ Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: deviceSize.width * 0.15,
                      child: Image.asset('lib/assets/images/mapicon.png', height: deviceSize.height * 0.03,)
                    ),
                    Container(
                      width: deviceSize.width * 0.75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                           Text('${dropAddr.name}', style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: deviceSize.height * 0.023
                        ),),
                        Container(
                          height: deviceSize.height * 0.01
                          ,),
                          Text('${dropAddr.address}', style: TextStyle(
                          color: Colors.black,
                          fontSize: deviceSize.height * 0.015
                        ),),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  height: deviceSize.height * 0.03,),
                Container(
                  width : deviceSize.width * 0.9,
                  height: deviceSize.height * 0.003,
                  color : Color(0xffD8D8D8)
                ),
                Padding(
                  padding: EdgeInsets.only(top : deviceSize.height * 0.02,left: deviceSize.width * 0.15),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Contact: ${dropAddr.phone}', style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: deviceSize.height * 0.02,
                            fontWeight: FontWeight.w500
                          ),),
                  ),
                ),
                ],),
            ),
            ),
      
            // Container(
            //   width: deviceSize.width,
            //   height: deviceSize.height * 0.2, 
            //   decoration: BoxDecoration(
            //           boxShadow: [
            //             new BoxShadow(
            //            color: Color(0xff707070),
            //             blurRadius: 5.0,
            //                 ),],
            //               borderRadius: BorderRadius.circular(0) ,
            //              color: Colors.white
            //             ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(20),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: <Widget>[
            //           Text('Personal Information', style: TextStyle(
            //             color: Colors.green,
            //             fontSize: deviceSize.height * 0.022
            //           ),),
            //            Container(
            //           height: deviceSize.height * 0.0005,
            //           width: deviceSize.width * 0.8,
                      
            //         ),
            //           Container(
            //          width:  deviceSize.width * 0.8,
            //           child: Text('${dropAddr.name}', style: TextStyle(
            //             color: Colors.black,
            //             fontSize: deviceSize.height * 0.02
            //           ),),
            //         ),
            //         Container(
            //           height: deviceSize.height * 0.0005,
            //           width: deviceSize.width * 0.8,
            //           color: Colors.black,
            //         ),
            //         Container(
            //          width:  deviceSize.width * 0.8,
            //           child: Text('${dropAddr.phone}', style: TextStyle(
            //             color: Colors.black,
            //             fontSize: deviceSize.height * 0.02
            //           ),),
            //         ),
            //         Container(
            //           height: deviceSize.height * 0.0005,
            //           width: deviceSize.width * 0.8,
            //           color: Colors.black,
            //         ),
            //         Container(
            //          width:  deviceSize.width * 0.8,
            //           child: person.altNo == null ? Text('N/A', style: TextStyle(
            //             color: Colors.black,
            //             fontSize: deviceSize.height * 0.02
            //           ),) : Text('${dropAddr.address}', style: TextStyle(
            //             color: Colors.black,
            //             fontSize: deviceSize.height * 0.02
            //           ),),
            //         ),
            //         Container(
            //           height: deviceSize.height * 0.0005,
            //           width: deviceSize.width * 0.8,
            //           color: Colors.black,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            
          //  Stack(
          //    children: <Widget>[
          //      Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //               mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: <Widget>[
              
          //     Container(           
          //     height: deviceSize.height * 0.15,
          //     width:  deviceSize.width * 0.9,
          //     decoration: BoxDecoration(
          //             boxShadow: [
          //               new BoxShadow(
          //              color: Colors.black,
          //               blurRadius: 5.0,
          //                   ),],
          //                 borderRadius: BorderRadius.circular(4) ,
          //                color: Colors.white
          //           ),
          //     child: Column(
                
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
                  
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: <Widget>[
          //             Container(
          //             width:  deviceSize.width * 0.6,
          //             child: Text('Delivery Address', style: TextStyle(
          //               color: Colors.green,
          //               fontSize: deviceSize.height * 0.023
          //             ),),
          //           ),
          //           ButtonTheme(
          //                   minWidth: 5.0,
          //                   height: 5.0,
          //               child: IconButton(
          //               icon:Icon(Icons.edit,),
          //               color: Colors.grey,
          //               iconSize: 20,             
          //               onPressed: editProfile,
          //                    ),
          //                   ),
          //           // ButtonTheme(
          //           //         minWidth: 5.0,
          //           //         height: 5.0,
          //           //     child: IconButton(
          //           //     icon:Icon(Icons.edit,),
          //           //     color: Colors.grey,
          //           //     iconSize: 6,             
          //           //     onPressed: editProfile,
          //           //      ),),
          //           ],
          //         ),
          //         // Container(
          //         //  width:  deviceSize.width * 0.8,
          //         //   child: Text('${person.deliveryAddress}', style: TextStyle(
          //         //     color: Colors.black,
          //         //     fontSize: deviceSize.height * 0.02
          //         //   ),),
          //         // ),
          //         // Container(
          //         //   height: deviceSize.height * 0.0005,
          //         //   width: deviceSize.width * 0.8,
          //         //   color: Colors.black,
          //         // ),
          //         // InkWell(                  
          //         //   child: Container(
          //         //     width:  deviceSize.width * 0.8,
          //         //     child: Column(
          //         //       crossAxisAlignment: CrossAxisAlignment.end,
          //         //       mainAxisAlignment: MainAxisAlignment.start,
          //         //       children: <Widget>[
          //         //         Text('View on Map ',
          //         //       textAlign: TextAlign.left,
          //         //       style: TextStyle(color: Colors.blue,
          //         //       ),
          //         //       ),
          //         //       Container(
          //         //         height: deviceSize.height * 0.001,
          //         //         width: deviceSize.width * 0.22,
          //         //         color: Colors.blue
          //         //       )
          //         //       ],
          //         //     ),
          //         //   ),
          //         //   onTap:  () => _selectOnMap(context, person.delLat, person.delLong)
          //         // )
          //       ],
          //     ),
          //     ),         
          //     ],
          //     ),
          //    ],
          //  ),
           Container(
                      height: deviceSize.height * 0.023,
                    ),
            ButtonTheme(
                minWidth: double.infinity,
                height: 50,
                child: RaisedButton(
                color: Color(0xff83BB40),
                 onPressed: () => goAhead(context), 
                // onPressed: () => addOrder(context,' ',' ',' ') , 
                child: Text("CONFIRM",
                style: TextStyle(color: Colors.white),),
                ),
              ),
          ],
        ),
      )
      
    );
  }
}
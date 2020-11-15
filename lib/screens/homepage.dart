import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:medical_shop/providers/addresses.dart';
import 'package:medical_shop/providers/banners.dart';
import 'package:medical_shop/screens/addPin.dart';
import 'package:medical_shop/screens/prescriptionOrder.dart';
import 'package:medical_shop/screens/splashScreen.dart';
import 'package:medical_shop/screens/uploadPrescription.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'itemOrder.dart';
import 'ImgOrder.dart';

import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();
  String _platformVersion = 'Unknown';
  bool isLocationPicked = true;
  bool popup = true;
  bool isInit = true;
  bool imagesLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      this._platformVersion = platformVersion;
    });
  }

  List<String> imgList = [];

  void selectPrescription(BuildContext ctx) {
    final addressProvider = Provider.of<AddressList>(context, listen: false);
    // if (isLocationPicked) {
    if (addressProvider.hasAddress) {
      Navigator.of(ctx).pushNamed(UploadPrescription.routeName);
    }
  }

  void selectRequirement(BuildContext ctx) {
    final addressProvider = Provider.of<AddressList>(context, listen: false);
    // if (isLocationPicked) {
    if (addressProvider.hasAddress) {
      Navigator.of(ctx).pushNamed(ItemOrder.routeName);
    }
  }

  int _current = 0;

  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final bannerData = Provider.of<BannerList>(context);
    print('In home');
    print(imagesLoaded);
    this.imagesLoaded = bannerData.imagesLoaded;

    this.imgList = bannerData.getBanners;

    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                child: Container(
                    width: deviceSize.width * 0.93,
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: Image.network(
                              item, fit: BoxFit.cover,
                              // frameBuilder: ,
                              frameBuilder: (BuildContext context, Widget child,
                                  int frame, bool wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) {
                                  return child;
                                }
                                return AnimatedOpacity(
                                  child: child,
                                  opacity: frame == null ? 0 : 1,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOut,
                                );
                              },
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return SplashScreen();
                                // Center(
                                //   child: CircularProgressIndicator(
                                //     value: loadingProgress.expectedTotalBytes != null
                                //         ? loadingProgress.cumulativeBytesLoaded /
                                //             loadingProgress.expectedTotalBytes
                                //         : null,
                                //   // child: SplashScreen(),
                                //   ),
                                //);
                              },
                            )),
                      ],
                    )),
              ),
            ))
        .toList();

    this.isLocationPicked
        ? addresscheck()
        : Future.delayed(Duration.zero, () => locationDialog(context));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: deviceSize.height * 0.055,
        ),
        Padding(
          padding: EdgeInsets.only(top: deviceSize.height * 0.07, bottom: 0),
          child: Container(
            height: deviceSize.height * 0.35,
            width: deviceSize.width * 0.93,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: <Widget>[
                imagesLoaded
                    ? CarouselSlider(
                        items: imageSliders,
                        options: CarouselOptions(
                            viewportFraction: 1.2,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 16 / 9,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                        carouselController: _controller,
                      )
                    : Container(
                        height: deviceSize.height * 0.28,
                        width: deviceSize.width * 0.93,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: SplashScreen()),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imgList.map((url) {
                      int index = imgList.indexOf(url);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Padding(padding: EdgeInsets.only(
        //   top:deviceSize.height * 0.017, bottom: deviceSize.height * 0.02),
        // child: Center(
        //   child: Container(
        //      height: deviceSize.height * 0.07,
        //     width: deviceSize.width * 0.8,
        //     decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(60),
        //       color: Color(0xff009CDC),
        //      ),

        //   child: InkWell(
        //     onTap:  () => selectPrescription(context),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         Icon(
        //         Icons.camera_alt,
        //          color: Colors.white,
        //          size: deviceSize.height * 0.033,
        //           ),
        //          Text(' Upload Your Prescription',
        //          style: TextStyle(fontSize: deviceSize.height * 0.025, color: Colors.white), )
        //       ],
        //     ),
        //   ),

        //   ),
        // ),
        // ),

        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Container(
            width: deviceSize.width * 0.97,
            height: deviceSize.height * 0.12,
            decoration: BoxDecoration(boxShadow: [
              new BoxShadow(
                color: Colors.grey,
                blurRadius: 3.0,
              ),
            ], borderRadius: BorderRadius.circular(4), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, 0, 0, deviceSize.height * 0.007),
                      child: Text(
                        'Order With Prescription',
                        style: TextStyle(
                          fontSize: deviceSize.height * 0.024,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
                    Text(
                      'Upload your prescription & relax,',
                      style: TextStyle(
                          color: Color(0xff707070), fontFamily: 'Roboto'),
                    ),
                    Text(
                      'we will do the rest',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontFamily: 'Roboto',
                      ),
                    )
                  ],
                ),
                Stack(
                  children: <Widget>[
                    Positioned(
                      left: deviceSize.width * 0.18,
                      bottom: deviceSize.height * 0.055,
                      child: Image.asset(
                        'lib/assets/images/medpres.png',
                        height: deviceSize.height * 0.06,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: deviceSize.height * 0.05,
                          left: deviceSize.width * 0.05),
                      child: ButtonTheme(
                        minWidth: deviceSize.width * 0.25,
                        height: deviceSize.height * 0.04,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Color(0xff83BB40),
                          onPressed: () => selectPrescription(context),
                          child: Text(
                            "UPLOAD",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(15, deviceSize.height * 0.02, 15, 0),
          child: Container(
            width: deviceSize.width * 0.97,
            height: deviceSize.height * 0.12,
            decoration: BoxDecoration(boxShadow: [
              new BoxShadow(
                color: Colors.grey,
                blurRadius: 3.0,
              ),
            ], borderRadius: BorderRadius.circular(4), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, 0, 0, deviceSize.height * 0.007),
                      child: Text(
                        'Add your medicines',
                        style: TextStyle(
                          fontSize: deviceSize.height * 0.024,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
                    Text(
                      'No prescription? still you',
                      style: TextStyle(
                        color: Color(0xff707070),
                      ),
                    ),
                    Text(
                      'can place your requirement',
                      style: TextStyle(
                        color: Color(0xff707070),
                      ),
                    )
                  ],
                ),
                Container(),
                Stack(
                  children: <Widget>[
                    Positioned(
                      left: deviceSize.width * 0.18,
                      bottom: deviceSize.height * 0.05,
                      child: Image.asset(
                        'lib/assets/images/tabpres.png',
                        height: deviceSize.height * 0.06,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: deviceSize.height * 0.05,
                          left: deviceSize.width * 0.05),
                      child: ButtonTheme(
                        minWidth: deviceSize.width * 0.25,
                        height: deviceSize.height * 0.04,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Color(0xff83BB40),
                          onPressed: () => selectRequirement(context),
                          child: Text(
                            "ADD",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Padding(padding: EdgeInsets.only(
        //   top:deviceSize.height * 0.02, bottom: deviceSize.height * 0.06),
        // child: Center(
        //   child: Container(
        //     height: deviceSize.height * 0.07,
        //     width: deviceSize.width * 0.8,
        //     decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(60),
        //       color: Color(0xff009CDC),
        //      ),
        //   child: InkWell(
        //     onTap: () => selectRequirement(context),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         Icon(
        //         Icons.edit,
        //          color: Colors.white,
        //          size: deviceSize.height * 0.033,
        //           ),
        //          Text('   Add Your Requirement',
        //          style: TextStyle(fontSize: deviceSize.height * 0.025, color: Colors.white), )
        //       ],
        //     ),
        //   ),
        //   ),
        // ),
        // ),

        Padding(
          padding: EdgeInsets.fromLTRB(0, deviceSize.height * 0.05, 0, 0),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              new BoxShadow(
                color: Colors.grey,
                blurRadius: 3.0,
              ),
            ], color: Colors.white),
            width: deviceSize.width,
            height: deviceSize.height * 0.09,
            child: Stack(
              children: <Widget>[
                Container(
                    width: deviceSize.width,
                    height: deviceSize.height * 0.09,
                    child: Image.asset(
                      'lib/assets/images/background.png',
                      fit: BoxFit.cover,
                    )),
                Container(
                  width: deviceSize.width * 0.1,
                  height: deviceSize.height * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(150),
                        bottomRight: Radius.circular(150)),
                    color: Color(0xff84bb40),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      deviceSize.width * 0.035,
                      deviceSize.width * 0.03,
                      deviceSize.width * 0.01,
                      deviceSize.width * 0.01),
                  child: Image.asset(
                    'lib/assets/images/headCall.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      deviceSize.width * 0.2,
                      deviceSize.width * 0.01,
                      deviceSize.width * 0.01,
                      deviceSize.width * 0.01),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Need Help?',
                        style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: deviceSize.height * 0.02,
                            fontWeight: FontWeight.w700),
                      ),
                      Container(
                        height: deviceSize.height * 0.005,
                      ),
                      Text(
                        'Contact our customer support',
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: deviceSize.height * 0.016,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      deviceSize.width * 0.75,
                      deviceSize.width * 0.03,
                      deviceSize.width * 0.01,
                      deviceSize.width * 0.01),
                  child: InkWell(
                      onTap: () => _makePhoneCall('tel:+917997123400'),
                      child: Image.asset(
                        'lib/assets/images/call.png',
                        fit: BoxFit.cover,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      deviceSize.width * 0.88,
                      deviceSize.width * 0.03,
                      deviceSize.width * 0.01,
                      deviceSize.width * 0.01),
                  child: InkWell(
                      onTap: () {
                        FlutterOpenWhatsapp.sendSingleMessage(
                            "+917997123400", "Hello");
                      },
                      child: Image.asset(
                        'lib/assets/images/whatsapp.png',
                        fit: BoxFit.cover,
                      )),
                )
              ],
            ),
          ),
        ),

        //   Center(
        //     child: Container(
        //       height: deviceSize.height * 0.2,
        //       width: double.infinity,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: <Widget>[
        //         Text('Need Help?', style: TextStyle(
        //           color: Colors.grey,
        //           fontSize: deviceSize.height * 0.018
        //         ),),
        //         Container(
        //           height: deviceSize.height * 0.015
        //         ),
        //         Row(
        //         mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
        //         children: <Widget>[
        //         Material(
        //           borderRadius: new BorderRadius.circular(8.0),
        //           elevation: 5.0,
        //           child: InkWell(
        //           child: Container(
        //           decoration: BoxDecoration(
        //           borderRadius: new BorderRadius.circular(8.0),
        //           color: Colors.white,
        //           ),
        //           height: deviceSize.height * 0.06,
        //           width: deviceSize.height * 0.18,
        //           child: Row(
        //             children: <Widget>[
        //               ClipRRect(
        //           borderRadius: BorderRadius.only(
        //             bottomLeft: Radius.circular(8),
        //             topLeft: Radius.circular(8),
        //           ),
        //                 child: Image.asset('lib/assets/images/chat.jpg', fit: BoxFit.cover,)
        //               ),
        //               Container(
        //                 child: Padding(
        //                   padding: const EdgeInsets.only(left: 10, top: 2),
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: <Widget>[
        //                       Text('Chat', style: TextStyle(
        //                         color: Colors.green,
        //                         fontSize: deviceSize.height * 0.023
        //                       ),),
        //                       Text('with us', style: TextStyle(
        //                         color: Colors.green,
        //                         fontSize: deviceSize.height * 0.021),),
        //                     ],
        //                   ),
        //                 )
        //               )
        //             ],
        //           ),
        //       ),
        //             onTap: (){
        //                  FlutterOpenWhatsapp.sendSingleMessage("+917997123400", "Hello");
        //                 },
        //           ),
        //         ),
        //         Material(
        //           borderRadius: new BorderRadius.circular(8.0),
        //           elevation: 5.0,
        //           child: InkWell(
        //           child: Container(
        //           decoration: BoxDecoration(
        //           borderRadius: new BorderRadius.circular(8.0),
        //           color: Colors.white,
        //           ),
        //           height: deviceSize.height * 0.06,
        //           width: deviceSize.height * 0.18,
        //           child: Row(
        //             children: <Widget>[
        //               ClipRRect(
        //           borderRadius: BorderRadius.only(
        //             bottomLeft: Radius.circular(8),
        //             topLeft: Radius.circular(8),
        //           ),
        //                 child: Image.asset('lib/assets/images/call.jpg', fit: BoxFit.cover,)
        //               ),
        //               Container(
        //                 child: Padding(
        //                   padding: const EdgeInsets.only(left: 10, top: 2),
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: <Widget>[
        //                       Text('Call', style: TextStyle(
        //                         color: Colors.green,
        //                         fontSize: deviceSize.height * 0.023
        //                       ),),
        //                       Text('to us', style: TextStyle(
        //                         color: Colors.green,
        //                         fontSize: deviceSize.height * 0.021),),
        //                     ],
        //                   ),
        //                 )
        //               )
        //             ],
        //           ),
        //       ),
        //             onTap: () => _makePhoneCall('tel:+917997123400'),
        //           ),
        //         ),
        //         ],
        //       ),
        //       ],
        //     ),
        //     ),
        //   ),
      ],
    );
  }

  Future<void> _getCurrentLocation() async {
    //  final locData = await Location().getLocation();
    //  final LatLng pos = LatLng(locData.latitude,locData.longitude);
    //  _pickedLocation = pos;
    //   setState(() {
    //      Marker(markerId: MarkerId('m1'), position: _pickedLocation);
    //     this.lat = _pickedLocation.latitude;
    //     this.lng = _pickedLocation.longitude;
    //     isLoading = false;
    //     isInit = false;
    //   });
    //   locationChanged = true;
    //   _getAddress();
    Navigator.of(context).pop(true);
    Navigator.of(context)
        .pushNamed(AddPin.routeName, arguments: {'mode': 'add'});
  }

  void dontAllow() {
    Navigator.of(context).pop(true);
    setState(() {
      isLocationPicked = false;
      popup = true;
    });
  }

  void addresscheck() async {
    final addressData = Provider.of<AddressList>(context, listen: false);
    setState(() {
      isLocationPicked = addressData.checkAddress();
    });
  }

  Future<void> locationDialog(BuildContext context) {
    if (popup) {
      popup = false;
      final deviceSize = MediaQuery.of(context).size;
      final addressData = Provider.of<AddressList>(context, listen: false);
      isLocationPicked = addressData.checkAddress();
      return isLocationPicked
          ? Container()
          : showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: Container(
                    width: deviceSize.width * 0.4,
                    child: Column(
                      children: <Widget>[
                        Text('SIRONA WOULD LIKE TO',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: deviceSize.height * 0.023)),
                        Text('ACCESS YOUR LOCATION',
                            style:
                                TextStyle(fontSize: deviceSize.height * 0.023)),
                      ],
                    ),
                  ),
                  content: Container(
                    width: deviceSize.width * 0.8,
                    height: deviceSize.height * 0.25,
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: deviceSize.height * 0.2,
                              width: deviceSize.width * 0.8,
                              child: Image.asset(
                                  'lib/assets/images/building.png',
                                  fit: BoxFit.cover),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  deviceSize.width * 0.3,
                                  deviceSize.height * 0.08,
                                  deviceSize.width * 0.1,
                                  0),
                              child: Container(
                                height: deviceSize.height * 0.06,
                                width: deviceSize.width * 0.1,
                                child: Image.asset(
                                    'lib/assets/images/location.png',
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Please allow location access to',
                          style: TextStyle(
                              fontSize: deviceSize.height * 0.015,
                              color: Color(0xff707070)),
                        ),
                        Text(
                          'check delivery service availabilty',
                          style: TextStyle(
                              fontSize: deviceSize.height * 0.015,
                              color: Color(0xff707070)),
                        ),
                      ],
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Dont Allow'),
                      onPressed: () => dontAllow(),
                    ),
                    FlatButton(
                        child: Text('Allow'),
                        onPressed: () => _getCurrentLocation()),
                  ],
                );
              });
    }
  }
}

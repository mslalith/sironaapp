import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medical_shop/models/address.dart';
import 'package:medical_shop/models/person.dart';
import 'package:medical_shop/providers/addresses.dart';
import 'package:medical_shop/providers/auth.dart';
import 'package:medical_shop/providers/banners.dart';
import 'package:medical_shop/providers/locations.dart';
import 'package:medical_shop/providers/offers.dart';
import 'package:medical_shop/providers/orders.dart';
import 'package:medical_shop/providers/profile.dart';
import 'package:medical_shop/providers/units.dart';
import 'package:medical_shop/screens/addPin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical_shop/screens/addProfile.dart';
import 'package:medical_shop/screens/notifications.dart';
import 'package:medical_shop/screens/profileDisplay.dart';
import 'package:medical_shop/screens/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'homepage.dart';
import 'orderListScreen.dart';
import 'profile.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/mainScreen';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  bool _isInit = true;
  bool accCheck = false;
  LatLng _pickedLocation;
  bool isInit = true;
  bool isLoading = true;
  double lat;
  double lng;
  bool isSelecting = true;
  String number;
  bool dataC = true;
  String token;
  int _selectedIndex = 0;
  var first;
  bool isLocationPicked = false;
  bool locationChanged = true;
  bool editFlag = false;
  String address = '';
  String address2 = '';

  final List<Map<String, Object>> _pages = [
    {'Icon': Icons.home, 'Page': HomePage(), 'Title': 'Home'},
    {'Icon': Icons.list, 'Page': OrderListScreen(), 'Title': 'My Orders'},
    {
      'Icon': Image.asset('lib/assets/images/logo.png'),
      'Page': NotificationPage(),
      'Title': 'Add Prescription'
    },
    {'Page': NotificationPage(), 'Title': 'Profile'},
    {'Page': DisplayProfile(), 'Title': 'Home'}
  ];
  void _onItemTapped(int index) {
    print(index);
    if (index != 3) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _getAddress() async {
    final coordinates =
        new Coordinates(_pickedLocation.latitude, _pickedLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;

    setState(() {
      address = '${first.addressLine}';
      address2 = '${first.postalCode}';
    });
    locationChanged = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();

    fbm.getToken().then((token) {
      print('printing token');
      print(token);
      createRecord(token);
    });

    fbm.configure(
      onMessage: (msg) {
        print(msg);
        return;
      },
      onLaunch: (msg) {
        print(msg);
        setState(() {
          _selectedIndex = 2;
        });
        return;
      },
      onResume: (msg) {
        print(msg);
        setState(() {
          _selectedIndex = 2;
        });
        return;
      },
    );
  }

  void createRecord(String token) async {
    final databaseReference = Firestore.instance;
    print('printing tokens');
    await databaseReference
        .collection("storage")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => {
            if (f.data['token'] == token)
              {print('matched')}
            else
              {addToken(token)}
          });
    });
  }

  void addToken(String token) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection("storage")
        .document()
        .setData({'token': token});
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final authData = Provider.of<Auth>(context);
      this.number = authData.number;
      this.token = authData.token;
      Provider.of<BannerList>(context).fetchBanners();
      Provider.of<OrderList>(context).fetchOrders(number);
      Provider.of<OrderList>(context).fetchItems(number);
      Provider.of<OrderList>(context).fetchImages(number);
      Provider.of<Profile>(context).getProfiles(number);
      Provider.of<UnitList>(context).fetchUnits();
      Provider.of<LocationList>(context).fetchLocations();
      Provider.of<OfferList>(context).fetchOffers();
      Provider.of<AddressList>(context).fetchAddress(number);
      setState(() {
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  void editProfile() {
    Navigator.of(context)
        .pushNamed(AddProfile.routeName, arguments: {'mode': 'edit'});
  }

  Future<void> locationDialog(BuildContext context) {
    final addressData = Provider.of<AddressList>(context, listen: false);
    isLocationPicked = addressData.checkAddress();
  }

  void showAlert(BuildContext context) async {
    final bool res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you wish to delete this item?"),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("DELETE")),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCEL"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final deviceSize = MediaQuery.of(context).size;
    var selectedIndex;

    Person person;
    final authData = Provider.of<Auth>(context);
    this.number = authData.number;
    this.token = authData.token;
    final profileData = Provider.of<Profile>(context);
    person = profileData.getProfile;

    String message = '';

    if (person != null) {
      message = person.name;
    }

    print(
        '============================$isLocationPicked============ tabscreen');
    this.isLocationPicked
        ? Container()
        : Future.delayed(Duration.zero, () => locationDialog(context));

    return Scaffold(
      backgroundColor: Color(0xffF2EFEF),
      body: _isInit
          ? SplashScreen()
          : Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: deviceSize.height * 0.35,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(150),
                        bottomRight: Radius.circular(150)),
                    color: Color(0xff84bb40),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: deviceSize.height * 0.04),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 22,
                        ),
                        Text(
                          "    Welcome $message",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: deviceSize.height * 0.023,
                          ),
                        ),
                        Container(
                          width: deviceSize.width * 0.25,
                        ),
                        Selector<AddressList, bool>(
                          selector: (_, provider) => provider.hasAddress,
                          builder: (_, hasAddress, child) {
                            return hasAddress
                                ? Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: deviceSize.height * 0.027,
                                  )
                                : Icon(
                                    Icons.warning,
                                    color: Colors.red,
                                    size: deviceSize.height * 0.027,
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Center(child: _pages.elementAt(_selectedIndex)['Page']),
                Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: deviceSize.height * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () => _onItemTapped(0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.home,
                                    color: _selectedIndex == 0
                                        ? Color(0xff83BB40)
                                        : Colors.grey,
                                    size: deviceSize.height * 0.04,
                                  ),
                                  Text(
                                    'Home',
                                    style: TextStyle(
                                        color: _selectedIndex == 0
                                            ? Color(0xff83BB40)
                                            : Colors.grey,
                                        fontSize: deviceSize.height * 0.013),
                                  ),
                                ],
                              ),
                            ),
                            // Column(
                            //    children: <Widget>[
                            //    IconButton(
                            //   icon: Icon(Icons.home, ),
                            //   color: _selectedIndex == 0 ? Color(0xff83BB40): Colors.grey,
                            //   iconSize: 25,
                            //   onPressed:() => _onItemTapped(0)
                            //    ),
                            //    ],
                            //    ),
                            //   Column(
                            //    children: <Widget>[
                            //    IconButton(
                            //   icon: Icon(Icons.list),
                            //   color: _selectedIndex == 1 ? Color(0xff83BB40): Colors.grey,
                            //   iconSize: 25,
                            //   onPressed: () => _onItemTapped(1)
                            //    ),
                            // //  Text('Home')
                            //    ],
                            //    ),

                            InkWell(
                              onTap: () => _onItemTapped(1),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.list,
                                    color: _selectedIndex == 1
                                        ? Color(0xff83BB40)
                                        : Colors.grey,
                                    size: deviceSize.height * 0.04,
                                  ),
                                  Text(
                                    'Orders',
                                    style: TextStyle(
                                        color: _selectedIndex == 1
                                            ? Color(0xff83BB40)
                                            : Colors.grey,
                                        fontSize: deviceSize.height * 0.013),
                                  ),
                                ],
                              ),
                            ),

                            Container(),
                            Container(),
                            Container(),

                            InkWell(
                              onTap: () => _onItemTapped(2),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.notifications,
                                    color: _selectedIndex == 2
                                        ? Color(0xff83BB40)
                                        : Colors.grey,
                                    size: deviceSize.height * 0.04,
                                  ),
                                  Text(
                                    'Notifications',
                                    style: TextStyle(
                                        color: _selectedIndex == 2
                                            ? Color(0xff83BB40)
                                            : Colors.grey,
                                        fontSize: deviceSize.height * 0.013),
                                  ),
                                ],
                              ),
                            ),

                            //    Column(
                            //    children: <Widget>[
                            //    IconButton(
                            //   icon: Icon(Icons.person),
                            //   color: _selectedIndex == 3 ? Color(0xff83BB40): Colors.grey,
                            //   iconSize: 25,
                            //   onPressed: () => _onItemTapped(3)
                            //    ),
                            //  //Text('Home')
                            //    ],
                            //    ),
                            InkWell(
                              onTap: () => _onItemTapped(4),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.person,
                                    color: _selectedIndex == 4
                                        ? Color(0xff83BB40)
                                        : Colors.grey,
                                    size: deviceSize.height * 0.04,
                                  ),
                                  Text(
                                    'Profile',
                                    style: TextStyle(
                                        color: _selectedIndex == 4
                                            ? Color(0xff83BB40)
                                            : Colors.grey,
                                        fontSize: deviceSize.height * 0.013),
                                  ),
                                ],
                              ),
                            ),
                            //   Column(
                            //    children: <Widget>[
                            //    IconButton(
                            //   icon: Icon(Icons.exit_to_app),
                            //   color: Colors.grey,
                            //   iconSize: 25,
                            //   onPressed: () => _onItemTapped(4)
                            //    ),
                            //  //Text('Home')
                            //    ],
                            //    ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Center(
                            child: Container(
                                height: deviceSize.height * 0.12,
                                width: deviceSize.height * 0.12,
                                child:
                                    Image.asset('lib/assets/images/logo.png')))
                      ]),
                ),
              ],
              overflow: Overflow.clip,
            ),
    );
  }

  void _accCheck() {
    setState(() {
      accCheck = true;
    });
  }
}

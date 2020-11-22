import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:medical_shop/models/address.dart';
import 'package:medical_shop/providers/addresses.dart';
import 'package:medical_shop/providers/auth.dart';
import 'package:medical_shop/providers/locations.dart';
import 'package:medical_shop/providers/profile.dart';
import 'package:medical_shop/screens/splashScreen.dart';
import 'package:provider/provider.dart';

class AddPin extends StatefulWidget {
  static const routeName = '/addPin';
  @override
  _AddPinState createState() => _AddPinState();
}

class _AddPinState extends State<AddPin> {
  LatLng _pickedLocation;
  bool isInit = true;
  bool isLoading = true;
  double lat;
  double lng;
  bool isSelecting = true;
  bool locationChanged = true;
  bool locationCheck = true;
  bool editFlag = false;
  PAddress mAddress;
  String address = ' ';
  String address2 = ' ';
  List<String> locations = [];
  String err =
      'Currently we are not operative in your area! Don\'t Worry, we will be coming soon';
  String err1 = '';
  final _labelController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _pinController = TextEditingController();
  var first;

  String mode;

  void editAddress() {
    print(address);
    final profileData = Provider.of<Profile>(context, listen: false);
    final person = profileData.getPerson;
    setState(() {
      _nameController.text = person.name;
      _phoneController.text = person.phone;
      _addressController.text = address;
      _pinController.text = first.postalCode;
      locationCheck = locations.contains(first.postalCode);
      editFlag = true;
    });
  }

  void setInitialAddr() {
    final LatLng pos = LatLng(this.mAddress.lat, this.mAddress.lng);

    setState(() {
      _labelController.text = this.mAddress.label;
      _phoneController.text = this.mAddress.phone;
      _addressController.text = this.mAddress.address;
      _nameController.text = this.mAddress.name;
      _pinController.text = this.mAddress.pincode;
      _pickedLocation = pos;
      editFlag = true;
      isInit = false;
      isLoading = false;
    });
  }

  void addAddress(BuildContext ctx) async {
    setState(() {
      locationCheck = locations.contains(_pinController.text.trim());
    });

    if (_labelController.text.length < 4) {
      setState(() {
        err1 = 'Please enter proper Label';
      });
    } else if (_phoneController.text.length != 10) {
      setState(() {
        err1 = 'Please enter Valid Phone number';
      });
    } else if (_addressController.text.length < 10) {
      setState(() {
        err1 = 'Please enter Valid Address';
      });
    } else {
      setState(() {
        err1 = '';
      });

      if (locationCheck) {
        var number = Provider.of<Auth>(ctx, listen: false).userId;
        final newAddress = PAddress(
            id: number,
            name: _nameController.text,
            phone: _phoneController.text,
            lat: _pickedLocation.latitude,
            lng: _pickedLocation.longitude,
            address: _addressController.text,
            label: _labelController.text,
            pincode: _pinController.text);

        final addressData = Provider.of<AddressList>(ctx, listen: false);
        if (mode == 'add') {
          final addrstatus = await addressData.putAddress(newAddress);
          Navigator.of(ctx).pop(true);
        } else if (mode == 'edit') {
          newAddress.addrid = mAddress.addrid;
          final addrstatus = await addressData.updAddress(newAddress);
          Navigator.of(ctx).pop(true);
        }
      }
    }
  }

  Future<void> _getAddress() async {
    if (!isLoading) {
      final coordinates =
          new Coordinates(_pickedLocation.latitude, _pickedLocation.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      first = addresses.first;

      setState(() {
        address = '${first.addressLine}';
        address2 = '${first.locality},${first.postalCode}';
      });
      locationChanged = false;
    }
  }

  Future<void> _getCurrentLocation() async {
    final locData = await Location().getLocation();
    print('Got location:=========================================== $locData');
    if (locData != null) {
      final LatLng pos = LatLng(locData.latitude, locData.longitude);
      _pickedLocation = pos;
      setState(() {
        Marker(markerId: MarkerId('m1'), position: _pickedLocation);
        lat = _pickedLocation.latitude;
        lng = _pickedLocation.longitude;
        isLoading = false;
        isInit = false;
        editFlag = false;
      });
      locationChanged = true;
    }
  }

  void _selectLocation(LatLng position) async {
    setState(() {
      _pickedLocation = position;
    });
    locationChanged = true;
  }

  void checkNext(BuildContext ctx) {
    setState(() {
      this.locationCheck = true;
      _pinController.text = '';
    });
    Navigator.of(ctx).pop(true);
  }

  void _setPin() {
    if (mode == 'add') {
      setState(() {
        editFlag = false;
      });
      _getCurrentLocation();
    } else if (mode == 'edit') {
      _getCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    print(routeArgs);

    this.mode = routeArgs['mode'];

    if (isInit && this.mode == 'edit') {
      mAddress = routeArgs['address'];
      setInitialAddr();
    }

    void noService(BuildContext ctx) async {
      final deviceSize = MediaQuery.of(context).size;
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              content: Container(
                width: deviceSize.width * 0.8,
                height: deviceSize.height * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: deviceSize.width * 0.8,
                      child: Center(
                        child: Text('We\' re Sorry!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: deviceSize.height * 0.02,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Container(
                      height: deviceSize.height * 0.03,
                    ),
                    Container(
                      height: deviceSize.height * 0.15,
                      width: deviceSize.width * 0.4,
                      child: Image.asset('lib/assets/images/noPIN.png',
                          fit: BoxFit.contain),
                    ),
                    Container(
                      height: deviceSize.height * 0.03,
                    ),
                    Container(
                      width: deviceSize.width * 0.8,
                      child: Center(
                        child: Text(
                            'Currently we are not operative in your area! \n Don\'t Worry, we will be coming soon.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: deviceSize.height * 0.015,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
              ),
              contentPadding: EdgeInsets.all(10),
              actions: <Widget>[
                FlatButton(
                  child: Text('Check Another PINCODE'),
                  onPressed: () => checkNext(context),
                ),
              ],
            );
          });
    }

    final profileData = Provider.of<LocationList>(context);
    locations = profileData.getLocations;
    if (isInit && this.mode == 'add') {
      _getCurrentLocation();
    }
    if (locationChanged) {
      _getAddress();
    }

    this.locationCheck
        ? Container()
        : Future.delayed(Duration.zero, () => noService(context));

    return Scaffold(
      backgroundColor: Color(0xffF2EFEF),
      appBar: AppBar(
          backgroundColor: Color(0xff83BB40),
          title: editFlag ? Text('Edit Address') : Text('Add Location PIN'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.location_searching),
                onPressed: () => editFlag ? _setPin() : _getCurrentLocation()),
          ],
          automaticallyImplyLeading: false),
      body: isLoading
          ? SplashScreen()
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  editFlag
                      ? Container(
                          color: Colors.white,
                          height: deviceSize.height * 0.72,
                          width: deviceSize.width * 0.95,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    deviceSize.width * 0.05,
                                    deviceSize.height * 0.02,
                                    deviceSize.width * 0.05,
                                    deviceSize.height * 0.02),
                                child: Container(
                                  child: TextField(
                                    enabled: mode == 'add' ? true : false,
                                    controller: _pinController,
                                    decoration: InputDecoration(
                                      labelText: 'PINCODE',
                                      counterText: "",
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    deviceSize.width * 0.05,
                                    deviceSize.height * 0.02,
                                    deviceSize.width * 0.05,
                                    deviceSize.height * 0.02),
                                child: Container(
                                  child: TextField(
                                    controller: _nameController,
                                    maxLength: 20,
                                    decoration: InputDecoration(
                                      labelText: 'Deliver to',
                                      counterText: "",
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    deviceSize.width * 0.05,
                                    deviceSize.height * 0.02,
                                    deviceSize.width * 0.05,
                                    deviceSize.height * 0.02),
                                child: Container(
                                  child: TextField(
                                    controller: _phoneController,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                      labelText: 'Phone',
                                      counterText: "",
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    deviceSize.width * 0.05,
                                    deviceSize.height * 0.02,
                                    deviceSize.width * 0.05,
                                    deviceSize.height * 0.02),
                                child: Container(
                                  child: TextField(
                                    controller: _addressController,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      labelText: 'Address',
                                      counterText: "",
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    deviceSize.width * 0.05,
                                    deviceSize.height * 0.02,
                                    deviceSize.width * 0.05,
                                    deviceSize.height * 0.02),
                                child: Container(
                                  width: deviceSize.width * 0.8,
                                  child: TextField(
                                    controller: _labelController,
                                    maxLength: 20,
                                    decoration: InputDecoration(
                                      labelText:
                                          'Label Eg: Home, Work, Other etc..',
                                      counterText: "",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: deviceSize.height * 0.72,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: deviceSize.height * 0.61,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xff83BB40),
                                      )),
                                  child: GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(lat, lng), zoom: 12),
                                    markers: {
                                      Marker(
                                          markerId: MarkerId('m1'),
                                          position: _pickedLocation),
                                    },
                                    onTap: isSelecting ? _selectLocation : null,
                                  )),
                              Container(
                                height: deviceSize.height * 0.03,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Color(0xff666666),
                                    size: deviceSize.height * 0.025,
                                  ),
                                  Container(
                                      width: deviceSize.width * 0.65,
                                      child: Text(
                                        '$address',
                                        style: TextStyle(
                                            color: Color(0xff666666),
                                            fontSize: deviceSize.height * 0.02),
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  InkWell(
                                      onTap: () => editAddress(),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.edit,
                                              color: Colors.red,
                                              size: deviceSize.height * 0.02),
                                          Text(
                                            ' Edit',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize:
                                                    deviceSize.height * 0.017),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                              Container(height: deviceSize.height * 0.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(width: deviceSize.width * 0.03),
                                  Container(
                                      width: deviceSize.width * 0.8,
                                      child: Text(
                                        '$address2',
                                        style: TextStyle(
                                            color: Color(0xff666666),
                                            fontSize: deviceSize.height * 0.02),
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                  Container(height: deviceSize.height * 0.07),
                  Container(
                    height: deviceSize.height * 0.03,
                    child: Center(
                      child: Text('$err1', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      color: Color(0xff83BB40),
                      onPressed: () => editFlag
                          ? locationCheck
                              ? addAddress(context)
                              : null
                          : editAddress(),
                      child: Text(
                        "CONFIRM",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

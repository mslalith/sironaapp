import 'package:flutter/material.dart';
import 'package:medical_shop/models/person.dart';
import 'package:medical_shop/providers/auth.dart';
import 'package:medical_shop/providers/profile.dart';
import 'package:provider/provider.dart';

import 'mapScreen.dart';

class AddProfile extends StatefulWidget {
  static const routeName = '/addProfile';
  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  Person person;
  String mode = 'add';
  String number;
  bool initLoad = true;
  bool isLoading = true;
  double hlat, hlng, dlat, dlng;
  bool val = false;
  String err = '';

  // Error Identifiers
  bool hlcheck = false;
  bool dlcheck = false;

  final _nameController = TextEditingController();
  final _phController = TextEditingController();
  final _emailController = TextEditingController();
  final _addrController = TextEditingController();
  final _delController = TextEditingController();
  final _coupController = TextEditingController();

  void saveProfile(BuildContext ctx) {
    print('here to update');
    if (_nameController.text.trim() == '' || _nameController.text.length < 3) {
      setState(() {
        this.err = 'Please fill Valid Name';
      });
      // }
      // else if (_emailController.text.trim() == '' ||
      //     !(_emailController.text.contains('@')) ||
      //     !(_emailController.text.contains('.com'))) {
      //   setState(() {
      //     this.err = 'Please fill Valid Email';
      //   });
    } else {
      setState(() {
        this.err = 'No error';
      });
    }

    final uData = Provider.of<Profile>(ctx, listen: false);
    String daddr;

    if (val) {
      this.dlat = this.hlat;
      this.dlng = this.hlng;
      daddr = this._addrController.text;
    } else {
      daddr = this._delController.text;
    }
    if (this.err == 'No error') {
      if (mode == 'edit') {
        final Person newPerson = Person(
            name: this.person.name,
            phone: this.number,
            email: this._emailController.text);
        uData.updProfile(newPerson);
        Navigator.of(context).pop();
      } else if (mode == 'add') {
        final Person newPerson = Person(
            name: _nameController.text,
            phone: number,
            email: _emailController.text,
            code: _coupController.text);
        uData.putProfile(newPerson);
        Navigator.of(ctx).pushReplacementNamed('/');
      }
    }
  }

  Future<void> _selectOnMap(BuildContext context, String str) async {
    print('selcting');

    final selectedLocation = await Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => MapScreen(
        isSelecting: true,
      ),
    ));
    print('went');

    if (selectedLocation == null) {
      return;
    }
    setState(() {
      if (str == 'home') {
        this.hlat = selectedLocation.latitude;
        this.hlng = selectedLocation.longitude;
      } else {
        this.dlat = selectedLocation.latitude;
        this.dlng = selectedLocation.longitude;
      }
      print(hlng);
    });
  }

  void onChecked(bool newValue) {
    print(newValue);
    setState(() {
      val = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    mode = 'add';
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;

    mode = routeArgs['mode'];

    if (mode == 'edit' && initLoad) {
      final uData = Provider.of<Profile>(context);
      final person = uData.getProfile;
      this.person = person;
      print('name: ${person.name}');
      initLoad = false;
      _nameController.text = person.name;
      _phController.text = Provider.of<Auth>(context, listen: false).number;
      //_alphController.text = person.altNo;
      _emailController.text = person.email;
      number = person.phone;
      isLoading = false;
    } else if (mode == 'add' && initLoad) {
      //  number = routeArgs['number'];
      number = Provider.of<Auth>(context, listen: false).number;
      _phController.text = number;
      isLoading = false;
    }

    return Scaffold(
      backgroundColor: Color(0xffF2EFEF),
      appBar: AppBar(
        title: mode == 'edit' ? Text('Edit Profile') : Text('Add Profile'),
        backgroundColor: Color(0xff83BB40),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: deviceSize.width,
                  // height: deviceSize.height * 0.4,
                  child: Container(
                    // height: deviceSize.height * 0.3,
                    decoration: BoxDecoration(
                        // boxShadow: [
                        //   new BoxShadow(
                        //     color: Color(0xff707070),
                        //     blurRadius: 5.0,
                        //   ),
                        // ],
                        // borderRadius: BorderRadius.circular(20) ,
                        color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              //  Container(
                              //    width: deviceSize.width * 0.3,
                              //    child: Text('Name',
                              //    style: TextStyle(
                              //      fontSize: deviceSize.height * 0.023,
                              //     color: Colors.green
                              //    ),),
                              //  ),
                              //                    Text('${person.phone}',
                              //   Text('Sample',
                              //  style: TextStyle(
                              //    fontSize: 16,
                              //   color: Colors.black
                              //  ),),
                              Flexible(
                                  child: TextField(
                                decoration:
                                    InputDecoration(labelText: 'Name'),
                                controller: _nameController,
                              ))
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              //  Container(
                              //    width: deviceSize.width * 0.3,
                              //    child: Text('Phone',
                              //    style: TextStyle(
                              //      fontSize: deviceSize.height * 0.023,
                              //     color: Colors.green
                              //    ),),
                              //  ),
                              //      Text('${person.phone}',
                              Flexible(
                                  child: TextField(
                                enabled: false,
                                decoration:
                                    InputDecoration(labelText: 'Phone'),
                                controller: _phController,
                              ))
                            ],
                          ),
                        ),

                        //  Padding(
                        //        padding: const EdgeInsets.fromLTRB(20,0,20,5 ),
                        //        child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //          children: <Widget>[
                        //            Container(
                        //               width: deviceSize.width * 0.3,
                        //              child: Text('Alternate No.',
                        //              style: TextStyle(
                        //                fontSize: deviceSize.height * 0.023 ,
                        //               color: Colors.green
                        //              ),),
                        //            ),
                        //           //  Container(
                        //           //    width: deviceSize.width * 0.121,
                        //           //  ),
                        //   //         Text('${person.phone}',
                        //             Flexible(child: TextField(
                        //               maxLength: 10,
                        //               keyboardType: TextInputType.number,
                        //               decoration: InputDecoration(
                        //                 counterText: "",
                        //               ),
                        //             controller: _alphController,
                        //           ))
                        //          ],
                        //        ),
                        //      ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              //  Container(
                              //    width: deviceSize.width * 0.3,
                              //    child: Text('Email ID',

                              //    style: TextStyle(
                              //      fontSize: deviceSize.height * 0.023,
                              //     color: Colors.green
                              //    ),),
                              //  ),

                              //     Text('${person.phone}',
                              Flexible(
                                  child: TextField(
                                      decoration: InputDecoration(
                                          labelText: 'Email'),
                                      controller: _emailController))
                            ],
                          ),
                        ),
                        Container(height: deviceSize.height * 0.02)
                      ],
                    ),
                  ),
                ),
              ),

              // Container(height: deviceSize.height * 0.03,),
              // // Home Address
              //     Stack(
              //     children: <Widget>[
              //       Container(
              //       height: deviceSize.height * 0.25,
              //       width:  deviceSize.width ,
              //       decoration: BoxDecoration(
              //               boxShadow: [
              //                 new BoxShadow(
              //                 color: Color(0xff707070),
              //                 blurRadius: 2.0,
              //                     ),],
              //              //     borderRadius: BorderRadius.circular(20) ,
              //                  color: Colors.white
              //             ),
              //       child: Column(

              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: <Widget>[
              //           // Container(
              //           //   width:  deviceSize.width * 0.8,
              //           //   child: Text('Home Address', style: TextStyle(
              //           //     color: Colors.green,
              //           //     fontSize: deviceSize.height * 0.023
              //           //   ),),
              //           // ),
              //           Container(
              //            width:  deviceSize.width * 0.9,
              //             child: TextField(
              //               maxLines: 4,
              //               decoration: InputDecoration(

              //                 labelText: 'Home Address'
              //               ),
              //               controller: _addrController
              //             )
              //           ),
              //         //  Container(height: deviceSize.height * 0.007),
              //           InkWell(
              //             child: Container(
              //               width:  deviceSize.width * 0.9,
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.end,
              //                 mainAxisAlignment: MainAxisAlignment.start,
              //                 children: <Widget>[
              //                   Text('Select on Map ',
              //                 textAlign: TextAlign.left,
              //                 style: TextStyle(color: Colors.blue,
              //                 ),
              //                 ),
              //                 Container(
              //                   height: deviceSize.height * 0.001,
              //                   width: deviceSize.width * 0.22,
              //                   color: Colors.blue
              //                 )
              //                 ],
              //               ),
              //             ),
              //             onTap: () => _selectOnMap(context, 'home')
              //           )
              //         ],
              //       ),
              //     ),
              //     ],

              //     ),

              // Delivery Address
              // Container(
              //      height: deviceSize.height * 0.03,
              //     ),

              // Row(
              //   children: <Widget>[
              //     Checkbox(
              //     value: val, onChanged: onChecked),
              //     Text('Both Address are Same', style: TextStyle(

              //       fontSize: deviceSize.height * 0.02
              //     ),)
              //   ],
              // ),

              //     Stack(
              //     children: <Widget>[
              //       Container(
              //       height: deviceSize.height * 0.15,
              //       width:  deviceSize.width * 0.9,
              //       decoration: BoxDecoration(
              //               boxShadow: [
              //                 new BoxShadow(
              //                color: Colors.black,
              //                 blurRadius: 5.0,
              //                     ),],
              //                   borderRadius: BorderRadius.circular(20) ,
              //                  color: Colors.white
              //             ),
              //       child: Column(

              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: <Widget>[
              //           Container(
              //             width:  deviceSize.width * 0.8,
              //             child: Text('Delivery Address', style: TextStyle(
              //               color: Colors.green,
              //               fontSize: deviceSize.height * 0.023
              //             ),),
              //           ),
              //           Container(
              //            width:  deviceSize.width * 0.8,
              //             child: TextField(
              //               controller: val ? _addrController : _delController
              //             )
              //           ),
              //           InkWell(
              //             child: Container(
              //               width:  deviceSize.width * 0.8,
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.end,
              //                 mainAxisAlignment: MainAxisAlignment.start,
              //                 children: <Widget>[
              //                   Text('Select on Map ',
              //                 textAlign: TextAlign.left,
              //                 style: TextStyle(color: Colors.blue,
              //                 ),
              //                 ),
              //                 Container(
              //                   height: deviceSize.height * 0.001,
              //                   width: deviceSize.width * 0.22,
              //                   color: Colors.blue
              //                 )
              //                 ],
              //               ),
              //             ),
              //             onTap: () => _selectOnMap(context, 'nh')
              //           ),
              //         ],
              //       ),
              //     ),
              //     ],

              //     ),

              Container(height: deviceSize.height * 0.07),
              Spacer(),

              mode == "edit"
                  ? Container(height: deviceSize.height * 0.14)
                  : Padding(
                      padding: EdgeInsets.only(
                        left: deviceSize.width * 0.03,
                        right: deviceSize.width * 0.03,
                      ),
                      child: Container(
                        decoration: new BoxDecoration(
                          color: Color(0xff91c9b8),
                          borderRadius: new BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        height: deviceSize.height * 0.14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: deviceSize.width * 0.03,
                                top: deviceSize.height * 0.01,
                                bottom: deviceSize.height * 0.01,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(width: deviceSize.width * 0.02),
                                  Icon(
                                    Icons.supervised_user_circle,
                                    color: Colors.white,
                                  ),
                                  Container(width: deviceSize.width * 0.03),
                                  Text(
                                    'Got any Referral Code?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: deviceSize.height * 0.025,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: deviceSize.width * 0.05,
                                bottom: deviceSize.height * 0.01,
                                right: deviceSize.width * 0.05,
                              ),
                              child: Container(
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                // height: deviceSize.height * 0.,
                                child: TextField(
                                  maxLength: 8,
                                  decoration: new InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.all(
                                      deviceSize.height * 0.01,
                                    ),
                                    hintText: 'ENTER THE CODE',
                                  ),
                                  controller: _coupController,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

              Container(height: deviceSize.height * 0.195),

              Text(
                '$err',
                style: TextStyle(color: Colors.red),
              ),

              ButtonTheme(
                minWidth: double.infinity,
                height: 50,
                child: RaisedButton(
                  color: Color(0xff83BB40),
                  onPressed: () => saveProfile(context),
                  child: Text(
                    "CONFIRM",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: deviceSize.height * 0.023,
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}

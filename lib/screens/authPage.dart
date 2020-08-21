import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_shop/providers/auth.dart';
import 'package:medical_shop/providers/profile.dart';
import 'package:medical_shop/screens/addProfile.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:medical_shop/screens/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sms_receiver/sms_receiver.dart';
import 'package:http/http.dart' as http;

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  static const BACKURL =
      'http://Sirona-env.eba-zb3yegkm.ap-south-1.elasticbeanstalk.com';
  String err = '';
  String phoneNo;
  String smsOTP;
  String _otp;
  String verificationId;
  String errorMessage = '';
  String err1 = '';
  String signCode;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isPressed = false;
  bool smsSent = false;

  var _isLoading = false;
  final _idController = TextEditingController();
  final _otpController1 = TextEditingController();
  final _otpController2 = TextEditingController();
  final _otpController3 = TextEditingController();
  final _otpController4 = TextEditingController();
  final _otpController5 = TextEditingController();
  final _otpController6 = TextEditingController();
  String _textContent = 'Waiting for messages...';
  SmsReceiver _smsReceiver;

  @override
  void initState() {
    super.initState();
  }

  void smsReceived(String str) {
    setState(() {
      this.smsOTP = str;
    });
  }

  void onSmsReceived(String message) {
    setState(() {
      _textContent = message;
      print('here1');
      print(_textContent);
      if (_textContent.contains('Sirona - On-Demand Hyper')) {
        this.smsOTP = _textContent.substring(0, 6);
      }
    });
  }

  void generateOTP() {
    const _minOtpValue = 100000;
    const _maxOtpValue = 999999;
    _otp = (_minOtpValue + Random().nextInt(_maxOtpValue - _minOtpValue))
        .toString();
  }

  void onTimeout() {
    setState(() {
      _textContent = "Timeout!!!";
    });
  }

  void _startListening() {
    // _smsReceiver.startListening();
    setState(() {
      _textContent = "Waiting for messages...";
    });
  }

  Future<bool> locDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Your Location'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Dont Allow'),
                onPressed: null,
              ),
              FlatButton(
                child: Text('Allow'),
                onPressed: null,
              ),
            ],
          );
        });
  }

// Future _autoCheck(BuildContext ctx) async {
// await SmsAutoFill().listenForCode;
// PinFieldAutoFill(
//                 decoration: BoxLooseDecoration(),
//                 currentCode: this.smsOTP ,
//                 onCodeSubmitted: //code submitted callback
//                 onCodeChanged: //code changed callback
//                 codeLength: //code length, default 6
//   )
// }

  Future _toCheck(BuildContext ctx) async {
    if (this._idController.text.length == 10) {
      setState(() {
        _isLoading = true;
      });

      print('about to send code');

      print('about to check profile');

      final result = await Provider.of<Profile>(context, listen: false)
          .getProfiles((_idController.text));

      if (result) {
        Provider.of<Auth>(context, listen: false)
            .setTken('exy', this._idController.text);

        print('user present');
      } else {
        Navigator.of(ctx).pushReplacementNamed(AddProfile.routeName,
            arguments: {'mode': 'add', 'number': ' '});
        Provider.of<Auth>(context, listen: false)
            .setTken('exy', this._idController.text);
        print('user not present');
      }
    } else {
      setState(() {
        this.err = 'Please enter 10 Digits';
      });
    }
  }

  Future<void> verifyPhone(BuildContext ctx) async {
    _listenOtp();
    _smsReceiver = SmsReceiver(onSmsReceived, onTimeout: onTimeout);
    _startListening(); 
    setState(() {
      this.smsSent = true;
      this.smsOTP = '';
    });
    this.phoneNo = _idController.text;
    signCode = await SmsAutoFill().getAppSignature;
    print(signCode);
    final PhoneCodeSent smsOTPSent =
        (String verId, [int forceCodeResend]) async {
      this.verificationId = verId;
      signCode = await SmsAutoFill().getAppSignature;
      print(signCode);
      setState(() {
        this.isPressed = true;
        this.err = '';
      });
    };
    try {
      final url = '$BACKURL/api/message/sendOTP';
      generateOTP();
      if (this.phoneNo.length > 10) {
        setState(() {
          this.isPressed = false;
          this.smsSent = false;
          this.err = 'Number too long';
        });
      } else if (this.phoneNo.length < 10) {
        this.isPressed = false;
        this.smsSent = false;
        this.err = 'Number too Short';
      } else {
        setState(() {
          this.isPressed = true;
          this.err = '';
        });
        final response = await http.post(url,
            headers: {"Content-Type": "application/json"},
            body: json.encode({
              'Message': _otp +
                  ' is Your verfication code for Sirona - On-Demand Hyper Local Pharmacy App - ' + signCode,
              'Number': _idController.text,
              'Subject': 'SIRONA'
            }));
        print(response.body);
        if (response.body.contains('error')) {
          setState(() {
            this.isPressed = false;
            this.smsSent = false;
            this.err = 'Connectivity error';
          });
        }
      }

      // await _auth.verifyPhoneNumber(
      //     phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
      //     codeAutoRetrievalTimeout: (String verId) {
      //       //Starts the phone number verification process for the given phone number.
      //       //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
      //       this.verificationId = verId;
      //     },
      //     codeSent:
      //         smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
      //     timeout: const Duration(seconds: 20),
      //     verificationCompleted: (AuthCredential phoneAuthCredential) {
      //       setState(() {
      //         err = '';
      //       });
      //       print(phoneAuthCredential);
      //     },
      //     verificationFailed: (AuthException exceptio) {
      //       if (exceptio.message.contains('TOO_LONG')) {
      //         setState(() {
      //           err = 'Number Too Long';
      //           this.smsSent = false;
      //         });
      //       } else if (exceptio.message.contains('TOO_SHORT')) {
      //         setState(() {
      //           err = 'Number Too Short';
      //           this.smsSent = false;
      //         });
      //       }
      //     });
    } catch (e) {
      // handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(child: Text('Done'), onPressed: () => signIn(context)

                  // () {
                  //   _auth.currentUser().then((user) {
                  //     if (user != null) {
                  //       print('user is not null');
                  //       print(user);
                  //       Navigator.of(context).pop();
                  //
                  //    Navigator.of(context).pushReplacementNamed      (SignUpScreen.routeName, arguments: {'mode' : 'edit'});
                  //     } else {
                  //       print('user is null');
                  //       signIn();
                  //     }
                  //   });
                  // },
                  )
            ],
          );
        });
  }

  signIn(BuildContext context) async {
    // this.smsOTP = _otpController1.text +
    //               _otpController2.text +
    //               _otpController3.text +
    //               _otpController4.text +
    //               _otpController5.text +
    //               _otpController6.text
    //               ;
    print(this.smsOTP);
    print(this._otp);
    if (this.smsOTP == this._otp) {
      _toCheck(context);
    } else {
      setState(() {
        err = 'Invalid Code';
      });
    }
    //   try {
    //     final AuthCredential credential = PhoneAuthProvider.getCredential(
    //       verificationId: verificationId,
    //       smsCode: smsOTP,
    //     );
    //     final FirebaseUser user =
    //         (await _auth.signInWithCredential(credential)).user;
    //     final FirebaseUser currentUser = await _auth.currentUser();
    //     assert(user.uid == currentUser.uid);
    //     final tkn = user.getIdToken();
    //     print(tkn.toString());
    //     // Navigator.of(context).pop();
    //     _toCheck(context);
    //   } catch (e) {
    //     handleError(e);
    //   }
    // }

    // handleError(PlatformException error) {
    //   print(error);
    //   switch (error.code) {
    //     case 'ERROR_INVALID_VERIFICATION_CODE':
    //       FocusScope.of(context).requestFocus(new FocusNode());
    //       setState(() {
    //         err = 'Invalid Code';
    //       });
    //       // Navigator.of(context).pop();
    //       // smsOTPDialog(context).then((value) {
    //       //   print('sign in');
    //       // })
    //       // ;
    //       break;
    //     default:
    //       setState(() {
    //         errorMessage = error.message;
    //       });

    //       break;
    //   }
  }

  Widget idWidget() {
    final deviceSize = MediaQuery.of(context).size;
    double wid = deviceSize.width * 0.1;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: deviceSize.height * 0.55,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(wid, 10, wid, 0),
            child: Container(
              height: deviceSize.height * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Enter your phone number to login',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: deviceSize.height * 0.023,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '+91   ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: deviceSize.height * 0.023,
                          ),
                        ),
                        Container(
                          height: deviceSize.height * 0.2,
                        ),
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
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            controller: _idController,
                            style: TextStyle(
                              fontSize: deviceSize.height * 0.025,
                              letterSpacing: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  (err != ''
                      ? Text(
                          err,
                          style: TextStyle(color: Colors.red),
                        )
                      : Container()),
                  Container(
                    child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 50,
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: () => smsSent ? null : verifyPhone(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          smsSent ? "Processing" : "PROCEED",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(height: deviceSize.height * 0.03),
                  Center(
                    child: Text(
                      'By Continuing, you agree to our',
                      style: TextStyle(fontSize: deviceSize.height * 0.02),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                            child: Text("Terms & Conditions",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                    fontSize: deviceSize.height * 0.02)),
                            onTap: () {
                              launch(
                                  'http://www.sironapharmacy.in/termsandconditions');
                            }),
                        Text(' and '),
                        GestureDetector(
                            child: Text("Privacy Policy",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                    fontSize: deviceSize.height * 0.02)),
                            onTap: () {
                              launch(
                                  'http://www.sironapharmacy.in/privacypolicy');
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _listenOtp() async {
    await SmsAutoFill().listenForCode;
  }

  Widget otpWidget2() {
    final deviceSize = MediaQuery.of(context).size;
    double wid = deviceSize.width * 0.1;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: deviceSize.height * 0.55,
          ),
          Text(
            'Enter OTP code sent to your number',
            style: TextStyle(
              color: Colors.grey,
              fontSize: deviceSize.height * 0.022,
            ),
          ),
          Container(
            height: deviceSize.height * 0.03,
          ),
          Container(
              width: deviceSize.width * 0.9,
              child: PinFieldAutoFill(
                decoration: BoxLooseDecoration(
                    strokeColor: Color(0xffF2EFEF), enteredColor: Colors.blue),
                codeLength: 6,
                currentCode: this.smsOTP,
                onCodeChanged: (val) {
                  this.smsOTP = val;
                },
              )),
          Container(
            height: deviceSize.height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                onTap: () => verifyPhone(context),
                child: Text(
                  'Resend OTP   ',
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
          Container(
            height: deviceSize.height * 0.05,
          ),
          Container(
            height: deviceSize.height * 0.05,
          ),
          Container(
            child: ButtonTheme(
              minWidth: deviceSize.width * 0.7,
              height: 50,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () => signIn(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "CONFIRM",
                  style: TextStyle(
                      color: Colors.white, fontSize: deviceSize.height * 0.024),
                ),
              ),
            ),
          ),
          Container(
            height: deviceSize.height * 0.07,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Not you? '),
              InkWell(
                onTap: () {
                  setState(() {
                    this.err = '';
                    this.isPressed = false;
                    this.smsSent = false;
                  });
                },
                child: Text(
                  'Log In as different user',
                  style: TextStyle(color: Color(0xff83BB40)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget otpWidget() {
    final deviceSize = MediaQuery.of(context).size;
    double wid = deviceSize.width * 0.1;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: deviceSize.height * 0.55,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(wid, 10, wid, 0),
            child: Container(
              height: deviceSize.height * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Enter OTP code sent to your number',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: deviceSize.height * 0.022,
                    ),
                  ),
                  Container(
                    height: deviceSize.height * 0.05,
                  ),
                  Container(
                    width: deviceSize.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            height: deviceSize.height * 0.07,
                            width: deviceSize.width * 0.1,
                            color: Color(0xffF2EFEF),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              onChanged: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: InputDecoration(
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              controller: _otpController1,
                              style: TextStyle(
                                fontSize: deviceSize.height * 0.025,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            height: deviceSize.height * 0.07,
                            width: deviceSize.width * 0.1,
                            color: Color(0xffF2EFEF),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              onChanged: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: InputDecoration(
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              controller: _otpController2,
                              style: TextStyle(
                                fontSize: deviceSize.height * 0.025,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            height: deviceSize.height * 0.07,
                            width: deviceSize.width * 0.1,
                            color: Color(0xffF2EFEF),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              onChanged: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: InputDecoration(
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              controller: _otpController3,
                              style: TextStyle(
                                fontSize: deviceSize.height * 0.025,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            height: deviceSize.height * 0.07,
                            width: deviceSize.width * 0.1,
                            color: Color(0xffF2EFEF),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              onChanged: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: InputDecoration(
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              controller: _otpController4,
                              style: TextStyle(
                                fontSize: deviceSize.height * 0.025,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            height: deviceSize.height * 0.07,
                            width: deviceSize.width * 0.1,
                            color: Color(0xffF2EFEF),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              onChanged: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: InputDecoration(
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              controller: _otpController5,
                              style: TextStyle(
                                fontSize: deviceSize.height * 0.025,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            height: deviceSize.height * 0.07,
                            width: deviceSize.width * 0.1,
                            color: Color(0xffF2EFEF),
                            child: TextField(
                              decoration: InputDecoration(
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              controller: _otpController6,
                              style: TextStyle(
                                fontSize: deviceSize.height * 0.025,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  (err != ''
                      ? Text(
                          err,
                          style: TextStyle(color: Colors.red),
                        )
                      : Container()),
                  Container(
                    height: deviceSize.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap: () => verifyPhone(context),
                        child: Text(
                          'Resend OTP   ',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: deviceSize.height * 0.05,
                  ),

                  Container(
                    child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 50,
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: () => signIn(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "CONFIRM",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: deviceSize.height * 0.024),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: deviceSize.height * 0.07,
                  ),
                  // Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  //           children: <Widget>[
                  //             Text('Not you? '),
                  //               InkWell(
                  //                 onTap: () {
                  //                   setState(() {
                  //                     this.err = '';
                  //                     this.isPressed =  false;
                  //                   });
                  //                 },
                  // child: Text('Log In as different user'
                  //               ,style: TextStyle(
                  //                 color: Color(0xff83BB40)
                  //               ),)
                  //               ,)
                  //           ],
                  //         ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return _isLoading
        ? SplashScreen()
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: new Stack(
                children: <Widget>[
                  Container(
                    height: deviceSize.height,
                    width: deviceSize.width,
                    child: Image.asset(
                      'lib/assets/images/mainScreen.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          this.isPressed ? otpWidget2() : idWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_shop/providers/auth.dart';
import 'package:medical_shop/screens/otpPage.dart';
import 'package:medical_shop/screens/signUpScreen.dart';
import 'package:medical_shop/screens/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '\signin';
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var _isLoading = false;
  var init = true;
  var userst = true;
  final _passwordController = TextEditingController();
  String err = ' ';
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  String err1 = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> verifyPhone(BuildContext context) async {
  this.phoneNo = '+91' + Provider.of<Auth>(context,listen: false).number;
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            setState(() {
             err1 = '';
            });
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
            if(exceptio.message.contains('TOO_LONG')){
                setState(() {
          err1 = 'Number Too Long';
        });
            }else if (exceptio.message.contains('TOO_SHORT')){
              setState(() {
            err1 = 'Number Too Short';
        });
            }
            
          });
    } catch (e) {
      handleError(e);
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
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: signIn
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName, arguments: {'mode' : 'edit'});
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          err = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }


Future _submit(BuildContext ctx) async {

if(this._passwordController.text.length == 4) {
setState(() {
  this._isLoading = true;
  this.err = '';
});
//final result = await Provider.of<Auth>(context,listen: false).signIn( _passwordController.text , ctx);
// if(result){
//   print('result came');
//  // Navigator.of(ctx).popUntil(ModalRoute.withName('/'));
//  Navigator.of(ctx).pushReplacementNamed('/');
// } else {
//   this.err = 'Incorrect PIN';
//   this._isLoading = false; 
// }} else {
//   setState(() {
//     this._isLoading = false; 
//       this.err = 'Please enter 4 digit PIN';
//     });
}
print('result settled');
}

void _toSignup(BuildContext ctx) {
  Navigator.of(ctx).pushReplacementNamed(SignUpScreen.routeName);
}  

  @override
  Widget build(BuildContext context) {
final deviceSize = MediaQuery.of(context).size;   
double wid = deviceSize.width * 0.3;


  final authData = Provider.of<Auth>(context);
  userst = authData.isUser;


    return _isLoading ? SplashScreen()
    : Scaffold(
        backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container( 
             height: deviceSize.height,
              width: deviceSize.width,
              child: Image.asset('lib/assets/images/mainScreen.png',
              fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height:  deviceSize.height * 0.54,
                  ),
                  Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                height: deviceSize.height * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[               
                        Text('Enter your 4 digit PIN',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: deviceSize.height * 0.023,
                        ),),
                        Padding(
                          padding: EdgeInsets.fromLTRB(wid, 10, wid, 20),
                          child: Row(
                            children:<Widget>[
                              Flexible(
                                child: TextField(
                                  obscureText: true,
                                  maxLength: 4,
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
                                controller: _passwordController,
                                style: TextStyle(
                                  fontSize: deviceSize.height * 0.025,
                                  letterSpacing: 18,
                                ),
                                ),),
                                ],
                          ),
                        ),
                        Text('$err', style: TextStyle(
                          color: Colors.red,
                          fontSize: deviceSize.height * 0.016,
                        ),),
                        Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: ButtonTheme(
                              minWidth: deviceSize.width * 0.5,
                              child: _isLoading ? 
                                RaisedButton(                    
                                child: Text('Logging In'),
                                onPressed: ()        {},
                                shape: 
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context).primaryTextTheme.button.color,
                                )
                                : Column(
                                  children: <Widget>[
                              ButtonTheme(
                    minWidth: deviceSize.width * 0.8,
                   height: 50,
                   child: RaisedButton(
                   color: Colors.blue,
                   onPressed: () => _submit(context), 
                       shape: 
                      RoundedRectangleBorder(                     
                        borderRadius: BorderRadius.circular(30),
                      ),
                  child: Text("LOGIN",
                  style: TextStyle(color: Colors.white),),
                   ),
                  ),
                  Container(
                    height: deviceSize.height * 0.02,
                  ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                    InkWell(
                                      onTap: ()=> verifyPhone(context),
                                      child: Text('Forgot Password?'
                                    ,style: TextStyle(
                                      color: Colors.blue
                                    ),)
                                    ,)
                                ],
                              ),
                                  ],                             
                                ),
                            ),
                          ),                    
                        ],
                        ),
                    
                      ],
                    ),
                  ),
                ),
                 Container(
                          height: deviceSize.height * 0.1,
                        ),
                ],               
              ),
            )
          ],
        ),
      ),
    );
  }
}
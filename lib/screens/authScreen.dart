import 'package:flutter/material.dart';
import 'package:medical_shop/providers/profile.dart';
import 'package:medical_shop/screens/signInScreen.dart';
import 'package:medical_shop/screens/signUpScreen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';


enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
    
    body: SingleChildScrollView(
      child: new Stack(
        children: <Widget>[         
          Container( 
           height: deviceSize.height,
            width: deviceSize.width,
            child: Image.asset('lib/assets/images/mainScreen.png',
            fit: BoxFit.cover,
            ),
          ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                   AuthCard(),
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

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);


  @override
  _AuthCardState createState() => _AuthCardState();
}



class _AuthCardState extends State<AuthCard> {
   
  String err = '';

 final GlobalKey<FormState> _formKey = GlobalKey(); 

  var _isLoading = false;
  final _idController = TextEditingController();

Future _toCheck(BuildContext ctx) async {

 
if(this._idController.text.length == 10) {
   setState(() {
    _isLoading = true;
  });
   final result = await Provider.of<Auth>(context, listen: false).checkUser(this._idController.text);

    if(result) {
      Provider.of<Profile>(context,listen: false).getProfiles((_idController.text));
      Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
      print('user present');
    } else {
      Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName);
      print('user not present');
    }   
} else {
  setState(() {
      this.err = 'Please enter 10 Digits';
    });
}
}

Widget idWidget() {
  final deviceSize = MediaQuery.of(context).size;
  double wid = deviceSize.width * 0.1;
  return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: deviceSize.height * 0.57,
            ),
            Padding(
            padding: EdgeInsets.fromLTRB(wid,10,wid,10),
            child: Container(
              height: deviceSize.height * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Enter your phone number to login',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                  ),),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children:<Widget>[
                        Text('+91   ',
                      style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                    ),),
                    Container(
                      height: deviceSize.height*0.2,
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
                            fontSize: 18,
                            letterSpacing: 8,
                          ),
                          ),),
                          ],
                    ),
                  ),
                        Container(
                      child: 
                     ButtonTheme(
                          minWidth: double.infinity,
                       height: 50,
                       child: RaisedButton(
                       color: Colors.blue,
                       onPressed: () => _toCheck(context) , 
                             shape: 
                            RoundedRectangleBorder(                     
                              borderRadius: BorderRadius.circular(30),
                            ),
                      child: Text("PROCEED",
                      style: TextStyle(color: Colors.white),),
                       ),
                      ),
                        ),
                ],
              ),
            ),
          ),
          ],
              
        ),
      ),
    );
}

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
     return _isLoading ? Container(
       height: double.infinity,
       width: double.infinity,
       child: Stack(
        children: <Widget>[
              Center(
          child: Image.asset('lib/assets/images/logo.png'),
        ),

        Center(
          child: SizedBox(
            width: deviceSize.width * 0.3,
            height: deviceSize.width * 0.3,
            child: CircularProgressIndicator()       
          )
        )

        ],
      )
     )
      :idWidget() ;
  }
}
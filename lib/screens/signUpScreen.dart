import 'package:flutter/material.dart';
import 'package:medical_shop/providers/auth.dart';
import 'package:medical_shop/screens/addPlaceScreen.dart';
import 'package:medical_shop/screens/addProfile.dart';
import 'package:medical_shop/screens/signInScreen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '\signUp';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var isLoading = false;
  var init = true;
  var userst = true;
  final _initController = TextEditingController();
  final _confController = TextEditingController();
  String err = ' ';
  String err1 = ' ';
  String mode = 'add';

void _toSignIn(BuildContext ctx){

Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);

}

Future _signUp(BuildContext ctx) async {


if(this._initController.text.length !=4) {
  setState(() {
  this.err = 'Enter 4 Digit Pin';
});
} else {
  setState(() {
  this.err = '';
});
}

if(this._confController.text.length !=4) {
  setState(() {
  this.err1 = 'Enter 4 Digit Pin';
});
} else {
  setState(() {
  this.err1 = '';
});
}

if(this._initController.text.length == 4
&& this._initController.text == this._confController.text
) {
setState(() {
  this.err = '';
  this.err1 = '';
  isLoading = true;
});

if(this.mode == 'add'){
  final result = await Provider.of<Auth>(context, listen: false).signUp(_initController.text , ctx);

if(result){
   Navigator.of(ctx).pushReplacementNamed(AddProfile.routeName, 
    arguments: {'mode' : 'add',
    'number': ' '})
    ;
} else {
  setState(() {
    this.err1 = 'Contact Support';
    isLoading = false;
  });
  
}
} else if(this.mode == 'edit'){
  final result = await Provider.of<Auth>(context, listen: false).updPin(_initController.text , ctx);

    if(result){
      Navigator.of(ctx).pushReplacementNamed('/');
    } else {
      setState(() {
    this.err1 = 'Contact Support';
    isLoading = false;
  });
   } 
} else {
  setState(() {
      this.err1 = 'PIN is Not Matching';
    });
}
}
}

Widget signUpWidget() {
final deviceSize = MediaQuery.of(context).size;   
double wid = deviceSize.width * 0.3;
return Column(
  children: <Widget>[
    SizedBox(
      height: deviceSize.height * 0.55,
    ),
    Padding(
    padding: EdgeInsets.all(10),
    child: Container(
      height: deviceSize.height * 0.36,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('Set your 4 digit Password',
          style: TextStyle(
            color: Colors.grey,
            fontSize: deviceSize.height * 0.023,
          ),),
          Padding(
            padding: EdgeInsets.fromLTRB(wid, 0, wid, 0),
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
                  controller: _initController,
                  style: TextStyle(
                    fontSize: deviceSize.height * 0.025,
                    letterSpacing: 8,
                  ),
                  ),),
                  

                  ],
            ),
            
          ),
          
              Text('$err', style: TextStyle(
                color: Colors.red,
                fontSize: deviceSize.height * 0.016,
              ),),
              Text('Confirm Password',
          style: TextStyle(
            color: Colors.grey,
            fontSize: deviceSize.height * 0.023,
          ),),
                          Padding(
            padding: EdgeInsets.fromLTRB(wid, 0, wid, 0),
            child: Row(
              children:<Widget>[
                Flexible(
                  child: TextField(
                    obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(      
	                 borderSide: BorderSide(color: Colors.grey),   
	               ),  
	              focusedBorder: UnderlineInputBorder(
	                borderSide: BorderSide(color: Colors.grey),
	              ),
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: _confController,
                  style: TextStyle(
                    fontSize: deviceSize.height * 0.025,
                    letterSpacing: 8,
                  ),
                  ),),

                  ],
            ),
          ),
          Text('$err1', style: TextStyle(
                color: Colors.red,
                fontSize: deviceSize.height * 0.016,
              ),),

        ],
      ),
    ),
  ),
          ButtonTheme(
              minWidth: double.infinity,
                      height: 50,
              child: RaisedButton(                    
                child: Text(this.mode == 'add' ? 'SIGN UP' : 'SET PIN'),
                onPressed: () => _signUp(context),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.button.color,
              ),
            ),
  ],
      
);
}

  @override
  Widget build(BuildContext context) {

    final routeArgs = 
  ModalRoute.of(context).settings.arguments as Map<String,dynamic>;

  this.mode = routeArgs['mode'];
  print(this.mode);

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
          SingleChildScrollView(child: signUpWidget())
            ],
        ),
    ),
    );
  }
}
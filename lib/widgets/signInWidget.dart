// import 'package:flutter/material.dart';

// class SignIn extends StatefulWidget {


//   @override
//   _SignInState createState() => _SignInState();
// }

// class _SignInState extends State<SignIn> {
//   String err;

//   final _phoneController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//   final deviceSize = MediaQuery.of(context).size; 

//   final GlobalKey<FormState> _formKey = GlobalKey();
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: <Widget>[
//           SizedBox(
//             height: deviceSize.height * 0.57,
//           ),
//           Padding(
//           padding: const EdgeInsets.all(10),
//           child: Container(
//             height: deviceSize.height * 0.4,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text('Enter Your PIN to LOGIN',
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 17,
//                 ),),
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Row(
//                     children:<Widget>[
//                       Flexible(
//                         child: TextFormField(
//                         decoration: InputDecoration(
                
//                           errorText: this.err
//                         ),
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         controller: _phoneController,
//                         style: TextStyle(
//                           fontSize: 18,
//                           letterSpacing: 8,
//                         ),
//                         ),),

//                         ],
//                   ),
//                 ),
//                   Padding(
//                     padding: const EdgeInsets.all(0),
//                     child: RaisedButton(
//                       child: _isLoading ? 
//                       CircularProgressIndicator()
//                       : Text('LOGIN'),
//                       onPressed: () => _submit(context),
//                       shape: 
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       padding:
//                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
//                       color: Theme.of(context).primaryColor,
//                       textColor: Theme.of(context).primaryTextTheme.button.color,
//                     ),
//                   ),
//                   Center(child: Text('By Continuing, you agree to our Terms & Conditions and Privacy Policy ', 
//                   style: TextStyle(fontSize: 11,),
//                   textAlign: TextAlign.center
//                   )
//                   ),
//               ],
//             ),
//           ),
//         ),
//         ],
            
//       ),
//     );
//   }
// }
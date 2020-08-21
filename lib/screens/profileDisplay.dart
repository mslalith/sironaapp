import 'package:flutter/material.dart';
import 'package:medical_shop/models/person.dart';
import 'package:medical_shop/providers/auth.dart';
import 'package:medical_shop/providers/profile.dart';
import 'package:medical_shop/screens/aboutUs.dart';
import 'package:medical_shop/screens/addProfile.dart';
import 'package:medical_shop/screens/listReceipts.dart';
import 'package:medical_shop/screens/manageAddress.dart';
import 'package:medical_shop/screens/orderListScreen.dart';
import 'package:medical_shop/screens/prescriptionOrder.dart';
import 'package:medical_shop/screens/refer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class DisplayProfile extends StatelessWidget {
  static const routeName = '/profileDetail2';
    void addProfile(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(AddProfile.routeName, 
    arguments: {'mode' : 'add'});
  }

   void _onLogOut(BuildContext ctx) {
      Provider.of<Auth>(ctx, listen: false).logout();

  }

  Future<void> _rateApp() async {
    var url = "https://play.google.com/store/apps/details?id=in.sironapharmacy.delivery" ;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  void editProfile(BuildContext ctx) {
   Navigator.of(ctx).pushNamed(AddProfile.routeName, arguments: {
     'mode' : 'edit'});
  }
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

  final profileData = Provider.of<Profile>(context);
  Person person = profileData.getPerson;

    return Scaffold(
       backgroundColor: Color(0xffF2EFEF),
      body: Column(
        children: <Widget>[
          Container(
            width: deviceSize.width,
            height: deviceSize.height * 0.15,
            decoration: BoxDecoration(
              color: Color(0xff83BB40),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: deviceSize.height * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Container(
               width: deviceSize.width * 0.15,
               height: deviceSize.height * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3.0),
              ),
              child: Center(child: Text('${person.name[0]}', style: TextStyle(color: Colors.white, fontSize: deviceSize.height * 0.03, fontWeight: FontWeight.w800)),
              ),
                ),
                Container(
                  width: deviceSize.width * 0.07,
                ),
                Container(
               width: deviceSize.width * 0.6,
               height: deviceSize.height * 0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(child:Text('${person.name}', style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.w800,
                       fontSize: deviceSize.height * 0.022)),),
                      Container(height: deviceSize.height * 0.005,),
                      Container(child: Text('+91 ${person.phone}', style: TextStyle(color: Colors.white, fontSize: deviceSize.height * 0.022)),)
                    ],
                  ),
                ),
                 Container(
                  width: deviceSize.width * 0.05,
                  child: IconButton(icon: Icon(Icons.edit, color: Colors.white,),
                  onPressed: () => editProfile(context),),
                ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => {
              Navigator.of(context).pushNamed(OrderListScreen.routeName, arguments: {'mode' : 'view'})
            },
            child: Container(
              height: deviceSize.height * 0.1,
              width: deviceSize.width,
              decoration: BoxDecoration(
                color: Colors.white,
               border: Border(
            bottom: BorderSide(  color: Color(0xffA19F9F),
          width: 1.2,),),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: deviceSize.width * 0.2,
                    child: Image.asset('lib/assets/images/profile1.png')),
                  Container(
                    width: deviceSize.width * 0.65,
                    child: Text(
                      'Orders',
                      style: TextStyle(
                        fontSize: deviceSize.height * 0.025,
                        fontWeight: FontWeight.w600)
                    )
                  ),
                  Container(
                    width: deviceSize.width * 0.1,
                    child: Icon(Icons.arrow_forward_ios,
                    color: Color(0xff83BB40),),
                  )
                ],
              ),
            ),
          ),

            InkWell(
            onTap: () => {
              Navigator.of(context).pushNamed(ListReceipts.routeName, arguments: {'mode' : 'view'})
            },
            child: Container(
              height: deviceSize.height * 0.1,
              width: deviceSize.width,
              decoration: BoxDecoration(
                color: Colors.white,
               border: Border(
            bottom: BorderSide(  color: Color(0xffA19F9F),
          width: 1.2,),),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: deviceSize.width * 0.2,
                    child: Image.asset('lib/assets/images/profile2.png')),
                  Container(
                    width: deviceSize.width * 0.65,
                    child: Text(
                      'Prescriptions',
                      style: TextStyle(
                        fontSize: deviceSize.height * 0.025,
                        fontWeight: FontWeight.w600)
                    )
                  ),
                  Container(
                    width: deviceSize.width * 0.1,
                    child: Icon(Icons.arrow_forward_ios,
                    color: Color(0xff83BB40),),
                  )
                ],
              ),
            ),
          ),

                    InkWell(
            onTap: () => {
              Navigator.of(context).pushNamed(ManageAddress.routeName),},
            child: Container(
              height: deviceSize.height * 0.1,
              width: deviceSize.width,
              decoration: BoxDecoration(
                color: Colors.white,
               border: Border(
            bottom: BorderSide(  color: Color(0xffA19F9F),
          width: 1.2,),),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: deviceSize.width * 0.2,
                    child: Image.asset('lib/assets/images/mapicon.png', height: deviceSize.height * 0.05)),
                  Container(
                    width: deviceSize.width * 0.65,
                    child: Text(
                      'Manage Addresses',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: deviceSize.height * 0.025,
                        fontWeight: FontWeight.w600)
                    )
                  ),
                  Container(
                    width: deviceSize.width * 0.1,
                    child: Icon(Icons.arrow_forward_ios,
                    color: Color(0xff83BB40),),
                  )
                ],
              ),
            ),
          ),

                    InkWell(
            onTap: () => {
              Navigator.of(context).pushNamed(ReferPage.routeName),},
            child: Container(
              height: deviceSize.height * 0.1,
              width: deviceSize.width,
              decoration: BoxDecoration(
                color: Colors.white,
               border: Border(
            bottom: BorderSide(  color: Color(0xffA19F9F),
          width: 1.2,),),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: deviceSize.width * 0.2,
                    child: Image.asset('lib/assets/images/profile3.png')),
                  Container(
                    width: deviceSize.width * 0.65,
                    child: Text(
                      'Refer and Earn',
                      style: TextStyle(
                        fontSize: deviceSize.height * 0.025,
                        fontWeight: FontWeight.w600)
                    )
                  ),
                  Container(
                    width: deviceSize.width * 0.1,
                    child: Icon(Icons.arrow_forward_ios,
                    color: Color(0xff83BB40),),
                  )
                ],
              ),
            ),
          ),

                    InkWell(
            onTap: () => _rateApp(),
            child: Container(
              height: deviceSize.height * 0.1,
              width: deviceSize.width,
              decoration: BoxDecoration(
                color: Colors.white,
               border: Border(
            bottom: BorderSide(  color: Color(0xffA19F9F),
          width: 1.2,),),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: deviceSize.width * 0.2,
                    child: Image.asset('lib/assets/images/profile4.png')),
                  Container(
                    width: deviceSize.width * 0.65,
                    child: Text(
                      'Rate Us',
                      style: TextStyle(
                        fontSize: deviceSize.height * 0.025,
                        fontWeight: FontWeight.w600)
                    )
                  ),
                  Container(
                    width: deviceSize.width * 0.1,
                    child: Icon(Icons.arrow_forward_ios,
                    color: Color(0xff83BB40),),
                  )
                ],
              ),
            ),
          ),

             InkWell(
             onTap: () => Navigator.of(context).pushNamed(AboutUs.routeName),
            child: Container(
              height: deviceSize.height * 0.1,
              width: deviceSize.width,
              decoration: BoxDecoration(
                color: Colors.white,
               border: Border(
            bottom: BorderSide(  color: Color(0xffA19F9F),
          width: 1.2,),),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: deviceSize.width * 0.2,
                    child: Image.asset('lib/assets/images/profile5.png')),
                  Container(
                    width: deviceSize.width * 0.65,
                    child: Text(
                      'About Us',
                      style: TextStyle(
                        fontSize: deviceSize.height * 0.025,
                        fontWeight: FontWeight.w600)
                    )
                  ),
                  Container(
                    width: deviceSize.width * 0.1,
                    child: Icon(Icons.arrow_forward_ios,
                    color: Color(0xff83BB40),),
                  )
                ],
              ),
            ),
          ),

        Container(
          height: deviceSize.height * 0.03,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
          Container(
            width: deviceSize.width * 0.5,
            child: InkWell(
              onTap: () => _onLogOut(context),
              child: Row(children: <Widget>[
                Icon(Icons.exit_to_app,
                color: Color(0xff707070),
                ),
                Text('  Log out', style: TextStyle(color:Color(0xff707070),),),
              ],), 
            ),
          ),
          Text('Version', style: TextStyle(color:Color(0xff707070),),)
        ],),
        Container(
          height: deviceSize.height * 0.045,
        ),
        Text('@2020 All rights reserved', style: TextStyle(color:Color(0xff707070),),)
          
        ],


      ),
      
    );
  }
}
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  static const routeName = '/aboutUs';
  @override
  Widget build(BuildContext context) {
     final deviceSize = MediaQuery.of(context).size; 
    return Scaffold(
      backgroundColor: Color(0xffF2EFEF),
      appBar: AppBar(
        backgroundColor: Color(0xff83BB40),
        title: Text('About us'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height * 0.95,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: deviceSize.height * 0.015),
                Container(
                  height: deviceSize.height * 0.11,
                  child: Text('Sirona Pharmacy is the one-stop destination for all Ethical ,Generic ,OTC, Homeopathy & Ayurvedic medicines, medical devices, health supplements, personal hygiene & more.'),
                ),

                Container(height: deviceSize.height * 0.015),

                 Container(
                     height: deviceSize.height * 0.11,
                  child: Text('We’re proud to be the only online pharmacy to deliver medicines on demand. Download the Sirona Pharmacy App to shop ‘faster’ for all your medicines and get them delivered at home within same day.'),
                ),

                Container(height: deviceSize.height * 0.03),


                 Container(
                  child: Flexible(child: 
                  Text('Why use Sirona Pharmacy App?')),
                ),

                Container(height: deviceSize.height * 0.03),

                Container(
                  child: Text('* Super-fast home delivery - You don’t have to go into any trouble to get medicines especially when sick, we provide fastest door delivery services.'),
                ),

                Container(height: deviceSize.height * 0.03),

                Container(
                  child: Text('* We are here for you - You don`t need to go through the hassle of adding each medicine separately, simply upload your prescription on our app & we will place your order via call.'),
                ),

                Container(height: deviceSize.height * 0.03),

                Container(
                  child: Text('* No waiting - You can track order delivery status in real-time from App.'),
                ),

                Container(height: deviceSize.height * 0.03),

                 Container(
                  child: Text('* Anytime, Anywhere - All your orders can be accessed from anywhere and anytime from your Mobile App!'),
                ),

                Container(height: deviceSize.height * 0.03),

                   Container(
                  child: Text('Your safety is our biggest priority. All products delivered by us come with a 100% genuine guarantee.'),
                ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}
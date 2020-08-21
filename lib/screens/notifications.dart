import 'package:flutter/material.dart';
import 'package:medical_shop/models/offer.dart';
import 'package:medical_shop/providers/offers.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  static const routeName = '/notifications';

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _visible = false;

    setCoupon(BuildContext ctx, Offer setOffer) {
    final offerData = Provider.of<OfferList>(ctx, listen: false);
    offerData.setOffer(setOffer);
      setState(() {
              _visible = true;
      });
  }

  @override
  Widget build(BuildContext context) {

  final deviceSize = MediaQuery.of(context).size;
   final offerData = Provider.of<OfferList>(context);
   List<Offer> offerList = offerData.getOffers;
    return Scaffold(
      backgroundColor: Color(0xffF2EFEF),
      appBar: AppBar(
        backgroundColor: Color(0xff83BB40),
        title: Text('Notifications'),
      ),
      body:  Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: deviceSize.height * 0.03,
            ),
            Container(
              width: deviceSize.width * 0.9,
              height: deviceSize.height * 0.8,
              child: ListView.builder(
                 itemBuilder: (BuildContext ctxt, int index){
                 return 
                  Container( 
                    height: deviceSize.height * 0.33,
                    width: deviceSize.width * 0.9,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: deviceSize.height * 0.22,
                          width: double.infinity,
                          child: Image.network(offerList[index].link,fit: BoxFit.fill)
                        ),
                        Container(
                          color: Color(0xff83BB40),
                          height: deviceSize.height * 0.05,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(width: deviceSize.width * 0.08),
                              Text('COUPON CODE: ', style: TextStyle(color: Colors.white),),
                              Container(width: deviceSize.width * 0.13),
                              Text('${offerList[index].code}', style: TextStyle(color: Colors.white),),
                               Container(width: deviceSize.width * 0.03),
                              Container(
                                child: _visible ? Center(child: Text('Copied', style: TextStyle(color: Colors.white), ))  : IconButton(icon: Icon(Icons.content_copy), onPressed: () => setCoupon(context,offerList[index]), iconSize: deviceSize.height * 0.02 , color: Colors.white,)),
                            ],
                          ),
                        ),
                        Container(
                          height: deviceSize.height * 0.02
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                          
                          Container(child: Center(child: Text('*Valid Till: ${offerList[index].endDate}'))),
                          Container(
                          width: deviceSize.width * 0.01
                        ),
                          
                        ],),

                      ],
                    ),
                   );
                     },
                    itemCount: offerList.length
                    ),
              
            ),
          ],
        ),
      ),
    );
  }
}
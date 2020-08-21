import 'package:flutter/material.dart';
import 'package:medical_shop/models/order.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewOrder extends StatelessWidget {

  static const routeName = '/viewOrder';

  @override
  Widget build(BuildContext context) {
     final deviceSize = MediaQuery.of(context).size;

  final routeArgs = 
  ModalRoute.of(context).settings.arguments as Map<String,Order>;

  Order od = routeArgs['order'];

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Order od = new Order(
  //    oDate: '35-23-1202',
  //    oTime: '10:10',
  //    orderId: 1,
  //    name: 'jara',
  //    phone: '93933039',
  //    delPerson: 'Jars',
  //    status: 'New Order',
  //    lat: 12.12,
  //    lng: 12.12,
  //    deliveryAddr: 'ksajdk',
  //    amount: 1000,
  //    eDate: '27-04-1991' );

    return Scaffold(
        backgroundColor: Color(0xffF2EFEF),
      appBar: AppBar(
        backgroundColor: Color(0xff83BB40),
        title: Text('My Orders'),
    ),
    body: SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: deviceSize.height * 0.02,
            ),
              Container(
                decoration: BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                       color: Colors.grey,
                        blurRadius: 8.0,
                            ),],
                          borderRadius: BorderRadius.circular(4) ,
                         color: Colors.white
                        ),
                  height: deviceSize.height * 0.15,
                  width: deviceSize.width * 0.93,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                     Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: deviceSize.width * 0.4,
                      child: Text('Order ID : ', 
                      style: TextStyle(fontSize: deviceSize.height * 0.017, color: Color(0xff83BB40))),
                    ),
                    Container(
                       width: deviceSize.width * 0.4,
                      child: Text('${od.orderId}', 
                      style: TextStyle(fontSize: deviceSize.height * 0.025, fontWeight: FontWeight.w500),),
                    ),
                  ],
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: deviceSize.width * 0.4,
                      child: Text(od.status == 'Delivered' ? 'Delivered Date : ' : od.status == 'Cancelled' ? 'Cancelled by : ': 'Expected Delivery Date : ', 
                      style: TextStyle(fontSize: deviceSize.height * 0.017, color: Color(0xff83BB40))),
                    ),
                    Container(
                       width: deviceSize.width * 0.4,
                      child: Text( od.status == 'Cancelled' ? '${od.pModified}' : od.eDate == null ? 'N/A' : '${od.eDate}', 
                      style: TextStyle(fontSize: deviceSize.height * 0.025),),
                    ),
                  ],
                ),
                  ],
                )
              ),
              Container(
              height: deviceSize.height * 0.02,
            ),
              Container(
                decoration: BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                       color: Colors.grey,
                        blurRadius: 8.0,
                            ),],
                          borderRadius: BorderRadius.circular(4) ,
                         color: Colors.white
                        ),
                  height: deviceSize.height * 0.4,
                  width: deviceSize.width * 0.93,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text( od.status == 'Deliverd' ? 'Amount Paid' : od.status == 'Reason' ? ' ' : 'Amount to be Paid', 
                    style: TextStyle(fontSize: deviceSize.height * 0.023),),
                  Container(
                    height: deviceSize.height * 0.001,
                    width: deviceSize.width * 0.7,
                    color: Colors.grey,
                  ),
                   od.status == 'Cancelled' ? Text('${od.remarks}') : od.amount != null ? Text('\u20B9 ${od.amount}', 
                    style: TextStyle(fontSize: deviceSize.height * 0.0675),) : 
                    Text('Yet to be billed',
                    style: TextStyle(fontSize: deviceSize.height * 0.0324),),
                  Container(
                    height: deviceSize.height * 0.001,
                    width: deviceSize.width * 0.7,
                    color: Colors.grey,
                  ),
                  Container(
                  alignment: Alignment.center,
                   height: deviceSize.height * 0.05,
                    width: deviceSize.width *0.5,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ClipRRect(child:
                        Image.asset('lib/assets/images/phonepe.png'),),
                        Text('83330 02020', 
                      style: TextStyle(fontSize: deviceSize.height * 0.025),),
                      ],
                    ),
                  ),
                  Text('or'),
                  Container(
                    alignment: Alignment.center,
                    height: deviceSize.height * 0.05,
                    width: deviceSize.width *0.5,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ClipRRect(child:
                        Image.asset('lib/assets/images/cod.png'),),
                        Text('Cash On Delivery', 
                      style: TextStyle(fontSize: deviceSize.height * 0.022),),
                      ],
                    ),
                  )
                ],
              ),

              ),
              Container(
              height: deviceSize.height * 0.02,
            ),
              Container(
                decoration: BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                       color: Colors.grey,
                        blurRadius: 8.0,
                            ),],
                          borderRadius: BorderRadius.circular(4) ,
                         color: Colors.white
                        ),
                  height: deviceSize.height * 0.15,
                  width: deviceSize.width * 0.93,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: deviceSize.height * 0.07,
                    child: Image.asset('lib/assets/images/delguy.png')
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: deviceSize.width*0.33,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                       od.delPerson != null ? Text('${od.delPerson}',style: TextStyle(
                    color: Colors.black,
                    fontSize: deviceSize.height * 0.023
                  ),) : Text('To be assigned',style: TextStyle(
                    color: Colors.black,
                    fontSize: deviceSize.height * 0.023
                  ),)
                  ,
                        Text('Delivery Person',style: TextStyle(
                    color: Colors.grey,
                    fontSize: deviceSize.height * 0.02
                  ),),
                      ],
                    ),

                  ),
                ),

                RaisedButton(onPressed: () => od.status == 'Pending' ? _makePhoneCall('tel:+91${od.delContact}') : null,
                color: Colors.blue,
                child: Text('Call', style: TextStyle(
                  color: Colors.white,
                  fontSize: deviceSize.height * 0.023
                ),),),               
                ],
              ),
              ),
              Container(
              height: deviceSize.height * 0.02,
            ),
          ],
        ),
      ),
    ),
    );
  }
}
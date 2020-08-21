import 'package:flutter/material.dart';
import 'package:medical_shop/models/order.dart';
import 'package:medical_shop/providers/auth.dart';
import 'package:medical_shop/providers/orders.dart';
import 'package:medical_shop/screens/orderScreen.dart';
import 'package:medical_shop/screens/viewOrder.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';

class OrderListScreen extends StatefulWidget {
  static const routeName = '/orders' ;

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  var orders;
  int selectedIndex = 0;
  bool homeMode = true;
  bool isInit = true;
  void _viewOrder(BuildContext ctx,Order od) {
     Navigator.of(ctx).pushNamed(ViewOrder.routeName, arguments: {'order' : od});
  }

  void _stOrder(BuildContext ctx,Order od) {
     Navigator.of(ctx).pushNamed(OrderScreen.routeName, arguments: {'order' : od});
  }

  // void _changeMode(String str) {
  //   setState(() {
  //     mode = str;
  //   });
  // }

  Color _getColor(String sts) {
    Color ret;
    if(sts == 'In progress') ret = Colors.orange;
    if(sts == 'Completed') ret = Colors.green;
    if(sts == 'Canceled') ret = Colors.red;
    return ret;
  }

    Future<void> _refreshProducts(BuildContext ctx) async {
    final authData = Provider.of<Auth>(context,listen: false);
    final number = authData.number;
    await Provider.of<OrderList>(context, listen:false).fetchOrders(number);
    }


  @override
  Widget build(BuildContext context) {
  
   final ordersData = Provider.of<OrderList>(context);

   final routeArgs = 
   ModalRoute.of(context).settings.arguments as Map<String,dynamic>; 

   if(routeArgs != null) {
     homeMode = false;
   } else {
     homeMode = true;
   }
   final allOrders = ordersData.getOrders;
   if(isInit) {
     isInit = false;
     this.orders = allOrders ;
   }

   String dStatus = '';
   List<String> pStatus = ['All' ,'New Order' , 'Pending', 'Delivered', 'Cancelled'];

  void _changeAddr(String str, int index){
  print(str) ; 
    setState(() {
      this.orders = [] ;
      this.selectedIndex = index;
      allOrders.forEach((id) {
        if( id.status == str) {
            orders.add(id);
        } else if (str == 'All') {
          this.orders = allOrders;
        }
      });
    });
  }


   int oLength = orders.length;
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xffF2EFEF),
       appBar: AppBar(      
        title: homeMode ? 
        Row( children : <Widget>[ 
              Icon(Icons.list),
               Container(width: deviceSize.width * 0.02),
               Text('My Orders', style: TextStyle(color: Colors.white),),
          ],) : 
           Row( children : <Widget>[ 
               Container(width: deviceSize.width * 0.02),
               Text('My Orders', style: TextStyle(color: Colors.white),),
          ],) ,
     //   backgroundColor: Colors.green,
     backgroundColor: Color(0xff83BB40),
      ),
        body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Column(
            children: <Widget>[
              Container(
            height: deviceSize .height * 0.08,
            child: Row(
              children: <Widget>[
              Container(
                width: deviceSize.width * 0.95,
                child: ListView.builder(
               scrollDirection: Axis.horizontal,
               itemBuilder: (BuildContext ctxt, int index){
               return 
                Padding(
                padding: EdgeInsets.fromLTRB(deviceSize.width * 0.03, deviceSize.height * 0.03, 0, 0),
              child: Container( 
               height: deviceSize.height * 0.02,
              width: deviceSize.width * 0.3,
                decoration: BoxDecoration(
                     color: this.selectedIndex == index ? Colors.white : Color(0xff83BB40),
                     border: Border.all(color: Color(0xff83BB40)),
                                             borderRadius: BorderRadius.circular(20),      
                                           ),
                                      child: InkWell(      
                                        onTap: () => _changeAddr(pStatus[index], index),
                                        child: Center(
                                          child: Text('${pStatus[index]}',
                                          style: TextStyle(color: this.selectedIndex == index ? Color(0xff83BB40) : Colors.white),
                                          ),
                                        )
                                        ),
                                    ),
                                  );
                             },
                             itemCount: pStatus.length),
              ), 
              Container(
                width: deviceSize.width * 0.05
              ),  
              ],
            ),
          ),
          Container(height: deviceSize.height * 0.005,),
           Container(
             height: homeMode ? deviceSize.height * 0.68 : deviceSize.height * 0.78,
              child: ListView.builder(
                itemBuilder: (ctx,index) {
               return 
                  //  StreamBuilder<Order>(
                  //    stream: null,
                  //    builder: (context, snapshot) {
                  //      return
                       
                Padding(
                padding: EdgeInsets.fromLTRB(deviceSize.width*0.03 ,20,deviceSize.width*0.03,0),
                child: Container(      
                  height: deviceSize.height * 0.098,
                  decoration: BoxDecoration(
                    color: Colors.white,
                   boxShadow: [
                new BoxShadow(
                  color: Color(0xff707070),
                 blurRadius: 2.0,
                     ),],
                   borderRadius: BorderRadius.circular(3)
                  ),
                  child:                      
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: deviceSize.height * 0.005,
                      ),
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                           Container(
                             width: deviceSize.width * 0.4,
                             child: Center(
                               child: Text('ORDER ID',
                                style: TextStyle(color: Color(0xff707070), fontSize: deviceSize.height * 0.013),),
                             ),
                           ),
                             Container(
                               width: deviceSize.width * 0.4,
                               child: Center(
                                 child: Text('ORDERED DATE'
                            ,style: 
                            TextStyle(color: Color(0xff707070), fontSize: deviceSize.height * 0.013),
                            ),
                               ),
                             ),
                          ],
                        ),
                      ),
                       Container(
                        height: deviceSize.height * 0.005,
                      ),
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                           Container(
                              width: deviceSize.width * 0.4,
                             child: Center(
                               child: Text('${orders[oLength-1-index].orderId}',
                                style: TextStyle(color: Colors.black, fontSize: deviceSize.height * 0.02),),
                             ),
                           ),
                             Container(
                                width: deviceSize.width * 0.4,
                               child: Center(
                                 child: Text('${orders[oLength-1-index].oDate}'
                            ,style: 
                            TextStyle(color: _getColor(orders[index].status), fontSize: deviceSize.height * 0.02),
                            ),
                               ),
                             ),
                          ],
                        ),
                      ),
                       Container(
                        height: deviceSize.height * 0.005,
                      ),
                      Container(
                        width: double.infinity,
                        height: deviceSize.height * 0.04,
                       
                        child: Row(
                          children: <Widget>[
                            Flexible(
                               child: Container(
                               width: deviceSize.width*0.4825,
                               height: deviceSize.height * 0.04,
                                color: Colors.blue,
                                child: InkWell(
                        onTap:  () => 
                        _viewOrder(context,orders[oLength-1-index]),
                         child:  
                         Center( child: Text('Status', style: TextStyle(
                            fontSize: deviceSize.height * 0.025,
                            color: Colors.white),),
                                     ),   
                                ),
                              ),
                            ),
                            Flexible(
                                child: Container(
                               width: deviceSize.width*0.4825,
                               height: deviceSize.height * 0.04,
                                color:  Color(0xff83BB40),
                               child: InkWell(
                           onTap:  () => 
                          _stOrder(context,orders[oLength-1-index]),
                           child:  Center(
                          child: Text('Order', style: TextStyle(
                          fontSize: deviceSize.height * 0.025,
                          color: Colors.white),),
                                     ),   
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                 ),
                   );
              }, itemCount: orders.length,),
            ),
            ],
           
          ),
        ) 
      );   
  }
}
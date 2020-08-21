import 'package:flutter/material.dart';
import 'package:medical_shop/models/item.dart';

import 'addPlaceScreen.dart';

class ImageOrder extends StatefulWidget {
  static const routeName = '/imageOrder';
  @override
  _ImageOrderState createState() => _ImageOrderState();
}

class _ImageOrderState extends State<ImageOrder> {

List<Item> items = [];
Item item;
  String _imageUrl1;
  String _imageUrl2;
  int imgIndex = 0;
  int qty = 1;

  
  final _textContr = TextEditingController();

  void minus() {
    setState(() {
      qty--;
    });
  }

  void add() {
    setState(() {
      qty++;
    });
  }

    void iminus() {
    setState(() {
      imgIndex--;
    });
  }

  void iadd() {
    setState(() {
      imgIndex++;
    });
  }

void _onProceed(BuildContext ctx) {

print('${item.desc}');
print('length sis ${this.items.length}');
  
  this.items.add(new Item(id: item.id,
  desc: item.desc,
  orderId: item.orderId,
  phone: item.phone,
  status: item.status,
  imageUrl1: item.imageUrl1,
  imageUrl2: item.imageUrl2,
  type: item.type,
  units: item.units,
  unitPrice: item.unitPrice,
  tax: item.tax,
  amount: item.amount,
  quantity: item.quantity));
  print(this.items.length);

    Navigator.of(ctx).pushNamed(AddPlaceScreen.routeName, arguments: {'items' : this.items});
    
  }
  
  @override
  Widget build(BuildContext context) {
  final deviceSize = MediaQuery.of(context).size;
  final routeArgs = 
  ModalRoute.of(context).settings.arguments as Item;
  print(routeArgs);
  item = routeArgs;
//  final item = routeArgs['item'];
    return Scaffold(
        backgroundColor: Color(0xffF2EFEF),
   
      appBar: AppBar(
        title: Text('Add Prescription'),
             backgroundColor: Color(0xff83BB40),
      ),
      body: Column(
      
      children: <Widget>[
        Card(
            child: Container(
              height: deviceSize.height * 0.1,
              width: deviceSize.width * 0.85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('1.'),
                  Container(
                    height: deviceSize.height * 0.03,
                    width: deviceSize.width * 0.06,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey)
                    ),
                    
                ),
                Container(
                  width: deviceSize.width * 0.5,
                  height: deviceSize.width * 0.08,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(item.desc),
                      Container(
                        width: deviceSize.width * 0.4,
                        height: 1,
                        color: Colors.grey,

                      )
                    ],
                     ),
                ),
                Text('Qty'),
                Text('${item.quantity}')
                ],
              ),
            ),
          ) ,

          
          
          Expanded(
            child: Container(
             
            ),
          ),
          ButtonTheme(
                minWidth: double.infinity,
                height: deviceSize.height * 0.07,
                child: RaisedButton(
                color: Colors.blue,
                onPressed: () => _onProceed(context), 
                child: Text("PROCEED",
                style: TextStyle(color: Colors.white),),
                ),
              ),

      ],
      
    //     child: Column( 
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: <Widget>[     
    //       Card(
    //         child: Container(
    //           height: deviceSize.height * 0.1,
    //           width: deviceSize.width * 0.85
    //         ),
    //       )  ,
    //       Padding(padding: EdgeInsets.all(10),
    //       child: Column(
    //         children: <Widget>[
    //           Container(
    //             height: 350,
    //             width: double.infinity,
    //             child: Image.network(id.imageUrl1,),           
    //           Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: <Widget>[
    //             ButtonTheme(
    //                      minWidth: 5.0,
    //                     height: 5.0,
    //                     child: RaisedButton(
    //                      color: Colors.white,
    //                     onPressed: imgIndex > 0 ? iminus : null, 
    //                     child: Text("<", style: TextStyle( fontSize: 25),),
    //                      ),
    //                     ),
    //             Text('${imgIndex+1}', style: TextStyle( fontSize: 20),),
    //             ButtonTheme(
    //                      minWidth: 5.0,
    //                     height: 5.0,
    //                     child: RaisedButton(
    //                      color: Colors.white,
    //                     onPressed: imgIndex < 2 ? iadd : null, 
    //                     child: Text(">", style: TextStyle( fontSize: 25),),
    //                      ),
    //                     ),
    //           ],
    //             )

    //           )],
    //       ),
    //       ),
        
    //  // Row to add the Item Count - Start

    //     Row(
    //      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: <Widget>[
    //                   Text('  1. ', style: TextStyle(fontSize: 14),),
    //                   Flexible(
    //                     child: TextField(
    //                       decoration: InputDecoration( labelText: '  Product Description         '),
    //                       controller: _textContr,
    //                     ),
    //                   ),
    //                   ButtonTheme(
    //                      minWidth: 5.0,
    //                     height: 5.0,
    //                     child: RaisedButton(
    //                      color: Colors.white,
    //                     onPressed: qty>1 ? minus : null, 
    //                     child: Text("-"),
    //                      ),
    //                     ),
    //                         Text('$qty'),
    //                      ButtonTheme(
    //                     minWidth: 5.0,
    //                     height: 5.0,
    //                     child: RaisedButton(
    //                      color: Colors.white,
    //                     onPressed: qty<20 ? add : null,
    //                     child: Text("+"),
    //                      ),
    //                     ),
    //                       ],
    //                  ), 
                  
    //  // Row to add the Item Count - end
    //                 ButtonTheme(
    //                      minWidth: double.infinity,
    //                     height: 50,
    //                     child: RaisedButton(
    //                      color: Colors.blue,
    //                     onPressed: () =>_onProceed(context), 
    //                     child: Text("PROCEED"),
    //                      ),
    //                     ),

    //     ],
    //     ),
      )
    );
  }
}
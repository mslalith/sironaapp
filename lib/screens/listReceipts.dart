import 'package:flutter/material.dart';
import 'package:medical_shop/providers/orders.dart';
import 'package:provider/provider.dart';

class ListReceipts extends StatefulWidget {
  static const routeName = '/listReceipts';
  @override
  _ListReceiptsState createState() => _ListReceiptsState();
}

class _ListReceiptsState extends State<ListReceipts> {
String mode = 'edit';
List<String> imgList = [];
int pSelect = 0;

void selectIndex(int index) {
  setState(() {
    pSelect = index;
  });
}

void onConfirm(BuildContext ctx) {
  Navigator.pop(ctx, imgList[pSelect]);
}

Color selectColor(int index) {
  if (pSelect == index) {
    return Color(0xff83BB40);
  } else return Colors.white ;
}

  @override
  Widget build(BuildContext context) {
  final deviceSize = MediaQuery.of(context).size; 
  final routeArgs =
   ModalRoute.of(context).settings.arguments as Map<String,String>;
   print(routeArgs);
   if(routeArgs != null){
     mode = routeArgs['view'];
   }

   final imageData = Provider.of<OrderList>(context);
   imgList = imageData.iOrders;

    return Scaffold(
      backgroundColor: Color(0xffF2EFEF),
      appBar: AppBar(
        backgroundColor: Color(0xff83BB40),
        title: Text('Previous Prescriptions'),
      ),

      body: Column(
        children: <Widget>[
          Container(
            height: deviceSize.height * 0.54,
            width: deviceSize.width * 0.95,
            color: Colors.white,
            child: ListView.builder(
               scrollDirection: mode == 'view' ? Axis.vertical : Axis.horizontal,
               itemBuilder: (BuildContext ctxt, int index){
               return 
                Container( 
                 height: deviceSize.height * 0.4,
                  width: deviceSize.width * 0.7,
                  decoration: BoxDecoration(
                   border: Border.all(color: selectColor(index)
                    ),
                  ),
                 child: Padding(
                padding: EdgeInsets.all(deviceSize.width * 0.02),
                child: InkWell(
                  onTap: () => selectIndex(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                       Image.network(imgList[index],fit: BoxFit.scaleDown),
                      Container(
                       child: Text('Prescription No: ${index+1}', style: TextStyle(color: Color(0xff707070),
                       ),
                       ),),
                    ],
                  ),
                )
                 ));
                   },
                  itemCount: imgList.length
                  ),
            
          ),
          Container(height: deviceSize.height * 0.03),
          mode == 'edit' ? Container(
            height: deviceSize.height * 0.07,
            width: deviceSize.width * 0.95,
            color: Colors.white,
            child: Center(child: Text('Selected is Prescription ${pSelect + 1}', style: TextStyle(color: Color(0xff707070)),)),
          ) : Container() ,
          Container(
            height: deviceSize.height * 0.22
          ),
          mode == 'edit' ? 
             ButtonTheme(
                minWidth: double.infinity,
                height: 50,
                child: RaisedButton(
                color: Color(0xff83BB40),
                onPressed: () => onConfirm(context) ,
                child: Text("Select",
                style: TextStyle(color: Colors.white),),
                ),
              )
          : Container()
        
        ],
      )
    );
  }
}
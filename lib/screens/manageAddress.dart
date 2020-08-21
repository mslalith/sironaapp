import 'package:flutter/material.dart';
import 'package:medical_shop/models/address.dart';
import 'package:medical_shop/providers/addresses.dart';
import 'package:medical_shop/screens/addPin.dart';
import 'package:provider/provider.dart';

class ManageAddress extends StatefulWidget {
  static const routeName = '/manageAddress';
  @override
  _ManageAddressState createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {

  List<PAddress> pAddresses = [];
  String dropdownValue ;
  PAddress dropAddr ;
  bool addrClicked = false;

  void _changeAddr(PAddress delAddr){
    setState(() {
      dropAddr = delAddr;
      addrClicked = true;
    });
  }

  void deleteAddress(BuildContext ctx, PAddress delAddr) {
    Navigator.of(context).pop(true);
    Provider.of<AddressList>(ctx, listen: false).delAddress(delAddr);
  }

  void editAddress(BuildContext ctx, PAddress delAddr) {
   Navigator.of(context).pushNamed(AddPin.routeName,  arguments: {'mode' : 'edit' , 'address' : delAddr});
  }
  
  @override
  Widget build(BuildContext context) {

  final addressData = Provider.of<AddressList>(context);
   pAddresses = addressData.getAddresses;
   final deviceSize = MediaQuery.of(context).size;

   void delConf(BuildContext ctx, PAddress delAddress) async {
    final deviceSize = MediaQuery.of(context).size;
    return showDialog(    
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: Container(
             width: deviceSize.width * 0.5,
             height: deviceSize.height * 0.15,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
              Container(
            //  width: deviceSize.width * 0.8,            
              child: Center(
                child: Text('ARE YOU SURE YOU WANT\nTO DELETE THIS ADDRESS?', 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: deviceSize.height * 0.02,
                  fontWeight: FontWeight.w500
                )),
              ),
            ),
            // Container(
            //   height: deviceSize.height * 0.03,
            // ),
            //   Container(
            //   height: deviceSize.height * 0.15,
            //   width: deviceSize.width * 0.4,
            //   child: Image.asset('lib/assets/images/delConf.png', fit: BoxFit.contain ),
            //      ),
               ],
             ),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
               FlatButton(
                child: Text('Yes'),
                onPressed: () => deleteAddress(context, delAddress),
              ),
            ],
          );
        });
  }

    return Scaffold(
      backgroundColor: Color(0xffF2EFEF),
       appBar: AppBar(      
        title: Text('Manage Addresses', style: TextStyle(color: Colors.white),),
     //   backgroundColor: Colors.green,
     backgroundColor: Color(0xff83BB40),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: deviceSize.height * 0.02,
          ),
           Container(
             height: deviceSize.height * 0.78,
              child: ListView.builder(
                itemBuilder: (ctx,index) {
               return
                Padding(
                padding: EdgeInsets.fromLTRB(deviceSize.width*0.03 , 5,deviceSize.width*0.03,deviceSize.height*0.02),
                child: Container(      
                  height: deviceSize.height * 0.222,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                          Container(
                            height: deviceSize.height * 0.05,
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: deviceSize.width * 0.02
                                    ),
                                    Container(
                                      width: deviceSize.width * 0.14,
                                      child:
                                      Image.asset('lib/assets/images/location.png', height: deviceSize.height * 0.025),
                                      // Icon(Icons.pin_drop, color: Color(0xff707070), size: deviceSize.height * 0.025,)
                                      //  Text('Label :', style: TextStyle(color: Color(0xff707070), fontSize: deviceSize.height * 0.017)),
                                    ),
                                    Container(
                                      width: deviceSize.width * 0.02
                                    ),
                                    Container(
                                      width: deviceSize.width * 0.5,
                                      child:  Text('${pAddresses[index].label}',
                                    style: TextStyle(color: Colors.black, fontSize: deviceSize.height * 0.018),),),
                                     Container(
                                      width: deviceSize.width * 0.02
                                    ),
                                Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                      Container(
                                 width: deviceSize.width*0.1,
                                 height: deviceSize.height * 0.04,
                                  child: InkWell(                                 
                                    onTap:  () => editAddress(context, pAddresses[index])                            ,
                                       child:  Center(
                                         child: Icon(Icons.edit , size: deviceSize.height * 0.023, color: Colors.red),
                                       ),   
                                  ),
                                ),
                                 Container(
                                      width: deviceSize.width * 0.02
                                    ),
                                    Container(
                                 width: deviceSize.width*0.1,
                                 height: deviceSize.height * 0.04,
                            //     color: Color(0xff709070),
                                 child: InkWell(
                                    onTap:  () => delConf(context, pAddresses[index]),
                                       child:  Center(
                                         child: Icon(Icons.delete , size: deviceSize.height * 0.023, color: Colors.red),) 
                                  ),
                                ),
                                    ],)
                                    
                                  ],
                                ),
                          ),

                           Container(
                            height: deviceSize.height * 0.03,
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: deviceSize.width * 0.02
                                ),
                                Container(
                                  width: deviceSize.width * 0.14,
                                  // child: Text('Name :', style: TextStyle(color: Color(0xff707070), fontSize: deviceSize.height * 0.017)),
                                ),
                                Container(
                                  width: deviceSize.width * 0.02
                                ),
                                Container(child:  Text('${pAddresses[index].name}',
                                style: TextStyle(color: Colors.black, fontSize: deviceSize.height * 0.018),),)
                              ],
                            ),
                          ),
                        
                          Container(height: deviceSize.height * 0.005,),
                           Container(
                            height: deviceSize.height * 0.075,
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: deviceSize.width * 0.02
                                ),
                                Container(
                                  width: deviceSize.width * 0.14,
                                  // child: Text('Address :', style: TextStyle(color: Color(0xff707070), fontSize: deviceSize.height * 0.017)),
                                ),
                                Container(
                                  width: deviceSize.width * 0.02
                                ),
                                Container(
                                  child:  Flexible(
                                  child: Text('${pAddresses[index].address}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(color: Colors.black, fontSize: deviceSize.height * 0.015),),
                                ),)
                              ],
                            ),
                          ),
                          Container(height: 1,
                          width: double.infinity,
                          color: Colors.grey,),
                              Container(
                            height: deviceSize.height * 0.05,
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: deviceSize.width * 0.02
                                ),
                                Container(
                                  width: deviceSize.width * 0.14,
                                  child: Text('Phone :', style: TextStyle(color: Color(0xff707070), fontSize: deviceSize.height * 0.017)),
                                ),
                                Container(
                                  width: deviceSize.width * 0.02
                                ),
                                Container(child:  Text('${pAddresses[index].phone}',
                                style: TextStyle(color: Colors.black, fontSize: deviceSize.height * 0.018),),)
                              ],
                            ),
                          ),
                          ],
                        ),
                      ),
                         Container(height: deviceSize.height * 0.005,),
                      // Container(
                      //   width: double.infinity,
                      //   height: deviceSize.height * 0.04,
                       
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: <Widget>[
                      //       Flexible(
                      //          child: Container(
                      //          width: deviceSize.width*0.1,
                      //          height: deviceSize.height * 0.04,
                      //         color: Color(0xff709070),
                      //           child: InkWell(                                 
                      //             onTap:  () => editAddress(context, pAddresses[index])
                      //        ,
                      //                child:  Center(
                      //                  child: Icon(Icons.edit , size: deviceSize.height * 0.025, color: Colors.white),
                      //                ),   
                      //           ),
                      //         ),
                      //       ),
                      //       Flexible(
                      //           child: Container(
                      //          width: deviceSize.width*0.1,
                      //          height: deviceSize.height * 0.04,
                      //          color: Color(0xff709070),
                      //          child: InkWell(
                      //             onTap:  () => delConf(context, pAddresses[index]),
                      //                child:  Center(
                      //                  child: Icon(Icons.delete , size: deviceSize.height * 0.025, color: Colors.white),) 
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // )
                    ],
                  )
                 ),
                   );
              }, itemCount: pAddresses.length,),
            ),  
            Container(
                      height: deviceSize.height * 0.022,
                    ),
            ButtonTheme(
                minWidth: double.infinity,
                height: 50,
                child: RaisedButton(
                color: Color(0xff83BB40),
                 onPressed:() => Navigator.of(context).pushNamed(AddPin.routeName,  arguments: {'mode' : 'add'}), 
                // onPressed: () => addOrder(context,' ',' ',' ') , 
                child: Text("ADD ADDRESS",
                style: TextStyle(color: Colors.white),),
                ),
              ),        
      ],)
    );
  }
}
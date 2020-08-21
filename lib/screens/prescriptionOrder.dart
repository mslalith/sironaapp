import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_shop/models/item.dart';
import 'package:medical_shop/screens/addPlaceScreen.dart';
import 'package:medical_shop/screens/listReceipts.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

class PrescriptionOrders extends StatefulWidget {
     static const routeName = '/presOrder';
  @override
  _PrescriptionOrdersState createState() => _PrescriptionOrdersState();
}

class _PrescriptionOrdersState extends State<PrescriptionOrders> {

  final _descController = TextEditingController();
  final _daysController = TextEditingController();
  File _image;  
  List<Item> items = [];
  List<String> imageUrls = [];
  bool imgUploaded = true;
  List<Map<String, dynamic>> images = [];
  Item item;
  String imgUrl;
  String err  = '';
  String _uploadedFileURL;
   bool isImg1 = true;
   bool isImg2 = false;
   bool isInit = true;
   String imageUrl1 ;
   String imageUrl2 ;
   int nextImg = 2;

   void _removeImg1() {
     setState(() {
       imageUrl1 = ' ';
       isImg1 = false;
       nextImg = 1;
     });
   }

  void _removeImg2() {
     setState(() {
       imageUrl2 = ' ';
       isImg2 = false;
     });
   }

  void showAlert(BuildContext ctx,String rem) async {
  final bool res = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirm"),
        content: const Text("Are you sure you wish to delete this item?"),
        actions: <Widget>[
          FlatButton(
            onPressed: () =>  _removeImg(ctx, rem),
            child: const Text("DELETE")
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("CANCEL"),
          ),
        ],
      );
    },
  );}

  void _onProceed(BuildContext ctx) {
  if( _descController.text.trim() == '' || _descController.text.length < 4 ) {
      setState(() {
        err = 'please fill min 4 chars';
      });     
      return;
    } else {
    print(imageUrls);
  this.items.add(new Item(id: 1,
  desc: _descController.text,
  orderId: '1',
  phone: ' ',
  imageUrl1: this.imageUrls[0],
  imageUrl2: this.imageUrls.length == 2 ? this.imageUrls[1] : ' ',
  units : 0,
  unitPrice: 0,
  tax: 0,
  amount: 0,
  status: 'black',
  type: 'Days',
  quantity: int.parse(_daysController.text)));
    Navigator.of(ctx).pushNamed(AddPlaceScreen.routeName, arguments: {'items' : this.items,
    'images': this.images});
  }}

  _gallery() async {
  setState(() {
    imgUploaded = false;
  });
  final image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    _image = image; 

  final fileName = path.basename(_image.path);
  StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('orders/$fileName');
   StorageUploadTask uploadTask = storageReference.putFile(_image);    
   await uploadTask.onComplete;      
   storageReference.getDownloadURL().then((fileURL) {    
      _uploadedFileURL = fileURL;
       print(_uploadedFileURL)  ;
      imgUrl = _uploadedFileURL;
      setState(() {
          setState(() {
         imgUploaded = true;
        if(imageUrls.length == 2) {
       imageUrls.removeAt(0);
       imageUrls.add(imgUrl);
     } else {
       imageUrls.add(imgUrl);
     } 
  });
      });
   }); 
  }

  _oldPx() async {
    final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ListReceipts(),
    ));
    setState(() {
    if(result !=null){
    imgUploaded = true;
      if(imageUrls.length == 2) {
       imageUrls.removeAt(0);
       imageUrls.add(result);
     } else {
       imageUrls.add(result);
     } }
  });
    
  }

  _camera() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 60);
    _image = image; 
    setState(() {
    imgUploaded = false;
    });

  final fileName = path.basename(_image.path);
  StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('orders/$fileName');
   StorageUploadTask uploadTask = storageReference.putFile(_image);    
   await uploadTask.onComplete;      
   storageReference.getDownloadURL().then((fileURL) {    
      _uploadedFileURL = fileURL;
       print(_uploadedFileURL)  ;
      imgUrl = _uploadedFileURL;
    setState(() {
    imgUploaded = true;
      if(imageUrls.length == 2) {
       imageUrls.removeAt(0);
       imageUrls.add(imgUrl);
     } else {
       imageUrls.add(imgUrl);
     } 
  });
   }); 
  }
  
  void _removeImg(BuildContext ctx,String rem) {
    Navigator.of(context).pop(true);
    setState(() {
      imageUrls.remove(rem);
    });
    if(imageUrls.length == 0){
      Navigator.of(ctx).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size; 
    final routeArgs =
  ModalRoute.of(context).settings.arguments as String;
  print(routeArgs);
  if(isInit){
  imageUrl1 = routeArgs;
  imageUrls.add(imageUrl1);
  isInit = false;
  }
    return Scaffold(
      backgroundColor: Color(0xffF2EFEF),
      appBar: AppBar(
        backgroundColor: Color(0xff83BB40),
        title: Text('Retake'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: deviceSize.height * 0.03,
            ),
            Container(
              child: Row(
                children: <Widget>[
              
              // Container(
              //   width: deviceSize.width * 0.025,
              // ),
              
              // Container(
              // height: deviceSize.height * 0.32,
              // width: deviceSize.width * 0.45,            
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //      boxShadow: [
              //         new BoxShadow(
              //        color: Colors.grey,
              //         blurRadius: 3.0,
              //             ),],
              // ),
              // child: Stack(
              //   overflow: Overflow.visible,
              //   children: <Widget>[
              //     isImg1 ?  Center(child: Image.network(imageUrl1,fit: BoxFit.contain)) : Container(),
              //     Positioned(
              //       bottom: deviceSize.height * 0.3,
              //       left: deviceSize.width * 0.404,
              //   child: Container(           
              //         height: deviceSize.width * 0.08,
              //         width:  deviceSize.width * 0.08,
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //       border: Border.all(
              //      width: 1,
              //         color: Colors.red
              //         ),
              //         borderRadius: BorderRadius.circular(100) ,
              //     ),
              //     child: InkWell(
              //       onTap: () => _removeImg1(),
              //       child: Padding(
              //         padding: EdgeInsets.only(left : deviceSize.width * 0.023, top: deviceSize.width * 0.012),
              //         child: Text('X', style: TextStyle(
              //           fontSize: deviceSize.height * 0.025,
              //           color: Colors.red
              //         ),),
              //       ),
              //     )
              //     ,))
              //   ],
              // ),
              //     ),

                  Container(
                width: deviceSize.width * 0.04,
              ),

                   Container(
              height: deviceSize.height * 0.32,
              width: deviceSize.width * 0.9,            
              decoration: BoxDecoration(
                color: Colors.white,
                   boxShadow: [
                      new BoxShadow(
                     color: Colors.grey,
                      blurRadius: 3.0,
                          ),],
              ),
              child:  ListView.builder(
               scrollDirection: Axis.horizontal,
               itemBuilder: (BuildContext ctxt, int index){
               return 
                Container( 
                 height: deviceSize.height * 0.1,
                  width: deviceSize.width * 0.45,
                 child: Padding(
                   padding: EdgeInsets.all(deviceSize.width * 0.02),
                   child: Column(
                
                children: <Widget>[
                    Container(
                      height: deviceSize.height * 0.2,
                      width: deviceSize.width * 0.35,
                      child: Center(child: Image.network(imageUrls[index],fit: BoxFit.contain))),
                    Container(height: deviceSize.height * 0.03),
                    Container(           
                     height: deviceSize.width * 0.06,
                      width:  deviceSize.width * 0.15,
                        child: InkWell(
                          onTap: () => showAlert(context,imageUrls[index]),
                  child: Container(
                    child:Image.asset('lib/assets/images/deIcon.png')
                  ),
                        )
                        ,)
                ],
              ),
                 ),
                 );},
                  itemCount: imageUrls.length
                  ), 
              
              // child: Stack(
              //   overflow: Overflow.visible,
              //   children: <Widget>[
              //    isImg2 ? Image.network(imageUrl2,fit: BoxFit.cover) : Container(),
              //     Positioned(
              //       bottom: deviceSize.height * 0.3,
              //       left: deviceSize.width * 0.404,
              //   child: Container(           
              //         height: deviceSize.width * 0.08,
              //         width:  deviceSize.width * 0.08,
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //       border: Border.all(
              //      width: 1,
              //         color: Colors.red//                   <--- border width here
              //         ),
              //         borderRadius: BorderRadius.circular(100) ,
              //      //    color: Colors.red
              //     ),
              //     child: InkWell(
              //         onTap: () => _removeImg2(),
              //       child: Padding(
              //         padding: EdgeInsets.only(left : deviceSize.width * 0.023, top: deviceSize.width * 0.012),
              //         child: Text('X', style: TextStyle(
              //           fontSize: deviceSize.height * 0.025,
              //           color: Colors.red
              //         ),),
              //       ),
              //     )
              //     ,))
              //   ],
                
              // ),
                  ),
                ],
              ),
            ),

            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  top: deviceSize.height * 0.02,
                  left: deviceSize.width * 0.05
                ),
                child: Text('Total Images uploaded: ${imageUrls.length}/2', style: TextStyle(color: Color(0xff707070)),),
              ),
            ),
            Container(
              height: deviceSize.height * 0.02,
            ),

            Container(
                    height: deviceSize.height * 0.06,
                    width: deviceSize.width * 0.93,               
                    decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                   boxShadow: [
                      new BoxShadow(
                     color: Colors.grey,
                      blurRadius: 3.0,
                          ),],
                 color: Color(0xff83BB40),
                 ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          onTap: () => _gallery(),
                          child: Row(children: <Widget>[
                            Image.asset('lib/assets/images/gallery.png', height: deviceSize.height * 0.022,
                            ),
                            Text(' GALLERY', style: TextStyle(
                              color: Colors.white,
                              fontSize: deviceSize.height * 0.022)
                            ),
                          ],)
                        ),
                        Container(
                          color: Colors.white,
                          height: deviceSize.height * 0.06,
                          width: 1,
                        ),
                        InkWell(
                          onTap: () => _camera(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                            Image.asset('lib/assets/images/upCamera.png', height: deviceSize.height * 0.022,
                            ),
                            Text(' CAMERA', style: TextStyle(
                              color: Colors.white,
                              fontSize: deviceSize.height * 0.022)
                            ),
                          ],)
                        ),
                        Container(
                          color: Colors.white,
                          height: deviceSize.height * 0.06,
                          width: 1,
                        ),
                        InkWell(
                          onTap: () => _oldPx(),
                          child: Row(children: <Widget>[
                            Image.asset('lib/assets/images/upRx.png', height: deviceSize.height * 0.022,
                            ),
                            Text(' PAST RX', style: TextStyle(
                              color: Colors.white,
                              fontSize: deviceSize.height * 0.022)
                            ),
                          ],)
                        ),
                      ],
                    ),
                  ),
             Container( height: deviceSize.height * 0.04, ),
            //  Padding(
            //    padding: EdgeInsets.only(left: deviceSize.width * 0.04,
            //    bottom: deviceSize.height * 0.01),
            //    child: Container(
            //      alignment: Alignment.centerLeft,
            //      child: Text('PRESCRIPTIONS ADDED IN CART (2)', style: TextStyle(
            //                       color: Color(0xff707070),
            //                       fontSize: deviceSize.height * 0.017),
            //                     ),),
            //  ),

              Container(
                width: deviceSize.width * 0.97,
                height: deviceSize.height * 0.15,
               decoration: BoxDecoration(
                color: Colors.white,
                   boxShadow: [
                      new BoxShadow(
                     color: Colors.grey,
                      blurRadius: 3.0,
                          ),],
              ),
                child: Padding(
                  padding: EdgeInsets.only(left: deviceSize.width * 0.04, right: deviceSize.width * 0.04,
                  bottom: deviceSize.height * 0.01),
                  child: TextField(
                    decoration: InputDecoration( labelText: ' Description'),
                    controller: _descController,
                  ),
                ),
              ),
              Container(
                height: deviceSize.height * 0.012,
              ),
               Container(
                width: deviceSize.width * 0.97,
                height: deviceSize.height * 0.12,
                decoration: BoxDecoration(
                color: Colors.white,
                   boxShadow: [
                      new BoxShadow(
                     color: Colors.grey,
                      blurRadius: 3.0,
                          ),],
              ),
                child: Padding(
                  padding: EdgeInsets.only(left: deviceSize.width * 0.04, right: deviceSize.width * 0.04,
                  bottom: deviceSize.height * 0.01),
                                    child: 
                  Row(children: <Widget>[
                    Text('For'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: deviceSize.width * 0.1,
                        child: TextField(
                          keyboardType: TextInputType.number,
                        // decoration: InputDecoration( labelText: ' Number'),
                        controller: _daysController,
                  ),
                      ),
                    ),
                  Text('Days')
                  ],)                                
                ),
              ),

              Container(
                height: deviceSize.height * 0.01,
              ),
              Container(
                child: Text(err),
              ),

             ButtonTheme(
                  minWidth: double.infinity,
                  height: deviceSize.height * 0.07,
                  child: RaisedButton(
                  color: Colors.blue,
                  onPressed:
                  imgUploaded ? () => _onProceed(context) : null,
                  child: Text(imgUploaded ? "PROCEED" : "UPLOADING", 
             style: TextStyle(color: Colors.white),), 
                  ),
                ),    
          ],
        ),
      ),
      
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_shop/screens/listReceipts.dart';
import 'package:medical_shop/screens/prescriptionOrder.dart';
import 'package:medical_shop/screens/splashScreen.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

class UploadPrescription extends StatefulWidget {
  static const routeName = '/uploadPres';

  @override
  _UploadPrescriptionState createState() => _UploadPrescriptionState();
}

class _UploadPrescriptionState extends State<UploadPrescription> {
  File _image;  

  String imgUrl1;

  String _uploadedFileURL;

  bool isLoading = false;

  _gallery(BuildContext ctx) async {
  
  final image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    _image = image; 
    if(image != null) {
      setState(() {
    isLoading = true;
  });
    }

  final fileName = path.basename(_image.path);
  StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('orders/$fileName');
   StorageUploadTask uploadTask = storageReference.putFile(_image);    
   await uploadTask.onComplete;      
   storageReference.getDownloadURL().then((fileURL) {    
      _uploadedFileURL = fileURL;
       print(_uploadedFileURL)  ;
      imgUrl1 = _uploadedFileURL;
      setState(() {
    isLoading = false;
  });
        Navigator.of(ctx).pushNamed(PrescriptionOrders.routeName, arguments: _uploadedFileURL);
   }); 
  }

_oldPx(BuildContext ctx) async {
    final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ListReceipts(),
    ));
    if(result !=null){
    Navigator.of(ctx).pushNamed(PrescriptionOrders.routeName, arguments: result);}
    
  }

  _camera(BuildContext ctx) async {
    
    final image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 60);
    _image = image; 
  if(image != null) {
      setState(() {
    isLoading = true;
  });
    }
  final fileName = path.basename(_image.path);
  StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('orders/$fileName');
   StorageUploadTask uploadTask = storageReference.putFile(_image);    
   await uploadTask.onComplete;      
   storageReference.getDownloadURL().then((fileURL) {    
      _uploadedFileURL = fileURL;
       print(_uploadedFileURL)  ;
       setState(() {
    isLoading = false;
  });
      imgUrl1 = _uploadedFileURL;
        Navigator.of(ctx).pushNamed(PrescriptionOrders.routeName, arguments: _uploadedFileURL);
   }); 
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;  
    return Scaffold(
      backgroundColor: Color(0xffF2EFEF),
      appBar: AppBar(
        backgroundColor: Color(0xff83BB40),
        title: Text('Upload Prescription'),
      ),

      body: isLoading ? SplashScreen(): Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: deviceSize.height * 0.03,
          ),
          Container(
            height: deviceSize.height * 0.33,
            width: deviceSize.width * 0.95,
            color: Colors.white,
            child: Column(              
              children: <Widget>[
                Container( height: deviceSize.height * 0.03 ),
                Image.asset('lib/assets/images/rxptPres.png',),
                Container( height: deviceSize.height * 0.03 ),
                Text('Upload photo of your medical prescription', style: TextStyle( fontSize: deviceSize.height * 0.022),),
                Container( height: deviceSize.height * 0.03 ),
                Container(
                  height: deviceSize.height * 0.06,
                  width: deviceSize.width * 0.93,               
                  decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
               color: Color(0xff83BB40),
               ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () => _gallery(context),
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
                        onTap: () => _camera(context),
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
                        onTap: () => _oldPx(context),
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
                )

              ],
            )
          ),
          Container(
            height: deviceSize.height * 0.03,
          ),
          // Container(
          //   alignment: Alignment.centerLeft,
          //   child: 
          // ),
          Container(
            height: deviceSize.height * 0.4,
            width: deviceSize.width * 0.97,
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[ 
                  Text('Valid Prescription:',  style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: deviceSize.height * 0.022),
                            ),               
                  Container(height: deviceSize.height * 0.03,),
                  Image.asset('lib/assets/images/validPres.png', fit: BoxFit.cover),
                ],),
                Container(
                  width: deviceSize.width * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[              
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,deviceSize.height * 0.05,0,deviceSize.height * 0.02),
                    child: Container(
                      height: deviceSize.height * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset('lib/assets/images/success.png', height: deviceSize.height * 0.03),
                          Text('  Doctor & Clinic Details',  style: TextStyle(
                                  color: Color(0xff707070),
                                  fontSize: deviceSize.height * 0.017),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,0,0,deviceSize.height * 0.02),
                    child: Container(
                      height: deviceSize.height * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset('lib/assets/images/success.png', height: deviceSize.height * 0.03),
                          Text('  Patient Details',  style: TextStyle(
                                  color: Color(0xff707070),
                                  fontSize: deviceSize.height * 0.017),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,0,0,deviceSize.height * 0.02),
                    child: Container(
                      height: deviceSize.height * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset('lib/assets/images/success.png', height: deviceSize.height * 0.03),
                          Text('  Medicine Details',  style: TextStyle(
                                  color: Color(0xff707070),
                                  fontSize: deviceSize.height * 0.017),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,0,0,deviceSize.height * 0.02),
                    child: Container(
                      height: deviceSize.height * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset('lib/assets/images/success.png', height: deviceSize.height * 0.03),
                          Text('  Doctor Sign & Stamp',  style: TextStyle(
                                  color: Color(0xff707070),
                                  fontSize: deviceSize.height * 0.017),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],),
              ],
            ),
          ),
        ],
      ),
      
    );
  }
}
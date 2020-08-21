
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_shop/models/item.dart';
import 'package:medical_shop/screens/ImgOrder.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

class Prescription extends StatefulWidget {
static const routeName = '/prescription';
   
  @override
  _PrescriptionState createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {  
  
  File _image;  
  String imgUrl1;
  String imgUrl2;
  String _uploadedFileURL;
  final _titleController = TextEditingController();
  int imgCnt = 0;
  int qty = 1;
  String desc;
  bool imgAdded = false;
  Color btnclr = Color(0xff83BB40);
  final List<Map<String,String>> imageInfos = [];

  Future<void> getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      
      this.btnclr = Colors.grey;
      this.imgAdded = false;
    });

  final fileName = path.basename(_image.path);
  String imageName = 'Image ${this.imgCnt}';
  print('It is $fileName');
  StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('orders/$fileName');  
  print('fuond db');  
   StorageUploadTask uploadTask = storageReference.putFile(_image);    
   await uploadTask.onComplete;    
   print('File Uploaded');    
   storageReference.getDownloadURL().then((fileURL) {    
     setState(() {    
       _uploadedFileURL = fileURL;
       print(_uploadedFileURL)  ;
       this.imgAdded = true;
       imgCnt++;

       if(imgCnt == 1) {      
        imgUrl1 = _uploadedFileURL;
       } else {
        imgUrl2 = _uploadedFileURL;
       }
       imageInfos.add({
         'image': imageName,
         'Url' : _uploadedFileURL
       });  
     });    
   }); 

  }

  void add() {
   setState(() {
     qty++;
   });
 }

void minus() {
   setState(() {
     qty--;
   });
 }

void _submitPic(BuildContext ctx)  {
  final Item id = new Item(
    phone : ' ',
    type : 'l',
    units: 0,
    unitPrice: 0,
    tax: 0,
    amount: 0,
    desc:  this._titleController.text ,
    quantity: this.qty,
    imageUrl1: this.imgUrl1,
    imageUrl2: this.imgUrl2,
    status: 'black',
    orderId: '1',
    id: 1
  );
   Navigator.of(ctx).pushReplacementNamed(ImgOrder.routeName, arguments: id);
}

Widget build(BuildContext context) {

final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Color(0xffF2EFEF),
      

      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
     
      appBar: AppBar(
        
        title: Text('Add Prescription', style: TextStyle(
          fontSize: deviceSize.height * 0.025
        ),),
        backgroundColor: Color(0xff83BB40),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
             Container(
                height: deviceSize.height * 0.02,
            ),
            Card(
              elevation: 10,
              child: Container(
              height: deviceSize.height * 0.55,
              width: deviceSize.width * 0.9,
                child: Center(
                child: _image == null
                    ? RaisedButton.icon(
                  icon: Icon(Icons.camera_enhance, color: Colors.white,),
                  color: Color(0xff83BB40),
                  onPressed: getImage,
                  label: Text('Add', style: TextStyle(color: Colors.white),),
                  )
                    : Container(
                      height: deviceSize.height * 0.5,
                      child: Image.file(_image, fit: BoxFit.contain,)),
          ),
              ),
            ),
             Container(
           height: deviceSize.height * 0.055,
            ),
             Card(
               child: Container(
                 height: deviceSize.height * 0.13,
                 width: deviceSize.width * 0.9,
                 child: Padding(
                   padding: const EdgeInsets.all(4.0),
                   child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                        Container(
                          width : 10
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration( labelText: '  Product Description         '),
                            controller: _titleController,
                          ),
                        ),
                        Container(
                          width : 10
                        ),
                        ButtonTheme(
                           minWidth: 5.0,
                          height: 5.0,
                          child: RaisedButton(
                           color: Color(0xff83BB40),
                          shape: CircleBorder(),
                          onPressed:  qty > 1 ? minus : null, 
                          child: Text("-", style: TextStyle(color: Colors.white),),
                           ),
                          ),
                              Text('$qty'),
                           ButtonTheme(
                          minWidth: 5.0,
                          height: 5.0,
                          child: RaisedButton(
                           color: Color(0xff83BB40),
                           shape: CircleBorder(),
                          onPressed: qty<20 ? add : null,
                          child: Text("+", style: TextStyle(color: Colors.white),),
                           ),
                          ),
                            ],),
                 ), 
               ),
             ),
              Container(
                height: deviceSize.height * 0.05,
            ),
              ButtonTheme(
                minWidth: double.infinity,
                height: deviceSize.height * 0.07,
                child: RaisedButton(
                color: Colors.blue,
                onPressed: () => _submitPic(context) , 
                child: Text("PROCEED",
                style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
            
          ),
      ),    
      );
  }
}
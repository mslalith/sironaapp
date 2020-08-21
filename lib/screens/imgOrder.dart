import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medical_shop/models/item.dart';
import 'package:medical_shop/models/person.dart';
import 'package:medical_shop/screens/addPlaceScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

class ImgOrder extends StatefulWidget {
  static const routeName = '/imgOrder';
  @override
  _ImgOrderState createState() => _ImgOrderState();
}

class _ImgOrderState extends State<ImgOrder> {

int itemCnt = 0;
bool addImg = true;
bool imgAdded = true;
Person person;
List<Item> items = [];
List<Map<String, dynamic>> images = [];
final _titleController = TextEditingController();
int qty = 1;
bool itemadded = false;
String itemDesc = '';
bool isInit = true;



String err = ' ';

File _image;  
String imgUrl1;
String _uploadedFileURL;
Color btnclr = Color(0xff83BB40);
  final List<Map<String,String>> imageInfos = [];

  Future<void> getImage() async {
     setState(() {
      addImg = true;
    });
    final image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 60);
    setState(() {
      _image = image; 
      this.btnclr = Colors.grey;
      this.imgAdded = false;
      this.isInit = false;
      imgAdded = false;
    });

  final fileName = path.basename(_image.path);
  StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('orders/$fileName');
   StorageUploadTask uploadTask = storageReference.putFile(_image);    
   await uploadTask.onComplete;      
   storageReference.getDownloadURL().then((fileURL) {    
     setState(() {    
       _uploadedFileURL = fileURL;
       print(_uploadedFileURL)  ;
       this.imgAdded = true;
       isInit = false;
      imgUrl1 = _uploadedFileURL;
       imageInfos.add({
         'image': ' ',
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

  void addItem() { 

    print(_titleController.text);

    if( _titleController.text.trim() == '' || _titleController.text.length < 4 ) {
      setState(() {
        err = 'please fill min 4 chars';
      });     
      return;
    } else {

    setState(() {

   addImg = false;
    
    
  this.items.add(new Item(id: 1,
  desc: _titleController.text,
  orderId: '1',
  phone: ' ',
  imageUrl1: imgUrl1,
  imageUrl2: imgUrl1,
  type: 'l',
  units: 0,
  unitPrice: 0,
  tax: 0,
  amount: 0,
  status: 'black',
  quantity: qty));
  _image = null;
      
    itemCnt++;
    print(imgUrl1.length);
    imgUrl1 = ' ';
    if(itemadded) {
      this.itemDesc = this.itemDesc + '$itemCnt. ${_titleController.text} Quantity:$qty \n';
      this._titleController.text = '';
      this.qty = 1;
    } else {
      this.itemDesc = '$itemCnt. ${_titleController.text} Quantity:$qty \n' ;
      itemadded = true;
      this._titleController.text = '';
      this.qty = 1;
    };
    });

    }
  }

  void addImage() {
    setState(() {
      addImg = true;
    });
     getImage();
  }

  void showAlert(id) async {
  final bool res = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirm"),
        content: const Text("Are you sure you wish to delete this item?"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("DELETE")
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("CANCEL"),
          ),
        ],
      );
    },
  );

  if (res) {
    setState(() {
      itemCnt--;
      items.remove(id);

      if(this.itemCnt == 0) {
          getImage();
      }
    });   
  }
    }

  void _onProceed(BuildContext ctx) {
    print(this.itemDesc);
    Navigator.of(ctx).pushNamed(AddPlaceScreen.routeName, arguments: {'items' : this.items,
    'images': this.images});
  }

  @override
  Widget build(BuildContext context) {


     final deviceSize = MediaQuery.of(context).size;
     if(this.isInit) {
     getImage();
     }

    return Scaffold(
        backgroundColor: Color(0xffF2EFEF),
 

      appBar: AppBar(
        title: addImg ? Text('Retake') : Text('Add Prescription'),
              backgroundColor: Color(0xff83BB40),
        leading: addImg ? GestureDetector(
          child: Icon(Icons.camera_alt),
          onTap: getImage
        ) : null,
      ),

      body:  Container(
        child: addImg ? SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
             
              children: <Widget> [
                 Container(
                   height: deviceSize.height * 0.04,
                 ),
                 Container(
                   decoration: BoxDecoration(
                  boxShadow: [
                        new BoxShadow(
                       color: Colors.black,
                        blurRadius: 5.0,
                            ),],
                          borderRadius: BorderRadius.circular(4) ,
                         color: Colors.white
                   ),
                   height: deviceSize.height * 0.575,
                   width: deviceSize.width * 0.9,
                   child: _image == null ? Center(child: Text('Loading'))
                   : Image.file(_image, fit: BoxFit.cover,),
                 ),
                 Container(
                   height: deviceSize.height * 0.04,
                 ),
                 Container(
                   decoration: BoxDecoration(
                  boxShadow: [
                        new BoxShadow(
                       color: Colors.black,
                        blurRadius: 2.0,
                            ),],
                          borderRadius: BorderRadius.circular(4) ,
                         color: Colors.white
                   ),
                   width: deviceSize.width * 0.9,
                   height: deviceSize.height * 0.1,
                   child: Row(
               //        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: <Widget>[
                       Text('  ${itemCnt+1}. ', style: TextStyle(fontSize: deviceSize.height * 0.02),),
                       Flexible(
                         child: TextField(
                           decoration: InputDecoration( labelText: '  Product Description         '),
                           controller: _titleController,
                         ),
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
                 Container(
                   height: deviceSize.height * 0.05,
                 )
                , Text('$err',
                  style: TextStyle(color: Colors.red),),
                   ButtonTheme(
                           minWidth: double.infinity,
                          height: 50,
                          child: RaisedButton(
                           color: Colors.blue,
                          onPressed: imgAdded ? addItem : null, 
                          child: Text(imgAdded ? "PROCEED" : "UPLOADING" ,
                          style: TextStyle(color: Colors.white),),
                           ),
                          ),
                ],),

          ),
        )
           
           : Center(
             child: Container(
               child: Column(
           //      mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                    RaisedButton.icon(
                  onPressed: getImage, icon: Icon(Icons.add, color: Colors.white,), label: Text('Add Prescription', style: TextStyle(color: Colors.white),),
                color: Color(0xff83BB40),
                ),
                Container(
                  height: deviceSize.height * 0.05,
                ),
                Padding(
            padding: EdgeInsets.fromLTRB(deviceSize.width * 0.05, deviceSize.height * 0.02, 0, deviceSize.width * 0.05),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text('ITEMS ADDED IN CART ($itemCnt)', style: TextStyle(
                fontSize: deviceSize.height * 0.023,
                color: Colors.grey
              ),)),
          ), 
                 Flexible(
                  flex: 2,
                  child: itemCnt != 0 ? 
              //
              ListView.builder(
    itemCount: itemCnt,
    itemBuilder: (context,index){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Container(
        decoration: BoxDecoration(
                  boxShadow: [
                        new BoxShadow(
                       color: Colors.black,
                        blurRadius: 2.0,
                            ),],
                          borderRadius: BorderRadius.circular(4) ,
                         color: Colors.white
                   ),
                   width: deviceSize.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
            padding: EdgeInsets.all(10),
            child:
            Text('${index+1}. ', style: TextStyle(fontSize: deviceSize.height * 0.025),
            textAlign: TextAlign.start,),
            ),
            Container(
              width: 30,
              height: 30,
              child: InkWell(
                onTap: () async {
                   await showDialog(
                context: context,
                builder: (_) => ImageDialog(items[index].imageUrl1)
              ); },
                child: Image.network('${items[index].imageUrl1}',
                fit: BoxFit.cover),
              ),
            ),
            Expanded(
            child:
            Text('  ${items[index].desc}'
            , style: TextStyle(fontSize: deviceSize.height * 0.025),) 
            ),
             Container(
               padding: EdgeInsets.all(10),
               child:
            Text('${items[index].quantity}'
            , style: TextStyle(fontSize: deviceSize.height * 0.025),)
            ),
            IconButton(icon: Icon(Icons.delete) , onPressed: () => showAlert(items[index])  
        ,)
          ],
        )
      ),
    ) ; 
            })
              //
                  : Container(child: Text('No Items Added Yet'))),
                                     
                  ButtonTheme(
                   minWidth: double.infinity,                    height: 50,
             child: RaisedButton(
                             color: Colors.blue,
                            onPressed: itemCnt !=0 ? 
                            imgAdded ? () => _onProceed(context) : null
                            :  null, 
                            child: Text(imgAdded ? "PROCEED" : "UPLOADING", 
                            style: TextStyle(color: Colors.white),),
                             ),
                            ),

          ],),
             ),
           ),
      ),
      
    );
  }
}

class ImageDialog extends StatelessWidget {
  final imageUrl;
  ImageDialog(this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        child: Image.network('$imageUrl', 
        fit: BoxFit.cover,),
        ),
      );
  }
}
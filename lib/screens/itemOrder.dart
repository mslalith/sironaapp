import 'package:flutter/material.dart';
import 'package:medical_shop/models/item.dart';
import 'package:medical_shop/models/person.dart';
import 'package:medical_shop/providers/units.dart';
import 'package:medical_shop/screens/addPlaceScreen.dart';
import 'package:provider/provider.dart';

class ItemOrder extends StatefulWidget {
  static const routeName = '/itemOrder';
  @override
  _ItemOrderState createState() => _ItemOrderState();
}

class _ItemOrderState extends State<ItemOrder> {
  int itemCnt = 0;
  Person person;
  List<Item> items = [];
// List<String> units = [];
  List<Map<String, dynamic>> images = [];
  final _titleController = TextEditingController();
  final _qtyController = TextEditingController();
  int qty = 1;
  bool itemadded = false;
  String itemDesc = '';
  String dropdownValue;

  String err = ' ';

  void add() {
    setState(() {
      qty = int.parse(_qtyController.text);
      qty++;
      _qtyController.text = '$qty';
    });
  }

  void minus() {
    setState(() {
      qty = int.parse(_qtyController.text);
      qty--;
      _qtyController.text = '$qty';
    });
  }

  void addItem() {
    if (_titleController.text.trim() == '' ||
        _titleController.text.length < 4) {
      setState(() {
        err = 'Item should be min 4 characters';
      });

      return;
    } else {
      qty = int.parse(_qtyController.text);
      if (qty <= 0) {
        setState(() {
          err = 'Please check the quantity';
        });
      } else {
        setState(() {
          err = '';
          this.items.add(
                Item(
                    id: 2,
                    desc: _titleController.text,
                    orderId: '1',
                    phone: ' ',
                    status: 'black',
                    imageUrl1: ' ',
                    imageUrl2: ' ',
                    type: dropdownValue == null ? ' N/A' : dropdownValue,
                    units: 0,
                    unitPrice: 0,
                    tax: 0,
                    amount: 0,
                    quantity: qty),
              );

          itemCnt++;
          if (itemadded) {
            this.itemDesc = this.itemDesc +
                '$itemCnt. ${_titleController.text} Quantity:$qty \n';
            this._titleController.text = '';
            this.qty = 1;
            this._qtyController.text = '0';
          } else {
            this.itemDesc =
                '$itemCnt. ${_titleController.text} Quantity:$qty \n';
            itemadded = true;
            this._titleController.text = '';
            this.qty = 1;
            this._qtyController.text = '0';
          }
        });
      }
    }
  }

  void _onProceed(BuildContext ctx) {
    print(this.itemDesc);
    Navigator.of(ctx).pushNamed(
      AddPlaceScreen.routeName,
      arguments: {'items': this.items, 'images': this.images},
    );
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
              child: const Text("DELETE"),
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final unitsData = Provider.of<UnitList>(context);
    final units = unitsData.getUnits;
    // dropdownValue = units[0];
    print(dropdownValue);
    return Scaffold(
      backgroundColor: Color(0xffF2EFEF),
      appBar: AppBar(
        title: Text('Add Prescription'),
        backgroundColor: Color(0xff83BB40),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: deviceSize.height * 0.03,
            ),
            Container(
              height: deviceSize.height * 0.2,
              width: deviceSize.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Color(0xff707070),
                    blurRadius: 2.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: deviceSize.width * 0.55,
                        child: Row(
                          children: <Widget>[
                            Text(
                              '  ${itemCnt + 1}. ',
                              style: TextStyle(
                                fontSize: deviceSize.height * 0.02,
                              ),
                            ),
                            Flexible(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: '  Product Description         ',
                                ),
                                controller: _titleController,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: deviceSize.width * 0.05,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: deviceSize.height * 0.01),
                        child: Container(
                          width: deviceSize.width * 0.2,
                          height: deviceSize.height * 0.05,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0xffF5F5F5),
                          ),
                          child: Center(
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              style: TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 0,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: units.map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: Color(0xff707070),
                                        fontSize: deviceSize.height * 0.02,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ),
                      Container(),
                      Row(
                        children: <Widget>[
                          ButtonTheme(
                            minWidth: 5.0,
                            height: 5.0,
                            child: RaisedButton(
                              color: Color(0xff83BB40),
                              shape: CircleBorder(),
                              onPressed: qty > 1 ? minus : null,
                              child: Text(
                                "-",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            width: deviceSize.width * 0.1,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _qtyController,
                            ),
                          ),
                          ButtonTheme(
                            minWidth: 5.0,
                            height: 5.0,
                            child: RaisedButton(
                              color: Color(0xff83BB40),
                              shape: CircleBorder(),
                              onPressed: add,
                              child: Text(
                                "+",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: deviceSize.height * 0.015,
                      ),
                      Container(
                        width: deviceSize.width * 0.18,
                        height: deviceSize.height * 0.04,
                        decoration: BoxDecoration(
                          color: Color(0xff83BB40),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: InkWell(
                          onTap: addItem,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: deviceSize.width * 0.04,
                                height: deviceSize.width * 0.04,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                      color: Color(0xff83BB40),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      //     ButtonTheme(

                      //       child: RaisedButton.icon(onPressed: addItem,
                      //        icon: Icon(Icons., color: Colors.white,), label: Text('Add', style: TextStyle(color: Colors.white),),
                      //      color: Color(0xff83BB40),
                      // ),
                      //     )
                    ],
                  )
                ],
              ),
            ),
            // Row(
            // children: <Widget>[
            //   Flexible(
            //   child: Padding(
            //     padding: const EdgeInsets.all(10.0),
            //     child: Container(
            //       decoration: BoxDecoration(
            //       boxShadow: [
            //             new BoxShadow(
            //            color: Colors.black,
            //             blurRadius: 2.0,
            //                 ),],
            //               borderRadius: BorderRadius.circular(4) ,
            //              color: Colors.white
            //        ),
            //        width: deviceSize.width * 0.9,
            //        height: deviceSize.height * 0.1,
            //       child:
            //       Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: <Widget>[
            //           Text('  ${itemCnt+1}. ', style: TextStyle(fontSize: deviceSize.height * 0.02),),
            //           Flexible(
            //             child: TextField(
            //               decoration: InputDecoration( labelText: '  Product Description         '),
            //               controller: _titleController,
            //             ),
            //           ),
            //             ButtonTheme(
            //                minWidth: 5.0,
            //               height: 5.0,
            //               child: RaisedButton(
            //                color: Color(0xff83BB40),
            //               shape: CircleBorder(),
            //               onPressed:  qty > 1 ? minus : null,
            //               child: Text("-", style: TextStyle(color: Colors.white),),
            //                ),
            //               ),
            //             Container(
            //               width: deviceSize.width * 0.1,
            //               child:TextField(
            //                    keyboardType: TextInputType.number,
            //               controller: _qtyController,
            //             ),),
            //                ButtonTheme(
            //               minWidth: 5.0,
            //               height: 5.0,
            //               child: RaisedButton(
            //                color: Color(0xff83BB40),
            //                shape: CircleBorder(),
            //               onPressed: add,
            //               child: Text("+", style: TextStyle(color: Colors.white),),
            //                ),
            //               ),
            //               ],),
            //         ),
            //   ),
            // ),
            // ],),
            Text(
              '$err',
              style: TextStyle(color: Colors.red),
            ),
            // RaisedButton.icon(onPressed: addItem, icon: Icon(Icons.add, color: Colors.white,), label: Text('Add', style: TextStyle(color: Colors.white),),
            // color: Color(0xff83BB40),
            // ),
            Container(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                deviceSize.width * 0.05,
                deviceSize.height * 0.02,
                0,
                deviceSize.width * 0.05,
              ),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ITEMS ADDED IN CART ($itemCnt)',
                  style: TextStyle(
                    fontSize: deviceSize.height * 0.017,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: itemCnt != 0
                  ? ListView.builder(
                      itemCount: itemCnt,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        '${index + 1}.',
                                        style: TextStyle(
                                          fontSize: deviceSize.height * 0.025,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${items[index].desc}',
                                        style: TextStyle(
                                          fontSize: deviceSize.height * 0.025,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Image.asset(
                                        'lib/assets/images/deIcon.png',
                                      ),
                                      onPressed: () => showAlert(items[index]),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    deviceSize.width * 0.085,
                                    0,
                                    deviceSize.width * 0.2,
                                    0,
                                  ),
                                  child: Container(
                                    height: 0.5,
                                    width: double.infinity,
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(width: deviceSize.width * 0.06),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        '${items[index].quantity}',
                                        style: TextStyle(
                                          fontSize: deviceSize.height * 0.019,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        '${items[index].type}',
                                        style: TextStyle(
                                          fontSize: deviceSize.height * 0.019,
                                          color: Color(0xffA2A2A2),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Container(),
            ),

            ButtonTheme(
              minWidth: double.infinity,
              height: 50,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: itemCnt != 0 ? () => _onProceed(context) : null,
                child: Text(
                  "PROCEED",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

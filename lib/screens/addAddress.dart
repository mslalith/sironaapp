import 'package:flutter/material.dart';

class AddAddress extends StatefulWidget {
  static const routeName = '/addAddress';
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Address')),
      body: Column(       
      ),
    );
  }
}
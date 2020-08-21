import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_shop/providers/profile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

class ReferPage extends StatefulWidget {
  static const routeName = '/referandearn';

  @override
  _ReferPageState createState() => _ReferPageState();
}

class _ReferPageState extends State<ReferPage> {
  bool _visible = false;
  String _platformVersion = 'Unknown';

  void setCoupon() {
    setState(() {
      _visible = true;
    });
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      this._platformVersion = platformVersion;
    });
  }

  sendMessage(String code) {
    String message =
        'Get an additional off on your first medicine order with SIRONA Pharmacy. Use Code : ' +
            code +
            ', Click shorturl.at/hwG27 to download the app!';
    FlutterOpenWhatsapp.sendSingleMessage("", "$message");
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    var code = Provider.of<Profile>(context).refCode;
    var reds = Provider.of<Profile>(context).refCount;
    return Scaffold(
        //   backgroundColor: Color(0xffF2EFEF),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xff83BB40),
          title: Text('Refer and Earn'),
        ),
        body: Padding(
            padding: EdgeInsets.all(0.0),
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(height: deviceSize.height * 0.01),
                  Container(
                      height: deviceSize.height * 0.22,
                      width: double.infinity,
                      child: Image.asset('lib/assets/images/referral.png',
                          fit: BoxFit.contain)),
                  Container(height: deviceSize.height * 0.03),
                  Container(
                      height: deviceSize.height * 0.03,
                      child: Text('HAPPINESS IS GIVING',
                          style: TextStyle(fontWeight: FontWeight.w700))),
                  Container(height: deviceSize.height * 0.02),
                  Container(
                    height: deviceSize.height * 0.1,
                    width: deviceSize.width * 0.8,
                    child: Text(
                        'Refer a friend and get an additional 2% off on your next order and your friend gets additional 2% off on their 1st order. Lets Give Away! '),
                  ),
                  Container(height: deviceSize.height * 0.02),
                  Container(
                    color: Color(0xff83BB40),
                    height: deviceSize.height * 0.05,
                    width: deviceSize.width * 0.85,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(width: deviceSize.width * 0.1),
                        Text(
                          'REFFERAL CODE: ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Container(width: deviceSize.width * 0.18),
                        Text(
                          '$code',
                          style: TextStyle(color: Colors.white),
                        ),
                        Container(width: deviceSize.width * 0.03),
                        // Container(
                        //   child: _visible ? Center(child: Text('Copied', style: TextStyle(color: Colors.white), ))  : IconButton(icon: Icon(Icons.content_copy), onPressed: () => setCoupon(), iconSize: deviceSize.height * 0.02 , color: Colors.white,)),
                      ],
                    ),
                  ),
                  Container(height: deviceSize.height * 0.02),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: <Widget>[

                  //   Container(child: Center(child: Text('*Tap to Copy the Code'))),
                  //   Container(
                  //   width: deviceSize.width * 0.01
                  // ),
                  Text(
                    'No of redemptions available : $reds',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: deviceSize.height * 0.022),
                  ),
                  Text(
                    '(Only one redemption will be applied per order)',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    height: deviceSize.height * 0.275,
                  ),

                  ButtonTheme(
                    minWidth: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      color: Color(0xff83BB40),
                      onPressed: () => sendMessage(code),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: deviceSize.width * 0.2,
                          ),
                          Icon(Icons.share, color: Colors.white),
                          Container(
                            width: deviceSize.width * 0.03,
                          ),
                          Text(
                            "SHARE IN WHATSAPP",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}

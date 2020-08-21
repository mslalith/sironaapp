
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical_shop/providers/profile.dart';
import 'package:medical_shop/screens/addProfile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {

static const BACKURL = 'http://Sirona-env.eba-zb3yegkm.ap-south-1.elasticbeanstalk.com' ;
//static const BACKURL = 'http://10.0.2.2:3000';

  String _token;
  bool _userStat=false;
  String _number;
  DateTime _expiryDate;
  String _userId;
  Timer authTimer;

bool get userStat{
  return _userStat;
}

Future<void> setTken(String tkn, String number) async {
  this._token = tkn;
  this._number = number;
  this._userId = this._number;
  _expiryDate = DateTime.now().add(Duration(seconds: 7200),);

    notifyListeners();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences pref = await _prefs;
    _prefs.then((pref) {
          final userData = json.encode({
         'token' : _token ,
         'userId' : _userId ,
         'expiryDate' : _expiryDate.toIso8601String()
         });
        print(userData);
        pref.setString('userData', userData);
        });
  notifyListeners();
}

String get number {
  return _number;
}

bool get isUser {
  return _userStat;
}

bool get isAuth {
return _token != null;
//return true;
}

String get token {

  if( _token != null ) {
    return _token;
  }
  return null;
}

String get userId {

  if( _token != null && _expiryDate !=null && _expiryDate.isAfter(DateTime.now())) {
    return _userId;
  }
  return null;
}


Future<bool> checkUser(String email) async {
  this._number = email;
  const url = '$BACKURL/api/profile/getProfile';
  print(email);

  final response = await http.post(url, 
  headers: {"Content-Type": "application/json"},
  body: json.encode({'phone': _number}));
  final udata = json.decode(response.body);
  print(udata);
  if(udata['message'] == 'profile retrieved') {
    this._userStat = true;
    print('user exists');
    notifyListeners();
    return true;
  }
  return false;
}

Future<bool> signUp(String password, BuildContext ctx) async {
  var ipwd = password;

  const url = '$BACKURL/api/user/signup';

  final response = await http.post(url, 
  headers: {"Content-Type": "application/json"},
  body: json.encode({'email': this._number, 'password': ipwd}));
  final userMap = jsonDecode(response.body) as Map<String,dynamic> ;

  if(userMap['message'] == 'User Added Succesfully') {
    this._token = userMap['token'];
    this._userId = this._number;
    _expiryDate = DateTime.now().add(Duration(seconds: 7200),);
    notifyListeners();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences pref = await _prefs;
        _prefs.then((pref) {
          final userData = json.encode({
         'token' : _token ,
         'userId' : _userId ,
         'expiryDate' : _expiryDate.toIso8601String()
         });
        print(userData);
        pref.setString('userData', userData);
        });
    return true;
  } else {
    notifyListeners();
    return false;
  }
}

Future<bool> signIn(String password, BuildContext context) async {

  var ipwd = password;

  const url = '$BACKURL/api/user/login';
  print(this._number);
  print(url);

    final sresponse = await http.post(url, 
       headers: {"Content-Type": "application/json"},
       body: json.encode({'email': this._number, 'password': ipwd}));
      final userMap = jsonDecode(sresponse.body) as Map<String,dynamic> ;

  if(userMap['message'] == 'No user') {
    notifyListeners();
    return false;
  } else {
    this._token = userMap['token'];
    this._userId = this._number;
    _expiryDate = DateTime.now().add(Duration(seconds: 7200),);
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences pref = await _prefs;
        _prefs.then((pref) {
          final userData = json.encode({
         'token' : _token ,
         'userId' : _userId ,
         'expiryDate' : _expiryDate.toIso8601String()
         });
        print(userData);
        pref.setString('userData', userData);
        });
    notifyListeners();
    return true;
  }
}

Future<bool> updPin(String password, BuildContext ctx) async {
  var ipwd = password;

  const url = '$BACKURL/api/user/updPin';

  final response = await http.post(url, 
  headers: {"Content-Type": "application/json"},
  body: json.encode({'email': this._number, 'password': ipwd}));
  final userMap = jsonDecode(response.body) as Map<String,dynamic> ;

  if(userMap['message'] == 'User Updated Succesfully') {
    this._token = userMap['token'];
    this._userId = this._number;
    _expiryDate = DateTime.now().add(Duration(seconds: 7200),);
    notifyListeners();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences pref = await _prefs;
        _prefs.then((pref) {
          final userData = json.encode({
         'token' : _token ,
         'userId' : _userId ,
         'expiryDate' : _expiryDate.toIso8601String()
         });
        print(userData);
        pref.setString('userData', userData);
        });
    return true;
  } else {
    notifyListeners();
    return false;
  }

}


Future<bool> tryAutoLogin(BuildContext ctx) async {
  print('here to check pref');
  final prefs = await SharedPreferences.getInstance();
  if(!prefs.containsKey('userData')){
    print('didnt find key');
    return false;
  }
  final userData = json.decode(prefs.getString('userData')) as Map<String,Object>;
  _token = userData['token'];
  print('found key');
  final expiryDate = DateTime.parse(userData['expiryDate']);
   this._token = userData['token'];
  this._userId = userData['userId'];
  this._number = this._userId;
  print(expiryDate);
  if (_userId == null){
    return false;
  }
  // this._token = userData['token'];
  // this._userId = userData['userId'];
  bool profCheck = await checkUser(this._userId) ;
  if(profCheck){
  Provider.of<Profile>(ctx,  listen: false).getProfiles(this._userId);
  this._expiryDate = DateTime.parse(userData['expiryDate']);
  notifyListeners();
  return true;
  } else {
  logout();
  return false;
  }
}

Future<void> logout() async {

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
final SharedPreferences pref = await _prefs;
pref.remove('userData');

_token = null;
_userId = null;
_expiryDate = null;
if(authTimer !=null){
 authTimer.cancel();
}
authTimer = null;
notifyListeners();
}

void autoLogout() {
  if(authTimer != null){
    authTimer.cancel();
  }
  final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
  authTimer = Timer (Duration(
    seconds: timeToExpiry
    ), logout);
}
}
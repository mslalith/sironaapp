import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:medical_shop/models/person.dart';
import 'package:http/http.dart' as http;
import 'package:medical_shop/providers/auth.dart';

class Profile with ChangeNotifier {
  static const BACKURL =
      'http://Sirona-env.eba-zb3yegkm.ap-south-1.elasticbeanstalk.com';
//static const BACKURL = 'http://10.0.2.2:3000';

  Person uProfile;
  String id;
  String authToken;
  String userId;

  String get refCode {
    return uProfile.code;
  }

  int get refCount {
    return uProfile.refcount;
  }

  set auth(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

  String get getName {
    return uProfile.name;
  }

  Person get getProfile {
    return this.uProfile;
  }

  String get getNumber {
    return 'uProfile.phone';
  }

  Person get getPerson {
    return uProfile;
  }

  Future<bool> getProfiles(String number) async {
    final url = '$BACKURL/api/profile/getProfile';

    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'phone': number}));

    var data = jsonDecode(response.body);

    if (data['message'] == "No user") {
      this.uProfile = null;
      return false;
    } else {
      var udata = data['profile'];
      print('convrting profile');
      print(udata[0]);
      this.uProfile = Person.fromJson(udata[0]);
      print(uProfile.name);
      notifyListeners();
      return true;
    }
  }

  Future<void> putProfile(Person newPerson) async {
    final url = '$BACKURL/api/profile/putProfile';
    final url2 = '$BACKURL/api/profile/incRefcode';
    var sCode = newPerson.code;
    print('here to put profile');

    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'name': newPerson.name,
          'phone': newPerson.phone,
          'email': newPerson.email,
        }));
    if (sCode != null && sCode.trim().length > 0) {
      final response2 = await http.post(url2,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'code': sCode,
          }));
    }
    this.uProfile = newPerson;
    notifyListeners();
  }

  Future<void> updProfile(Person newPerson) async {
    final url = '$BACKURL/api/profile/updProfile';

    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'name': newPerson.name,
          'phone': newPerson.phone,
          'email': newPerson.email
        }));
    this.uProfile = newPerson;
    var udata = json.decode(response.body);
    notifyListeners();
  }
}

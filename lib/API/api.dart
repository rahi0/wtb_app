import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  // LOCAL
  final String picUrl1 = 'https://mobile.tradelounge.co/';
  //
  final String picUrl = 'https://mobile.tradelounge.co/';
  final String _url = 'https://mobile.tradelounge.co/app/mobile/';
  // final String baseUrl = 'http://backoffice.localhost';

  // PRODUCTION
  //final String _url = 'http://192.168.0.100:8080/';
  // final String baseUrl = 'http://backoffice.forehand.se';

  postData1(data, apiUrl) async {
    var apiMainUri = _url + apiUrl + await _getToken2();
    return await http.post(apiMainUri,
        body: jsonEncode(data), headers: _setHeaders());
  }

  postData(data, apiUrl) async {
    var apiMainUri = _url + apiUrl;
    return await http.post(apiMainUri,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var apiMainUri = _url + apiUrl + await _getToken();
    print(apiMainUri);
    return await http.get(apiMainUri, headers: _setHeaders());
  }

  getData2(apiUrl) async {
    var apiMainUri = _url + apiUrl + await _getToken2();
    print(apiMainUri);
    return await http.get(apiMainUri, headers: _setHeaders());
  }

   getData3(apiUrl) async {
    var apiMainUri = _url + apiUrl ;
    print(apiMainUri);
    return await http.get(apiMainUri, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // _getToken() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var token = localStorage.getString('token');
  //   return '?v=1&token=$token';
  // }

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '&token=$token';
  }

  _getToken2() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }
}

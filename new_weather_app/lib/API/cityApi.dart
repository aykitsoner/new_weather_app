import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class CityApi {
  dynamic getCity() async {
    String url = "https://countriesnow.space/api/v0.1/countries";
    final response = await http.get(Uri.parse(url));
    print(response.statusCode);
    responseCity = json.decode(response.body);
    print(responseCity['data'].length);

    for (var i = 0; i < responseCity['data'].length; i++) {
      cities.add(responseCity['data'][i]['cities']);
      for (var j = 0; j < responseCity['data'][i]['cities'].length; j++) {
        allcities.add(responseCity['data'][i]['cities'][j]);
      }
    }
    print('Şehir sayısı:' + allcities.length.toString());
  }
}

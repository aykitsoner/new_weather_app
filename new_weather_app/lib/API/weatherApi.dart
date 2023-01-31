import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_weather_app/utils/constants.dart';

class WeatherApi {
  static const apiKey = "c3f7bfc124mshd5b528462507339p174611jsn516c18cdb181";

  static Map<String, String> headers = {
    "X-RapidAPI-Key": apiKey,
    "X-RapidAPI-Host": "rapidweather.p.rapidapi.com",
  };
  dynamic getWeather(
      {String? endpoint, required Map<String, String> query}) async {
    endpoint = 'data/2.5/forecast';
    Map<String, dynamic> parameters = {
      "lat": query['lat'],
      "lon": query['lon'],
    };

    Uri uri = Uri.https("rapidweather.p.rapidapi.com", endpoint, parameters);
    final response = await http.get(uri, headers: headers);
    print(response);
    print(response.statusCode);
    weatherData = jsonDecode(response.body);
    //print(weatherData);
  }

  dynamic getWeatherCity(
      {String? endpoint, required Map<String, String> query}) async {
    endpoint = 'data/2.5/forecast';
    Map<String, dynamic> parameters = {
      "q": query['q'],
    };

    Uri uri = Uri.https("rapidweather.p.rapidapi.com", endpoint, parameters);
    final response = await http.get(uri, headers: headers);
    print(response);
    print(response.statusCode);
    weatherData = jsonDecode(response.body);

    // print(weatherData);
  }

  dynamic getWeatherCityFav(
      {String? endpoint, required Map<String, String> query}) async {
    endpoint = 'data/2.5/forecast';
    Map<String, dynamic> parameters = {
      "q": query['q'],
    };

    Uri uri = Uri.https("rapidweather.p.rapidapi.com", endpoint, parameters);
    final response = await http.get(uri, headers: headers);
    print(response);
    print(response.statusCode);
    weatherDataFav = jsonDecode(response.body);

    // print(weatherData);
  }
}

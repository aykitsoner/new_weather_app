import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:new_weather_app/API/weatherApi.dart';
import 'package:new_weather_app/Pages/splashscreen.dart';
import 'package:new_weather_app/service/auth_service.dart';
import 'package:new_weather_app/utils/constants.dart';
import 'package:new_weather_app/utils/generalfunctions.dart';
import 'package:new_weather_app/utils/hourlyfunction.dart';
import 'package:new_weather_app/utils/location.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //await AuthService.signAnonymous();

  await getLocationData();
  locationData = LocationHelper();
  await locationData.getCurrentLocation();

  if (locationData.latitude != null && locationData.longitude != null) {
    //await WeatherApi().getCurrentLocationWeather(
    await WeatherApi().getWeather(
      query: {
        'lat': locationData.latitude.toString(),
        'lon': locationData.longitude.toString(),
      },
    );
  }
  if (locationData.latitude != null && locationData.longitude != null) {
    await GeneralFunctions().fiveDaysData();
    await HourlyFuntion().hourlyWeatherData();
  }

  print(lastWeatherList.length);
  initializeDateFormatting();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

Future<void> getLocationData() async {
  locationData = LocationHelper();
  await locationData.getCurrentLocation();

  location_latitude = locationData.latitude.toString();
  location_longitude = locationData.longitude.toString();

  if (locationData.latitude == null && locationData.longitude == null) {
    print("Konum bilgileri gelmiyor.");
  } else {
    print("latitude: " + locationData.latitude.toString());
    print("longitude: " + locationData.longitude.toString());
  }
}

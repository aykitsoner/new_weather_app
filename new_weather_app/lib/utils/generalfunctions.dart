import 'package:new_weather_app/utils/constants.dart';

class GeneralFunctions {
  fiveDaysData() {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
        weatherData['list'][0]['dt'] * 1000);

    lastWeatherList = [];
    for (var element in weatherData['list']) {
      DateTime dateTemp =
          DateTime.fromMillisecondsSinceEpoch(element['dt'] * 1000);

      if (date.day != dateTemp.day && dateTemp.hour == 15) {
        lastWeatherList.add(element);
      }
    }
  }
}

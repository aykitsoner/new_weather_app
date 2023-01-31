import 'package:new_weather_app/utils/constants.dart';

class HourlyFuntion {
  hourlyWeatherData() {
    hourlyWeatherList = [];
    for (var element in weatherData['list']) {
      if (hourlyWeatherList.length <= 8) {
        hourlyWeatherList.add(element);
      }
    }
  }

  hourlyFavWeatherData() {
    hourlyWeatherFavList = [];
    print('FL Uzunluğu' + favList.length.toString());

    for (var element in favList) {
      print(element['list'].length);

      for (var elementt in element['list']) {
        if (hourlyWeatherFavList.length <= 8) {
          hourlyWeatherFavList.add(elementt);
        }
      }
    }
    print(hourlyWeatherFavList.length);
    // print('Eklendikten sonra HWFL:' + hourlyWeatherFavList.length.toString());
  }
}

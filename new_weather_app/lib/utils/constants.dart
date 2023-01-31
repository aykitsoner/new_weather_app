import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:new_weather_app/utils/location.dart';

String selection = 'Giresun';
List<String> cityNames = [];
var weatherData;
var weatherDataFav;
TextEditingValue textEditingValue = TextEditingValue();
var responseCity;
List cities = [];
var fiveDaysData;
List<String> allcities = [];
String degree = '°C';
int selectedIndex = 0;
bool favoriteColor = false;
String city = '';
String gunAdi = '';
String hourly = '';
String dayName = '';
String sunrisetime = '';
String sunsettime = '';
// DateFormat format = DateFormat.EEEE('tr');
// DateFormat hourFormat = DateFormat.Hm();
// DateFormat dayformat = DateFormat.EEEE('tr');

enum Temperature { celsius, fahrenheit }

Temperature celFah = Temperature.celsius;

enum IsLoading { loading, completed }

IsLoading isLoading = IsLoading.completed;
late LocationHelper locationData;
late String location_latitude;
late String location_longitude;
List<Map<String, dynamic>> lastWeatherList = [];
List<Map<String, dynamic>> hourlyWeatherList = [];
List<Map<String, dynamic>> hourlyWeatherFavList = [];

List<Map<String, dynamic>> cList = [
  {
    "cod": "200",
    "message": 0,
    "cnt": 40,
    "list": [
      {
        "dt": 1641211200,
        "main": {
          "temp": 282.58,
          "feels_like": 279.78,
          "temp_min": 282.58,
          "temp_max": 282.88,
          "pressure": 1010,
          "sea_level": 1010,
          "grnd_level": 1006,
          "humidity": 81,
          "temp_kf": -0.3
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 5.66, "deg": 236, "gust": 11.81},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-03 12:00:00"
      },
      {
        "dt": 1641222000,
        "main": {
          "temp": 282.83,
          "feels_like": 280.45,
          "temp_min": 282.83,
          "temp_max": 283.03,
          "pressure": 1008,
          "sea_level": 1008,
          "grnd_level": 1004,
          "humidity": 80,
          "temp_kf": -0.2
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 4.73, "deg": 239, "gust": 10.23},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-03 15:00:00"
      },
      {
        "dt": 1641232800,
        "main": {
          "temp": 282.31,
          "feels_like": 280.29,
          "temp_min": 282.31,
          "temp_max": 282.31,
          "pressure": 1006,
          "sea_level": 1006,
          "grnd_level": 1002,
          "humidity": 82,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 3.66, "deg": 234, "gust": 9.34},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-03 18:00:00"
      },
      {
        "dt": 1641243600,
        "main": {
          "temp": 281.84,
          "feels_like": 280.22,
          "temp_min": 281.84,
          "temp_max": 281.84,
          "pressure": 1004,
          "sea_level": 1004,
          "grnd_level": 1001,
          "humidity": 85,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 2.8, "deg": 237, "gust": 7.73},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-03 21:00:00"
      },
      {
        "dt": 1641254400,
        "main": {
          "temp": 281.33,
          "feels_like": 280.29,
          "temp_min": 281.33,
          "temp_max": 281.33,
          "pressure": 1003,
          "sea_level": 1003,
          "grnd_level": 999,
          "humidity": 86,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 1.93, "deg": 256, "gust": 6.43},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-04 00:00:00"
      },
      {
        "dt": 1641265200,
        "main": {
          "temp": 280.85,
          "feels_like": 279.67,
          "temp_min": 280.85,
          "temp_max": 280.85,
          "pressure": 1001,
          "sea_level": 1001,
          "grnd_level": 998,
          "humidity": 86,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 1.99, "deg": 279, "gust": 6.25},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-04 03:00:00"
      },
      {
        "dt": 1641276000,
        "main": {
          "temp": 279.95,
          "feels_like": 278.98,
          "temp_min": 279.95,
          "temp_max": 279.95,
          "pressure": 1001,
          "sea_level": 1001,
          "grnd_level": 998,
          "humidity": 89,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 1.65, "deg": 299, "gust": 4.27},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-04 06:00:00"
      },
      {
        "dt": 1641286800,
        "main": {
          "temp": 279.6,
          "feels_like": 277.21,
          "temp_min": 279.6,
          "temp_max": 279.6,
          "pressure": 1003,
          "sea_level": 1003,
          "grnd_level": 1000,
          "humidity": 86,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 3.29, "deg": 4, "gust": 4.61},
        "visibility": 10000,
        "pop": 0.33,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-04 09:00:00"
      },
      {
        "dt": 1641297600,
        "main": {
          "temp": 275.92,
          "feels_like": 271.76,
          "temp_min": 275.92,
          "temp_max": 275.92,
          "pressure": 1005,
          "sea_level": 1005,
          "grnd_level": 1002,
          "humidity": 93,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 600,
            "main": "Snow",
            "description": "light snow",
            "icon": "13d"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 4.88, "deg": 6, "gust": 9.88},
        "visibility": 360,
        "pop": 0.61,
        "snow": {"3h": 1.07},
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-04 12:00:00"
      },
      {
        "dt": 1641308400,
        "main": {
          "temp": 276.38,
          "feels_like": 272.75,
          "temp_min": 276.38,
          "temp_max": 276.38,
          "pressure": 1006,
          "sea_level": 1006,
          "grnd_level": 1003,
          "humidity": 65,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 600,
            "main": "Snow",
            "description": "light snow",
            "icon": "13d"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 4.14, "deg": 349, "gust": 8.1},
        "visibility": 10000,
        "pop": 0.61,
        "snow": {"3h": 0.73},
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-04 15:00:00"
      },
      {
        "dt": 1641319200,
        "main": {
          "temp": 276.46,
          "feels_like": 272.92,
          "temp_min": 276.46,
          "temp_max": 276.46,
          "pressure": 1007,
          "sea_level": 1007,
          "grnd_level": 1004,
          "humidity": 61,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 4.02, "deg": 320, "gust": 10.15},
        "visibility": 10000,
        "pop": 0.5,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-04 18:00:00"
      },
      {
        "dt": 1641330000,
        "main": {
          "temp": 275.5,
          "feels_like": 271.16,
          "temp_min": 275.5,
          "temp_max": 275.5,
          "pressure": 1009,
          "sea_level": 1009,
          "grnd_level": 1005,
          "humidity": 73,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 1},
        "wind": {"speed": 5.03, "deg": 297, "gust": 11.88},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-04 21:00:00"
      },
      {
        "dt": 1641340800,
        "main": {
          "temp": 275.33,
          "feels_like": 270.8,
          "temp_min": 275.33,
          "temp_max": 275.33,
          "pressure": 1010,
          "sea_level": 1010,
          "grnd_level": 1007,
          "humidity": 74,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 2},
        "wind": {"speed": 5.31, "deg": 287, "gust": 12.27},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-05 00:00:00"
      },
      {
        "dt": 1641351600,
        "main": {
          "temp": 275.12,
          "feels_like": 270.45,
          "temp_min": 275.12,
          "temp_max": 275.12,
          "pressure": 1011,
          "sea_level": 1011,
          "grnd_level": 1008,
          "humidity": 76,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 7},
        "wind": {"speed": 5.48, "deg": 294, "gust": 13.75},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-05 03:00:00"
      },
      {
        "dt": 1641362400,
        "main": {
          "temp": 275.15,
          "feels_like": 270.76,
          "temp_min": 275.15,
          "temp_max": 275.15,
          "pressure": 1013,
          "sea_level": 1013,
          "grnd_level": 1010,
          "humidity": 79,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 6},
        "wind": {"speed": 4.95, "deg": 293, "gust": 13.11},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-05 06:00:00"
      },
      {
        "dt": 1641373200,
        "main": {
          "temp": 275.13,
          "feels_like": 271.22,
          "temp_min": 275.13,
          "temp_max": 275.13,
          "pressure": 1016,
          "sea_level": 1016,
          "grnd_level": 1013,
          "humidity": 82,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
          }
        ],
        "clouds": {"all": 6},
        "wind": {"speed": 4.12, "deg": 298, "gust": 11.59},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-05 09:00:00"
      },
      {
        "dt": 1641384000,
        "main": {
          "temp": 277.24,
          "feels_like": 273.95,
          "temp_min": 277.24,
          "temp_max": 277.24,
          "pressure": 1018,
          "sea_level": 1018,
          "grnd_level": 1015,
          "humidity": 66,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
          }
        ],
        "clouds": {"all": 6},
        "wind": {"speed": 3.91, "deg": 309, "gust": 6.47},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-05 12:00:00"
      },
      {
        "dt": 1641394800,
        "main": {
          "temp": 277.44,
          "feels_like": 274.8,
          "temp_min": 277.44,
          "temp_max": 277.44,
          "pressure": 1019,
          "sea_level": 1019,
          "grnd_level": 1016,
          "humidity": 65,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 801,
            "main": "Clouds",
            "description": "few clouds",
            "icon": "02d"
          }
        ],
        "clouds": {"all": 12},
        "wind": {"speed": 3, "deg": 308, "gust": 6.14},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-05 15:00:00"
      },
      {
        "dt": 1641405600,
        "main": {
          "temp": 275.98,
          "feels_like": 273.88,
          "temp_min": 275.98,
          "temp_max": 275.98,
          "pressure": 1022,
          "sea_level": 1022,
          "grnd_level": 1019,
          "humidity": 74,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 8},
        "wind": {"speed": 2.1, "deg": 302, "gust": 5.74},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-05 18:00:00"
      },
      {
        "dt": 1641416400,
        "main": {
          "temp": 275.01,
          "feels_like": 273.41,
          "temp_min": 275.01,
          "temp_max": 275.01,
          "pressure": 1023,
          "sea_level": 1023,
          "grnd_level": 1019,
          "humidity": 76,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 3},
        "wind": {"speed": 1.57, "deg": 287, "gust": 3.3},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-05 21:00:00"
      },
      {
        "dt": 1641427200,
        "main": {
          "temp": 274.43,
          "feels_like": 274.43,
          "temp_min": 274.43,
          "temp_max": 274.43,
          "pressure": 1023,
          "sea_level": 1023,
          "grnd_level": 1020,
          "humidity": 75,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 2},
        "wind": {"speed": 1.21, "deg": 277, "gust": 1.51},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-06 00:00:00"
      },
      {
        "dt": 1641438000,
        "main": {
          "temp": 273.96,
          "feels_like": 272.35,
          "temp_min": 273.96,
          "temp_max": 273.96,
          "pressure": 1023,
          "sea_level": 1023,
          "grnd_level": 1020,
          "humidity": 79,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 5},
        "wind": {"speed": 1.48, "deg": 244, "gust": 2.7},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-06 03:00:00"
      },
      {
        "dt": 1641448800,
        "main": {
          "temp": 273.62,
          "feels_like": 271.55,
          "temp_min": 273.62,
          "temp_max": 273.62,
          "pressure": 1022,
          "sea_level": 1022,
          "grnd_level": 1019,
          "humidity": 80,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 801,
            "main": "Clouds",
            "description": "few clouds",
            "icon": "02n"
          }
        ],
        "clouds": {"all": 15},
        "wind": {"speed": 1.76, "deg": 199, "gust": 4.16},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-06 06:00:00"
      },
      {
        "dt": 1641459600,
        "main": {
          "temp": 274.03,
          "feels_like": 271.62,
          "temp_min": 274.03,
          "temp_max": 274.03,
          "pressure": 1021,
          "sea_level": 1021,
          "grnd_level": 1018,
          "humidity": 75,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 802,
            "main": "Clouds",
            "description": "scattered clouds",
            "icon": "03d"
          }
        ],
        "clouds": {"all": 33},
        "wind": {"speed": 2.08, "deg": 180, "gust": 8.03},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-06 09:00:00"
      },
      {
        "dt": 1641470400,
        "main": {
          "temp": 278.55,
          "feels_like": 275.04,
          "temp_min": 278.55,
          "temp_max": 278.55,
          "pressure": 1018,
          "sea_level": 1018,
          "grnd_level": 1015,
          "humidity": 65,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 55},
        "wind": {"speed": 4.88, "deg": 189, "gust": 11.17},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-06 12:00:00"
      },
      {
        "dt": 1641481200,
        "main": {
          "temp": 278.17,
          "feels_like": 273.77,
          "temp_min": 278.17,
          "temp_max": 278.17,
          "pressure": 1015,
          "sea_level": 1015,
          "grnd_level": 1012,
          "humidity": 85,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10d"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 6.77, "deg": 200, "gust": 14.08},
        "visibility": 10000,
        "pop": 0.8,
        "rain": {"3h": 0.73},
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-06 15:00:00"
      },
      {
        "dt": 1641492000,
        "main": {
          "temp": 279.64,
          "feels_like": 275.31,
          "temp_min": 279.64,
          "temp_max": 279.64,
          "pressure": 1013,
          "sea_level": 1013,
          "grnd_level": 1009,
          "humidity": 90,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 7.82, "deg": 201, "gust": 17.85},
        "visibility": 10000,
        "pop": 1,
        "rain": {"3h": 1.5},
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-06 18:00:00"
      },
      {
        "dt": 1641502800,
        "main": {
          "temp": 280.77,
          "feels_like": 277.92,
          "temp_min": 280.77,
          "temp_max": 280.77,
          "pressure": 1013,
          "sea_level": 1013,
          "grnd_level": 1009,
          "humidity": 83,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 4.65, "deg": 255, "gust": 11.26},
        "visibility": 10000,
        "pop": 0.75,
        "rain": {"3h": 1.53},
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-06 21:00:00"
      },
      {
        "dt": 1641513600,
        "main": {
          "temp": 279.28,
          "feels_like": 275.74,
          "temp_min": 279.28,
          "temp_max": 279.28,
          "pressure": 1013,
          "sea_level": 1013,
          "grnd_level": 1010,
          "humidity": 80,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10n"
          }
        ],
        "clouds": {"all": 95},
        "wind": {"speed": 5.37, "deg": 248, "gust": 11.37},
        "visibility": 10000,
        "pop": 0.69,
        "rain": {"3h": 0.12},
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-07 00:00:00"
      },
      {
        "dt": 1641524400,
        "main": {
          "temp": 278.25,
          "feels_like": 274.7,
          "temp_min": 278.25,
          "temp_max": 278.25,
          "pressure": 1013,
          "sea_level": 1013,
          "grnd_level": 1010,
          "humidity": 80,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 99},
        "wind": {"speed": 4.81, "deg": 238, "gust": 10.77},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-07 03:00:00"
      },
      {
        "dt": 1641535200,
        "main": {
          "temp": 277.41,
          "feels_like": 273.69,
          "temp_min": 277.41,
          "temp_max": 277.41,
          "pressure": 1012,
          "sea_level": 1012,
          "grnd_level": 1009,
          "humidity": 79,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 98},
        "wind": {"speed": 4.75, "deg": 220, "gust": 11.04},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-07 06:00:00"
      },
      {
        "dt": 1641546000,
        "main": {
          "temp": 276.36,
          "feels_like": 273.48,
          "temp_min": 276.36,
          "temp_max": 276.36,
          "pressure": 1012,
          "sea_level": 1012,
          "grnd_level": 1009,
          "humidity": 85,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 68},
        "wind": {"speed": 3.03, "deg": 231, "gust": 9.59},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-07 09:00:00"
      },
      {
        "dt": 1641556800,
        "main": {
          "temp": 277.2,
          "feels_like": 273.94,
          "temp_min": 277.2,
          "temp_max": 277.2,
          "pressure": 1012,
          "sea_level": 1012,
          "grnd_level": 1009,
          "humidity": 79,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10d"
          }
        ],
        "clouds": {"all": 69},
        "wind": {"speed": 3.84, "deg": 291, "gust": 7.4},
        "visibility": 10000,
        "pop": 0.39,
        "rain": {"3h": 0.28},
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-07 12:00:00"
      },
      {
        "dt": 1641567600,
        "main": {
          "temp": 277.66,
          "feels_like": 273.95,
          "temp_min": 277.66,
          "temp_max": 277.66,
          "pressure": 1013,
          "sea_level": 1013,
          "grnd_level": 1010,
          "humidity": 67,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10d"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 4.84, "deg": 286, "gust": 9.94},
        "visibility": 10000,
        "pop": 0.37,
        "rain": {"3h": 0.12},
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-07 15:00:00"
      },
      {
        "dt": 1641578400,
        "main": {
          "temp": 276.21,
          "feels_like": 273.08,
          "temp_min": 276.21,
          "temp_max": 276.21,
          "pressure": 1016,
          "sea_level": 1016,
          "grnd_level": 1013,
          "humidity": 74,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 53},
        "wind": {"speed": 3.32, "deg": 281, "gust": 9.48},
        "visibility": 10000,
        "pop": 0.29,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-07 18:00:00"
      },
      {
        "dt": 1641589200,
        "main": {
          "temp": 275.11,
          "feels_like": 271.89,
          "temp_min": 275.11,
          "temp_max": 275.11,
          "pressure": 1019,
          "sea_level": 1019,
          "grnd_level": 1015,
          "humidity": 79,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 7},
        "wind": {"speed": 3.14, "deg": 264, "gust": 8.72},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-07 21:00:00"
      },
      {
        "dt": 1641600000,
        "main": {
          "temp": 274.49,
          "feels_like": 271.64,
          "temp_min": 274.49,
          "temp_max": 274.49,
          "pressure": 1018,
          "sea_level": 1018,
          "grnd_level": 1015,
          "humidity": 82,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 6},
        "wind": {"speed": 2.58, "deg": 224, "gust": 7.37},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-08 00:00:00"
      },
      {
        "dt": 1641610800,
        "main": {
          "temp": 275.54,
          "feels_like": 272.08,
          "temp_min": 275.54,
          "temp_max": 275.54,
          "pressure": 1016,
          "sea_level": 1016,
          "grnd_level": 1013,
          "humidity": 73,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 81},
        "wind": {"speed": 3.58, "deg": 201, "gust": 12.79},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-08 03:00:00"
      },
      {
        "dt": 1641621600,
        "main": {
          "temp": 278.96,
          "feels_like": 275.33,
          "temp_min": 278.96,
          "temp_max": 278.96,
          "pressure": 1012,
          "sea_level": 1012,
          "grnd_level": 1009,
          "humidity": 92,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10n"
          }
        ],
        "clouds": {"all": 90},
        "wind": {"speed": 5.39, "deg": 210, "gust": 14.11},
        "visibility": 10000,
        "pop": 0.2,
        "rain": {"3h": 0.19},
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-08 06:00:00"
      },
      {
        "dt": 1641632400,
        "main": {
          "temp": 280.69,
          "feels_like": 277.03,
          "temp_min": 280.69,
          "temp_max": 280.69,
          "pressure": 1008,
          "sea_level": 1008,
          "grnd_level": 1005,
          "humidity": 85,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10d"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 6.69, "deg": 223, "gust": 15.12},
        "visibility": 10000,
        "pop": 0.88,
        "rain": {"3h": 0.72},
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-08 09:00:00"
      }
    ],
    "city": {
      "id": 2643743,
      "name": "London",
      "coord": {"lat": 51.5085, "lon": -0.1257},
      "country": "GB",
      "population": 1000000,
      "timezone": 0,
      "sunrise": 1641197149,
      "sunset": 1641225821
    }
  }
];
List<Map<String, dynamic>> lList = [
  {
    "cod": "200",
    "message": 0,
    "cnt": 40,
    "list": [
      {
        "dt": 1641211200,
        "main": {
          "temp": 276.72,
          "feels_like": 274.42, //hissedilen
          "temp_min": 275.57,
          "temp_max": 276.72,
          "pressure": 1017,
          "sea_level": 1017,
          "grnd_level": 987,
          "humidity": 80, //nem
          "temp_kf": 1.15
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear", //tanım
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 4},
        "wind": {"speed": 2.43, "deg": 235, "gust": 2.82}, //rüzgar
        "visibility": 10000,
        "pop": 0, //yağmur ihtimali
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-03 12:00:00"
      },
      {
        "dt": 1641222000,
        "main": {
          "temp": 276.17,
          "feels_like": 273.01,
          "temp_min": 275.61,
          "temp_max": 276.17,
          "pressure": 1015,
          "sea_level": 1015,
          "grnd_level": 985,
          "humidity": 83,
          "temp_kf": 0.56
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 2},
        "wind": {"speed": 3.35, "deg": 255, "gust": 5.41},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-03 15:00:00"
      },
      {
        "dt": 1641232800,
        "main": {
          "temp": 277.38,
          "feels_like": 272.21,
          "temp_min": 277.38,
          "temp_max": 277.38,
          "pressure": 1013,
          "sea_level": 1013,
          "grnd_level": 984,
          "humidity": 71,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 1},
        "wind": {"speed": 8.36, "deg": 256, "gust": 14.2},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-03 18:00:00"
      },
      {
        "dt": 1641243600,
        "main": {
          "temp": 277.05,
          "feels_like": 271.85,
          "temp_min": 277.05,
          "temp_max": 277.05,
          "pressure": 1013,
          "sea_level": 1013,
          "grnd_level": 984,
          "humidity": 71,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 0},
        "wind": {"speed": 8.13, "deg": 254, "gust": 14},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-03 21:00:00"
      },
      {
        "dt": 1641254400,
        "main": {
          "temp": 279.53,
          "feels_like": 275.4,
          "temp_min": 279.53,
          "temp_max": 279.53,
          "pressure": 1013,
          "sea_level": 1013,
          "grnd_level": 984,
          "humidity": 61,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
          }
        ],
        "clouds": {"all": 0},
        "wind": {"speed": 7.1, "deg": 257, "gust": 11.7},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-04 00:00:00"
      },
      {
        "dt": 1641265200,
        "main": {
          "temp": 283.06,
          "feels_like": 279.95,
          "temp_min": 283.06,
          "temp_max": 283.06,
          "pressure": 1011,
          "sea_level": 1011,
          "grnd_level": 982,
          "humidity": 39,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
          }
        ],
        "clouds": {"all": 0},
        "wind": {"speed": 7.1, "deg": 265, "gust": 9.3},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-04 03:00:00"
      },
      {
        "dt": 1641276000,
        "main": {
          "temp": 282.24,
          "feels_like": 278.91,
          "temp_min": 282.24,
          "temp_max": 282.24,
          "pressure": 1011,
          "sea_level": 1011,
          "grnd_level": 982,
          "humidity": 44,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
          }
        ],
        "clouds": {"all": 0},
        "wind": {"speed": 7.04, "deg": 252, "gust": 8.8},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-04 06:00:00"
      },
      {
        "dt": 1641286800,
        "main": {
          "temp": 277.75,
          "feels_like": 275.23,
          "temp_min": 277.75,
          "temp_max": 277.75,
          "pressure": 1015,
          "sea_level": 1015,
          "grnd_level": 986,
          "humidity": 60,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 801,
            "main": "Clouds",
            "description": "few clouds",
            "icon": "02n"
          }
        ],
        "clouds": {"all": 14},
        "wind": {"speed": 2.93, "deg": 110, "gust": 3.11},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-04 09:00:00"
      },
      {
        "dt": 1641297600,
        "main": {
          "temp": 276.74,
          "feels_like": 272.87,
          "temp_min": 276.74,
          "temp_max": 276.74,
          "pressure": 1017,
          "sea_level": 1017,
          "grnd_level": 987,
          "humidity": 64,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 801,
            "main": "Clouds",
            "description": "few clouds",
            "icon": "02n"
          }
        ],
        "clouds": {"all": 22},
        "wind": {"speed": 4.71, "deg": 113, "gust": 7.41},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-04 12:00:00"
      },
      {
        "dt": 1641308400,
        "main": {
          "temp": 276.14,
          "feels_like": 272.71,
          "temp_min": 276.14,
          "temp_max": 276.14,
          "pressure": 1018,
          "sea_level": 1018,
          "grnd_level": 988,
          "humidity": 68,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 74},
        "wind": {"speed": 3.74, "deg": 123, "gust": 6.11},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-04 15:00:00"
      },
      {
        "dt": 1641319200,
        "main": {
          "temp": 275,
          "feels_like": 272.53,
          "temp_min": 275,
          "temp_max": 275,
          "pressure": 1019,
          "sea_level": 1019,
          "grnd_level": 989,
          "humidity": 78,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 78},
        "wind": {"speed": 2.29, "deg": 131, "gust": 3.6},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-04 18:00:00"
      },
      {
        "dt": 1641330000,
        "main": {
          "temp": 274.49,
          "feels_like": 274.49,
          "temp_min": 274.49,
          "temp_max": 274.49,
          "pressure": 1020,
          "sea_level": 1020,
          "grnd_level": 991,
          "humidity": 90,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 600,
            "main": "Snow",
            "description": "light snow",
            "icon": "13n"
          }
        ],
        "clouds": {"all": 95},
        "wind": {"speed": 1.3, "deg": 131, "gust": 1.7},
        "visibility": 1287,
        "pop": 0.24,
        "snow": {"3h": 0.25},
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-04 21:00:00"
      },
      {
        "dt": 1641340800,
        "main": {
          "temp": 276.31,
          "feels_like": 276.31,
          "temp_min": 276.31,
          "temp_max": 276.31,
          "pressure": 1022,
          "sea_level": 1022,
          "grnd_level": 993,
          "humidity": 82,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 600,
            "main": "Snow",
            "description": "light snow",
            "icon": "13d"
          }
        ],
        "clouds": {"all": 94},
        "wind": {"speed": 1.02, "deg": 118, "gust": 1.42},
        "visibility": 7299,
        "pop": 0.32,
        "snow": {"3h": 0.38},
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-05 00:00:00"
      },
      {
        "dt": 1641351600,
        "main": {
          "temp": 277.78,
          "feels_like": 277.78,
          "temp_min": 277.78,
          "temp_max": 277.78,
          "pressure": 1021,
          "sea_level": 1021,
          "grnd_level": 992,
          "humidity": 72,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 600,
            "main": "Snow",
            "description": "light snow",
            "icon": "13d"
          }
        ],
        "clouds": {"all": 98},
        "wind": {"speed": 0.69, "deg": 172, "gust": 1.41},
        "visibility": 10000,
        "pop": 0.36,
        "snow": {"3h": 0.25},
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-05 03:00:00"
      },
      {
        "dt": 1641362400,
        "main": {
          "temp": 277.42,
          "feels_like": 277.42,
          "temp_min": 277.42,
          "temp_max": 277.42,
          "pressure": 1022,
          "sea_level": 1022,
          "grnd_level": 993,
          "humidity": 79,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 600,
            "main": "Snow",
            "description": "light snow",
            "icon": "13d"
          }
        ],
        "clouds": {"all": 99},
        "wind": {"speed": 0.63, "deg": 130, "gust": 0.7},
        "visibility": 10000,
        "pop": 0.28,
        "snow": {"3h": 0.19},
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-05 06:00:00"
      },
      {
        "dt": 1641373200,
        "main": {
          "temp": 276.49,
          "feels_like": 276.49,
          "temp_min": 276.49,
          "temp_max": 276.49,
          "pressure": 1025,
          "sea_level": 1025,
          "grnd_level": 995,
          "humidity": 84,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 600,
            "main": "Snow",
            "description": "light snow",
            "icon": "13n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 1.21, "deg": 133, "gust": 1.6},
        "visibility": 10000,
        "pop": 0.36,
        "snow": {"3h": 0.13},
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-05 09:00:00"
      },
      {
        "dt": 1641384000,
        "main": {
          "temp": 275.22,
          "feels_like": 275.22,
          "temp_min": 275.22,
          "temp_max": 275.22,
          "pressure": 1026,
          "sea_level": 1026,
          "grnd_level": 996,
          "humidity": 80,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 99},
        "wind": {"speed": 1.23, "deg": 148, "gust": 1.51},
        "visibility": 10000,
        "pop": 0.16,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-05 12:00:00"
      },
      {
        "dt": 1641394800,
        "main": {
          "temp": 275.62,
          "feels_like": 272.35,
          "temp_min": 275.62,
          "temp_max": 275.62,
          "pressure": 1025,
          "sea_level": 1025,
          "grnd_level": 996,
          "humidity": 70,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 93},
        "wind": {"speed": 3.34, "deg": 75, "gust": 4.8},
        "visibility": 10000,
        "pop": 0.2,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-05 15:00:00"
      },
      {
        "dt": 1641405600,
        "main": {
          "temp": 274.43,
          "feels_like": 271.86,
          "temp_min": 274.43,
          "temp_max": 274.43,
          "pressure": 1026,
          "sea_level": 1026,
          "grnd_level": 996,
          "humidity": 66,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 95},
        "wind": {"speed": 2.29, "deg": 58, "gust": 3.9},
        "visibility": 10000,
        "pop": 0.16,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-05 18:00:00"
      },
      {
        "dt": 1641416400,
        "main": {
          "temp": 274.55,
          "feels_like": 271,
          "temp_min": 274.55,
          "temp_max": 274.55,
          "pressure": 1026,
          "sea_level": 1026,
          "grnd_level": 996,
          "humidity": 69,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 3.41, "deg": 64, "gust": 4.91},
        "visibility": 10000,
        "pop": 0.24,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-05 21:00:00"
      },
      {
        "dt": 1641427200,
        "main": {
          "temp": 275.48,
          "feels_like": 272.12,
          "temp_min": 275.48,
          "temp_max": 275.48,
          "pressure": 1027,
          "sea_level": 1027,
          "grnd_level": 998,
          "humidity": 70,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 96},
        "wind": {"speed": 3.42, "deg": 70, "gust": 3.9},
        "visibility": 10000,
        "pop": 0.28,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-06 00:00:00"
      },
      {
        "dt": 1641438000,
        "main": {
          "temp": 277.27,
          "feels_like": 274.99,
          "temp_min": 277.27,
          "temp_max": 277.27,
          "pressure": 1024,
          "sea_level": 1024,
          "grnd_level": 994,
          "humidity": 69,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 99},
        "wind": {"speed": 2.52, "deg": 75, "gust": 2.11},
        "visibility": 10000,
        "pop": 0.2,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-06 03:00:00"
      },
      {
        "dt": 1641448800,
        "main": {
          "temp": 276.26,
          "feels_like": 274.2,
          "temp_min": 276.26,
          "temp_max": 276.26,
          "pressure": 1022,
          "sea_level": 1022,
          "grnd_level": 993,
          "humidity": 89,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10d"
          }
        ],
        "clouds": {"all": 99},
        "wind": {"speed": 2.11, "deg": 81, "gust": 2},
        "visibility": 184,
        "pop": 0.32,
        "rain": {"3h": 0.19},
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-06 06:00:00"
      },
      {
        "dt": 1641459600,
        "main": {
          "temp": 275.93,
          "feels_like": 275.93,
          "temp_min": 275.93,
          "temp_max": 275.93,
          "pressure": 1023,
          "sea_level": 1023,
          "grnd_level": 993,
          "humidity": 96,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 1.27, "deg": 83, "gust": 1.5},
        "visibility": 5601,
        "pop": 0.24,
        "rain": {"3h": 0.19},
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-06 09:00:00"
      },
      {
        "dt": 1641470400,
        "main": {
          "temp": 275.27,
          "feels_like": 275.27,
          "temp_min": 275.27,
          "temp_max": 275.27,
          "pressure": 1022,
          "sea_level": 1022,
          "grnd_level": 993,
          "humidity": 91,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 95},
        "wind": {"speed": 0.67, "deg": 212, "gust": 0.8},
        "visibility": 10000,
        "pop": 0.12,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-06 12:00:00"
      },
      {
        "dt": 1641481200,
        "main": {
          "temp": 274.4,
          "feels_like": 274.4,
          "temp_min": 274.4,
          "temp_max": 274.4,
          "pressure": 1021,
          "sea_level": 1021,
          "grnd_level": 991,
          "humidity": 91,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 801,
            "main": "Clouds",
            "description": "few clouds",
            "icon": "02n"
          }
        ],
        "clouds": {"all": 16},
        "wind": {"speed": 0.15, "deg": 70, "gust": 0.4},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-06 15:00:00"
      },
      {
        "dt": 1641492000,
        "main": {
          "temp": 274.64,
          "feels_like": 272.47,
          "temp_min": 274.64,
          "temp_max": 274.64,
          "pressure": 1021,
          "sea_level": 1021,
          "grnd_level": 991,
          "humidity": 92,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 801,
            "main": "Clouds",
            "description": "few clouds",
            "icon": "02n"
          }
        ],
        "clouds": {"all": 12},
        "wind": {"speed": 1.97, "deg": 75, "gust": 2.01},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-06 18:00:00"
      },
      {
        "dt": 1641502800,
        "main": {
          "temp": 274.33,
          "feels_like": 272.87,
          "temp_min": 274.33,
          "temp_max": 274.33,
          "pressure": 1023,
          "sea_level": 1023,
          "grnd_level": 993,
          "humidity": 85,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 6},
        "wind": {"speed": 1.42, "deg": 111, "gust": 1.5},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-06 21:00:00"
      },
      {
        "dt": 1641513600,
        "main": {
          "temp": 278.28,
          "feels_like": 278.28,
          "temp_min": 278.28,
          "temp_max": 278.28,
          "pressure": 1023,
          "sea_level": 1023,
          "grnd_level": 994,
          "humidity": 61,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
          }
        ],
        "clouds": {"all": 5},
        "wind": {"speed": 0.83, "deg": 154, "gust": 1.4},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-07 00:00:00"
      },
      {
        "dt": 1641524400,
        "main": {
          "temp": 281.48,
          "feels_like": 281.48,
          "temp_min": 281.48,
          "temp_max": 281.48,
          "pressure": 1021,
          "sea_level": 1021,
          "grnd_level": 992,
          "humidity": 58,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 801,
            "main": "Clouds",
            "description": "few clouds",
            "icon": "02d"
          }
        ],
        "clouds": {"all": 22},
        "wind": {"speed": 1.23, "deg": 266, "gust": 3.41},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-07 03:00:00"
      },
      {
        "dt": 1641535200,
        "main": {
          "temp": 279.66,
          "feels_like": 279.66,
          "temp_min": 279.66,
          "temp_max": 279.66,
          "pressure": 1022,
          "sea_level": 1022,
          "grnd_level": 992,
          "humidity": 72,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 59},
        "wind": {"speed": 1.11, "deg": 195, "gust": 2},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-07 06:00:00"
      },
      {
        "dt": 1641546000,
        "main": {
          "temp": 277.56,
          "feels_like": 276.16,
          "temp_min": 277.56,
          "temp_max": 277.56,
          "pressure": 1023,
          "sea_level": 1023,
          "grnd_level": 994,
          "humidity": 83,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 97},
        "wind": {"speed": 1.71, "deg": 192, "gust": 2.01},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-07 09:00:00"
      },
      {
        "dt": 1641556800,
        "main": {
          "temp": 277.31,
          "feels_like": 277.31,
          "temp_min": 277.31,
          "temp_max": 277.31,
          "pressure": 1024,
          "sea_level": 1024,
          "grnd_level": 994,
          "humidity": 77,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10n"
          }
        ],
        "clouds": {"all": 97},
        "wind": {"speed": 1.08, "deg": 194, "gust": 1.21},
        "visibility": 10000,
        "pop": 0.2,
        "rain": {"3h": 0.13},
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-07 12:00:00"
      },
      {
        "dt": 1641567600,
        "main": {
          "temp": 277.65,
          "feels_like": 277.65,
          "temp_min": 277.65,
          "temp_max": 277.65,
          "pressure": 1023,
          "sea_level": 1023,
          "grnd_level": 993,
          "humidity": 79,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 0.99, "deg": 60, "gust": 1.11},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-07 15:00:00"
      },
      {
        "dt": 1641578400,
        "main": {
          "temp": 276.9,
          "feels_like": 274.28,
          "temp_min": 276.9,
          "temp_max": 276.9,
          "pressure": 1023,
          "sea_level": 1023,
          "grnd_level": 993,
          "humidity": 95,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 2.84, "deg": 69, "gust": 3.91},
        "visibility": 1007,
        "pop": 0.32,
        "rain": {"3h": 0.38},
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-07 18:00:00"
      },
      {
        "dt": 1641589200,
        "main": {
          "temp": 276.48,
          "feels_like": 274.42,
          "temp_min": 276.48,
          "temp_max": 276.48,
          "pressure": 1023,
          "sea_level": 1023,
          "grnd_level": 994,
          "humidity": 84,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 2.14, "deg": 84, "gust": 2.9},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-07 21:00:00"
      },
      {
        "dt": 1641600000,
        "main": {
          "temp": 277.15,
          "feels_like": 275.46,
          "temp_min": 277.15,
          "temp_max": 277.15,
          "pressure": 1024,
          "sea_level": 1024,
          "grnd_level": 994,
          "humidity": 78,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 99},
        "wind": {"speed": 1.9, "deg": 95, "gust": 2.01},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-08 00:00:00"
      },
      {
        "dt": 1641610800,
        "main": {
          "temp": 280.09,
          "feels_like": 280.09,
          "temp_min": 280.09,
          "temp_max": 280.09,
          "pressure": 1022,
          "sea_level": 1022,
          "grnd_level": 993,
          "humidity": 65,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 88},
        "wind": {"speed": 0.76, "deg": 107, "gust": 2.3},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-08 03:00:00"
      },
      {
        "dt": 1641621600,
        "main": {
          "temp": 280.58,
          "feels_like": 280.58,
          "temp_min": 280.58,
          "temp_max": 280.58,
          "pressure": 1021,
          "sea_level": 1021,
          "grnd_level": 992,
          "humidity": 60,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 84},
        "wind": {"speed": 0.41, "deg": 208, "gust": 2.21},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2022-01-08 06:00:00"
      },
      {
        "dt": 1641632400,
        "main": {
          "temp": 276.85,
          "feels_like": 275.85,
          "temp_min": 276.85,
          "temp_max": 276.85,
          "pressure": 1022,
          "sea_level": 1022,
          "grnd_level": 993,
          "humidity": 81,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 801,
            "main": "Clouds",
            "description": "few clouds",
            "icon": "02n"
          }
        ],
        "clouds": {"all": 20},
        "wind": {"speed": 1.34, "deg": 162, "gust": 1.41},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2022-01-08 09:00:00"
      }
    ],
    "city": {
      "id": 1851632,
      "name": "Shuzenji",
      "coord": {"lat": 35, "lon": 139},
      "country": "JP",
      "population": 0,
      "timezone": 32400,
      "sunrise": 1641160330, //gündoğumu
      "sunset": 1641195839 //günbatımı
    }
  },
  {
    "cod": "200",
    "message": 0,
    "cnt": 40,
    "list": [
      {
        "dt": 1674734400,
        "main": {
          "temp": 282.42,
          "feels_like": 280.1,
          "temp_min": 282.42,
          "temp_max": 283.77,
          "pressure": 1019,
          "sea_level": 1019,
          "grnd_level": 1007,
          "humidity": 61,
          "temp_kf": -1.35
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 80},
        "wind": {"speed": 4.33, "deg": 77, "gust": 5.64},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-26 12:00:00"
      },
      {
        "dt": 1674745200,
        "main": {
          "temp": 282.54,
          "feels_like": 279.73,
          "temp_min": 282.54,
          "temp_max": 282.94,
          "pressure": 1017,
          "sea_level": 1017,
          "grnd_level": 1006,
          "humidity": 62,
          "temp_kf": -0.4
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 92},
        "wind": {"speed": 5.68, "deg": 56, "gust": 8.78},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-26 15:00:00"
      },
      {
        "dt": 1674756000,
        "main": {
          "temp": 282.54,
          "feels_like": 280.01,
          "temp_min": 282.54,
          "temp_max": 282.54,
          "pressure": 1014,
          "sea_level": 1014,
          "grnd_level": 1004,
          "humidity": 62,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 4.92, "deg": 67, "gust": 8.68},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-26 18:00:00"
      },
      {
        "dt": 1674766800,
        "main": {
          "temp": 282.88,
          "feels_like": 280.59,
          "temp_min": 282.88,
          "temp_max": 282.88,
          "pressure": 1012,
          "sea_level": 1012,
          "grnd_level": 1002,
          "humidity": 62,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 4.53, "deg": 64, "gust": 7.55},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-26 21:00:00"
      },
      {
        "dt": 1674777600,
        "main": {
          "temp": 283.79,
          "feels_like": 282.4,
          "temp_min": 283.79,
          "temp_max": 283.79,
          "pressure": 1010,
          "sea_level": 1010,
          "grnd_level": 1000,
          "humidity": 57,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 5.04, "deg": 95, "gust": 10.18},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-27 00:00:00"
      },
      {
        "dt": 1674788400,
        "main": {
          "temp": 284.21,
          "feels_like": 282.86,
          "temp_min": 284.21,
          "temp_max": 284.21,
          "pressure": 1008,
          "sea_level": 1008,
          "grnd_level": 998,
          "humidity": 57,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 5.44, "deg": 112, "gust": 10.84},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-27 03:00:00"
      },
      {
        "dt": 1674799200,
        "main": {
          "temp": 283.14,
          "feels_like": 282.73,
          "temp_min": 283.14,
          "temp_max": 283.14,
          "pressure": 1009,
          "sea_level": 1009,
          "grnd_level": 999,
          "humidity": 71,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 1.56, "deg": 260, "gust": 2.39},
        "visibility": 10000,
        "pop": 0.14,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-27 06:00:00"
      },
      {
        "dt": 1674810000,
        "main": {
          "temp": 282.5,
          "feels_like": 281.94,
          "temp_min": 282.5,
          "temp_max": 282.5,
          "pressure": 1009,
          "sea_level": 1009,
          "grnd_level": 999,
          "humidity": 87,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10d"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 1.61, "deg": 180, "gust": 2.63},
        "visibility": 10000,
        "pop": 0.61,
        "rain": {"3h": 0.76},
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-27 09:00:00"
      },
      {
        "dt": 1674820800,
        "main": {
          "temp": 282.99,
          "feels_like": 281.98,
          "temp_min": 282.99,
          "temp_max": 282.99,
          "pressure": 1008,
          "sea_level": 1008,
          "grnd_level": 998,
          "humidity": 85,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10d"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 2.23, "deg": 213, "gust": 3.85},
        "visibility": 10000,
        "pop": 0.88,
        "rain": {"3h": 1.73},
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-27 12:00:00"
      },
      {
        "dt": 1674831600,
        "main": {
          "temp": 282.72,
          "feels_like": 282.72,
          "temp_min": 282.72,
          "temp_max": 282.72,
          "pressure": 1008,
          "sea_level": 1008,
          "grnd_level": 998,
          "humidity": 84,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10d"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 0.92, "deg": 196, "gust": 2.86},
        "visibility": 10000,
        "pop": 0.44,
        "rain": {"3h": 0.15},
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-27 15:00:00"
      },
      {
        "dt": 1674842400,
        "main": {
          "temp": 282.58,
          "feels_like": 281.83,
          "temp_min": 282.58,
          "temp_max": 282.58,
          "pressure": 1008,
          "sea_level": 1008,
          "grnd_level": 999,
          "humidity": 86,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 1.83, "deg": 223, "gust": 3.51},
        "visibility": 10000,
        "pop": 0.58,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-27 18:00:00"
      },
      {
        "dt": 1674853200,
        "main": {
          "temp": 281.96,
          "feels_like": 279.82,
          "temp_min": 281.96,
          "temp_max": 281.96,
          "pressure": 1009,
          "sea_level": 1009,
          "grnd_level": 1000,
          "humidity": 86,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 3.74, "deg": 235, "gust": 7.41},
        "visibility": 10000,
        "pop": 0.19,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-27 21:00:00"
      },
      {
        "dt": 1674864000,
        "main": {
          "temp": 281.47,
          "feels_like": 279.86,
          "temp_min": 281.47,
          "temp_max": 281.47,
          "pressure": 1010,
          "sea_level": 1010,
          "grnd_level": 1000,
          "humidity": 88,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 2.67, "deg": 242, "gust": 5.97},
        "visibility": 10000,
        "pop": 0.14,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-28 00:00:00"
      },
      {
        "dt": 1674874800,
        "main": {
          "temp": 280.86,
          "feels_like": 279.64,
          "temp_min": 280.86,
          "temp_max": 280.86,
          "pressure": 1010,
          "sea_level": 1010,
          "grnd_level": 1001,
          "humidity": 90,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10n"
          }
        ],
        "clouds": {"all": 74},
        "wind": {"speed": 2.04, "deg": 263, "gust": 2.86},
        "visibility": 10000,
        "pop": 0.27,
        "rain": {"3h": 0.1},
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-28 03:00:00"
      },
      {
        "dt": 1674885600,
        "main": {
          "temp": 280.89,
          "feels_like": 280.89,
          "temp_min": 280.89,
          "temp_max": 280.89,
          "pressure": 1012,
          "sea_level": 1012,
          "grnd_level": 1002,
          "humidity": 89,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10d"
          }
        ],
        "clouds": {"all": 76},
        "wind": {"speed": 1.11, "deg": 279, "gust": 1.51},
        "visibility": 10000,
        "pop": 0.2,
        "rain": {"3h": 0.11},
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-28 06:00:00"
      },
      {
        "dt": 1674896400,
        "main": {
          "temp": 281.76,
          "feels_like": 281.02,
          "temp_min": 281.76,
          "temp_max": 281.76,
          "pressure": 1013,
          "sea_level": 1013,
          "grnd_level": 1003,
          "humidity": 80,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10d"
          }
        ],
        "clouds": {"all": 95},
        "wind": {"speed": 1.68, "deg": 279, "gust": 2.46},
        "visibility": 10000,
        "pop": 0.36,
        "rain": {"3h": 0.11},
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-28 09:00:00"
      },
      {
        "dt": 1674907200,
        "main": {
          "temp": 281.96,
          "feels_like": 280.62,
          "temp_min": 281.96,
          "temp_max": 281.96,
          "pressure": 1013,
          "sea_level": 1013,
          "grnd_level": 1004,
          "humidity": 77,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 97},
        "wind": {"speed": 2.42, "deg": 289, "gust": 3.4},
        "visibility": 10000,
        "pop": 0.12,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-28 12:00:00"
      },
      {
        "dt": 1674918000,
        "main": {
          "temp": 280.59,
          "feels_like": 277.9,
          "temp_min": 280.59,
          "temp_max": 280.59,
          "pressure": 1015,
          "sea_level": 1015,
          "grnd_level": 1005,
          "humidity": 79,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 4.21, "deg": 11, "gust": 4.62},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-28 15:00:00"
      },
      {
        "dt": 1674928800,
        "main": {
          "temp": 279.63,
          "feels_like": 276.45,
          "temp_min": 279.63,
          "temp_max": 279.63,
          "pressure": 1017,
          "sea_level": 1017,
          "grnd_level": 1007,
          "humidity": 74,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 4.76, "deg": 6, "gust": 5.93},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-28 18:00:00"
      },
      {
        "dt": 1674939600,
        "main": {
          "temp": 278.87,
          "feels_like": 275.46,
          "temp_min": 278.87,
          "temp_max": 278.87,
          "pressure": 1018,
          "sea_level": 1018,
          "grnd_level": 1008,
          "humidity": 72,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 4.84, "deg": 356, "gust": 6.46},
        "visibility": 10000,
        "pop": 0.15,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-28 21:00:00"
      },
      {
        "dt": 1674950400,
        "main": {
          "temp": 277.78,
          "feels_like": 274.38,
          "temp_min": 277.78,
          "temp_max": 277.78,
          "pressure": 1019,
          "sea_level": 1019,
          "grnd_level": 1009,
          "humidity": 74,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 90},
        "wind": {"speed": 4.31, "deg": 357, "gust": 6.12},
        "visibility": 10000,
        "pop": 0.22,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-29 00:00:00"
      },
      {
        "dt": 1674961200,
        "main": {
          "temp": 277.43,
          "feels_like": 274.2,
          "temp_min": 277.43,
          "temp_max": 277.43,
          "pressure": 1019,
          "sea_level": 1019,
          "grnd_level": 1009,
          "humidity": 74,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 97},
        "wind": {"speed": 3.88, "deg": 353, "gust": 4.93},
        "visibility": 10000,
        "pop": 0.04,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-29 03:00:00"
      },
      {
        "dt": 1674972000,
        "main": {
          "temp": 277.37,
          "feels_like": 274.29,
          "temp_min": 277.37,
          "temp_max": 277.37,
          "pressure": 1021,
          "sea_level": 1021,
          "grnd_level": 1011,
          "humidity": 72,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 99},
        "wind": {"speed": 3.61, "deg": 348, "gust": 4.55},
        "visibility": 10000,
        "pop": 0.11,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-29 06:00:00"
      },
      {
        "dt": 1674982800,
        "main": {
          "temp": 278.48,
          "feels_like": 275.7,
          "temp_min": 278.48,
          "temp_max": 278.48,
          "pressure": 1021,
          "sea_level": 1021,
          "grnd_level": 1011,
          "humidity": 65,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 64},
        "wind": {"speed": 3.52, "deg": 340, "gust": 3.86},
        "visibility": 10000,
        "pop": 0.07,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-29 09:00:00"
      },
      {
        "dt": 1674993600,
        "main": {
          "temp": 278.54,
          "feels_like": 275.14,
          "temp_min": 278.54,
          "temp_max": 278.54,
          "pressure": 1020,
          "sea_level": 1020,
          "grnd_level": 1010,
          "humidity": 66,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 79},
        "wind": {"speed": 4.65, "deg": 348, "gust": 4.78},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-29 12:00:00"
      },
      {
        "dt": 1675004400,
        "main": {
          "temp": 278.14,
          "feels_like": 274.94,
          "temp_min": 278.14,
          "temp_max": 278.14,
          "pressure": 1020,
          "sea_level": 1020,
          "grnd_level": 1010,
          "humidity": 66,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 4.1, "deg": 359, "gust": 4.63},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-29 15:00:00"
      },
      {
        "dt": 1675015200,
        "main": {
          "temp": 277.92,
          "feels_like": 275.13,
          "temp_min": 277.92,
          "temp_max": 277.92,
          "pressure": 1021,
          "sea_level": 1021,
          "grnd_level": 1011,
          "humidity": 64,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 3.36, "deg": 2, "gust": 4},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-29 18:00:00"
      },
      {
        "dt": 1675026000,
        "main": {
          "temp": 277.9,
          "feels_like": 275.47,
          "temp_min": 277.9,
          "temp_max": 277.9,
          "pressure": 1021,
          "sea_level": 1021,
          "grnd_level": 1011,
          "humidity": 62,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 100},
        "wind": {"speed": 2.85, "deg": 6, "gust": 4.11},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-29 21:00:00"
      },
      {
        "dt": 1675036800,
        "main": {
          "temp": 277.91,
          "feels_like": 275.44,
          "temp_min": 277.91,
          "temp_max": 277.91,
          "pressure": 1021,
          "sea_level": 1021,
          "grnd_level": 1011,
          "humidity": 57,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 97},
        "wind": {"speed": 2.9, "deg": 2, "gust": 4.11},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-30 00:00:00"
      },
      {
        "dt": 1675047600,
        "main": {
          "temp": 277,
          "feels_like": 274.27,
          "temp_min": 277,
          "temp_max": 277,
          "pressure": 1020,
          "sea_level": 1020,
          "grnd_level": 1010,
          "humidity": 62,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04n"
          }
        ],
        "clouds": {"all": 78},
        "wind": {"speed": 3.01, "deg": 360, "gust": 4.43},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-30 03:00:00"
      },
      {
        "dt": 1675058400,
        "main": {
          "temp": 276.79,
          "feels_like": 275.21,
          "temp_min": 276.79,
          "temp_max": 276.79,
          "pressure": 1020,
          "sea_level": 1020,
          "grnd_level": 1010,
          "humidity": 63,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04d"
          }
        ],
        "clouds": {"all": 62},
        "wind": {"speed": 1.76, "deg": 10, "gust": 2.61},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-30 06:00:00"
      },
      {
        "dt": 1675069200,
        "main": {
          "temp": 278.9,
          "feels_like": 277.38,
          "temp_min": 278.9,
          "temp_max": 278.9,
          "pressure": 1019,
          "sea_level": 1019,
          "grnd_level": 1009,
          "humidity": 52,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 801,
            "main": "Clouds",
            "description": "few clouds",
            "icon": "02d"
          }
        ],
        "clouds": {"all": 19},
        "wind": {"speed": 2.01, "deg": 31, "gust": 2.09},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-30 09:00:00"
      },
      {
        "dt": 1675080000,
        "main": {
          "temp": 279.96,
          "feels_like": 279.96,
          "temp_min": 279.96,
          "temp_max": 279.96,
          "pressure": 1016,
          "sea_level": 1016,
          "grnd_level": 1007,
          "humidity": 47,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 802,
            "main": "Clouds",
            "description": "scattered clouds",
            "icon": "03d"
          }
        ],
        "clouds": {"all": 30},
        "wind": {"speed": 0.74, "deg": 13, "gust": 1.43},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-30 12:00:00"
      },
      {
        "dt": 1675090800,
        "main": {
          "temp": 279.07,
          "feels_like": 277.31,
          "temp_min": 279.07,
          "temp_max": 279.07,
          "pressure": 1015,
          "sea_level": 1015,
          "grnd_level": 1005,
          "humidity": 54,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 802,
            "main": "Clouds",
            "description": "scattered clouds",
            "icon": "03d"
          }
        ],
        "clouds": {"all": 47},
        "wind": {"speed": 2.3, "deg": 36, "gust": 2.37},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-30 15:00:00"
      },
      {
        "dt": 1675101600,
        "main": {
          "temp": 277.88,
          "feels_like": 275.6,
          "temp_min": 277.88,
          "temp_max": 277.88,
          "pressure": 1014,
          "sea_level": 1014,
          "grnd_level": 1004,
          "humidity": 63,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 802,
            "main": "Clouds",
            "description": "scattered clouds",
            "icon": "03n"
          }
        ],
        "clouds": {"all": 27},
        "wind": {"speed": 2.65, "deg": 50, "gust": 3.25},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-30 18:00:00"
      },
      {
        "dt": 1675112400,
        "main": {
          "temp": 277.39,
          "feels_like": 277.39,
          "temp_min": 277.39,
          "temp_max": 277.39,
          "pressure": 1013,
          "sea_level": 1013,
          "grnd_level": 1003,
          "humidity": 66,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 6},
        "wind": {"speed": 1.19, "deg": 62, "gust": 1.79},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-30 21:00:00"
      },
      {
        "dt": 1675123200,
        "main": {
          "temp": 276.99,
          "feels_like": 276.99,
          "temp_min": 276.99,
          "temp_max": 276.99,
          "pressure": 1012,
          "sea_level": 1012,
          "grnd_level": 1002,
          "humidity": 68,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 5},
        "wind": {"speed": 0.39, "deg": 34, "gust": 0.51},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-31 00:00:00"
      },
      {
        "dt": 1675134000,
        "main": {
          "temp": 276.61,
          "feels_like": 276.61,
          "temp_min": 276.61,
          "temp_max": 276.61,
          "pressure": 1011,
          "sea_level": 1011,
          "grnd_level": 1001,
          "humidity": 69,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          }
        ],
        "clouds": {"all": 3},
        "wind": {"speed": 0.64, "deg": 319, "gust": 0.74},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "n"},
        "dt_txt": "2023-01-31 03:00:00"
      },
      {
        "dt": 1675144800,
        "main": {
          "temp": 276.6,
          "feels_like": 276.6,
          "temp_min": 276.6,
          "temp_max": 276.6,
          "pressure": 1012,
          "sea_level": 1012,
          "grnd_level": 1002,
          "humidity": 67,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
          }
        ],
        "clouds": {"all": 6},
        "wind": {"speed": 0.51, "deg": 347, "gust": 0.63},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-31 06:00:00"
      },
      {
        "dt": 1675155600,
        "main": {
          "temp": 279.07,
          "feels_like": 278.07,
          "temp_min": 279.07,
          "temp_max": 279.07,
          "pressure": 1012,
          "sea_level": 1012,
          "grnd_level": 1003,
          "humidity": 55,
          "temp_kf": 0
        },
        "weather": [
          {
            "id": 801,
            "main": "Clouds",
            "description": "few clouds",
            "icon": "02d"
          }
        ],
        "clouds": {"all": 11},
        "wind": {"speed": 1.56, "deg": 297, "gust": 2.2},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2023-01-31 09:00:00"
      }
    ],
    "city": {
      "id": 745042,
      "name": "Istanbul",
      "coord": {"lat": 41.0351, "lon": 28.9833},
      "country": "TR",
      "population": 11581707,
      "timezone": 10800,
      "sunrise": 1674710429,
      "sunset": 1674745935
    }
  }
];

List<Map<String, dynamic>> favList = [];

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_weather_app/utils/constants.dart';
import 'package:weather_icons/weather_icons.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  DateFormat format = DateFormat.EEEE('tr');
  DateFormat hourFormat = DateFormat.Hm();
  DateFormat dayformat = DateFormat.EEEE('tr');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: PageView.builder(
        itemCount: cityNames.length,
        itemBuilder: (context, index) {
          return mainWidget(size, index);
        },
      ),
    );
  }

  Widget mainWidget(Size size, index) {
    return Stack(
      children: [
        backgroundWidget(size),
        Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        locationData.latitude != null &&
                                    locationData.longitude != null ||
                                weatherData != null
                            ? Column(
                                children: [
                                  homePageIconWidget(index),
                                  homePageWeatherDegreeWidget(index),
                                  homePageCityWidget(index),
                                  homePageDayWidget(index)
                                ],
                              )
                            : deniedTextWidget()
                      ],
                    ),
                    // locationData.latitude != null &&
                    //             locationData.longitude != null ||
                    //         weatherData != null
                    //     ?
                    Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        todayListViewBuilderWidget(),
                        // dailyListViewBuilderWidget(),
                        // todayContainerWidget(size)
                      ],
                    )
                    // : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
        // isLoading == IsLoading.loading ? loadingWidget() : const SizedBox(),
        // favoriteButtonWidget(),
      ],
    );
  }

  Widget backgroundWidget(size) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color.fromARGB(255, 206, 203, 203),
            Color.fromARGB(255, 78, 76, 76),
          ])),
    );
  }

  Widget homePageWeatherDegreeWidget(index) {
    return Container(
      child: celFah == Temperature.fahrenheit
          ? Text(
              (((favList[index]['list'][0]['main']['temp']) - 273.15) * 9 / 5 +
                          32)
                      .toInt()
                      .toString() +
                  degree,
              style: const TextStyle(fontSize: 40),
            )
          : Text(
              ((((favList[index]['list'][0]['main']['temp']) - 273.15).toInt())
                      .toString()) +
                  degree,
              style: const TextStyle(fontSize: 40),
            ),
    );
  }

  Widget homePageCityWidget(index) {
    return Container(
      child: Text(
        favList[index]['city']['name'],
        style: const TextStyle(fontSize: 40),
      ),
    );
  }

  Widget homePageDayWidget(index) {
    DateTime day = DateTime.fromMillisecondsSinceEpoch(
        favList[index]['list'][0]['dt'] * 1000,
        isUtc: true);
    gunAdi = format.format(day);
    return Container(
      child: Text(gunAdi),
    );
  }

  Widget homePageIconWidget(index) {
    return Container(
      child: Image.network(
        'http://openweathermap.org/img/wn/${favList[index]['list'][0]['weather'][0]['icon']}@2x.png',
      ),
    );
  }

  // Widget homePageDayWidget() {
  //   DateTime day = DateTime.fromMillisecondsSinceEpoch(
  //       weatherData['list'][0]['dt'] * 1000,
  //       isUtc: true);
  //   gunAdi = format.format(day);
  //   return Container(
  //     child: Text(gunAdi),
  //   );
  // }

  Widget deniedTextWidget() {
    return const Text('Lütfen Konum izni verin yada bir şehir girin.');
  }

  Widget todayListViewBuilderWidget() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: hourlyWeatherFavList.length,
        itemBuilder: (context, index) {
          DateTime hour = DateTime.fromMillisecondsSinceEpoch(
              hourlyWeatherFavList[index]['dt'] * 1000,
              isUtc: true);
          hourly = hourFormat.format(hour);
          return Padding(
            padding: const EdgeInsets.only(right: 30, left: 20),
            child: Container(
              width: 90,
              child: Column(
                children: [
                  hourlyWeatherFavList[index] == hourlyWeatherFavList[0]
                      ? Text('Şimdi')
                      : Text(hourly),
                  Image.network(
                    'http://openweathermap.org/img/wn/${hourlyWeatherFavList[index]['weather'][0]['icon']}@2x.png',
                    scale: 2,
                  ),
                  celFah == Temperature.fahrenheit
                      ? Text(
                          ((((hourlyWeatherFavList[index]['main']['temp']) -
                                                  273.15) *
                                              9 /
                                              5 +
                                          32)
                                      .toInt())
                                  .toString() +
                              degree,
                          style: const TextStyle(fontSize: 15))
                      : Text(
                          (((hourlyWeatherFavList[index]['main']['temp'] -
                                          273.15))
                                      .toInt())
                                  .toString() +
                              degree,
                          style: const TextStyle(fontSize: 15)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        WeatherIcons.strong_wind,
                        size: 15,
                      ),
                      Text(((hourlyWeatherFavList[index]['wind']['speed']))
                              .toStringAsFixed(2) +
                          ' m/s'),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

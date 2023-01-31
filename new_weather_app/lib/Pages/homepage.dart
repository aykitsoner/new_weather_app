import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_service/keyboard_service.dart';
import 'package:new_weather_app/API/cityApi.dart';
import 'package:new_weather_app/API/weatherApi.dart';
import 'package:new_weather_app/Pages/favoritespage.dart';
import 'package:new_weather_app/Pages/weatherpage.dart';
import 'package:new_weather_app/service/auth_service.dart';
import 'package:new_weather_app/utils/constants.dart';
import 'package:new_weather_app/utils/generalfunctions.dart';
import 'package:new_weather_app/utils/hourlyfunction.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_icons/weather_icons.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final authService = AuthService();
  final TextEditingController _textEditingController = TextEditingController();
  // String city = '';
  final List<String> _suggestions = [];
  // String gunAdi = '';
  // String hourly = '';
  // String dayName = '';
  // String sunrisetime = '';
  // String sunsettime = '';

  DateFormat format = DateFormat.EEEE('tr');
  DateFormat hourFormat = DateFormat.Hm();
  DateFormat dayformat = DateFormat.EEEE('tr');

  cityfunc() async {
    await CityApi().getCity();
    final result = await authService.signAnonymous();
  }

  bool isFavorited() {
    print(weatherData['city']['name']);
    final cityName = weatherData['city']['name'];
    return cityNames.contains(cityName);
  }

  _getCityNames() async {
    cityNames = [];
    final firebaseAuth = FirebaseAuth.instance;
    final result = await firebaseAuth.signInAnonymously();
    final user = result.user;
    await FirebaseFirestore.instance
        .collection("cities")
        .doc(user!.uid)
        .collection("fav")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final cityName = doc.data()['cityname'];
        if (cityName != null) {
          cityNames.add(cityName);
        }
      });
    });
    print(cityNames);
    setState(() {});
  }

  @override
  void initState() {
    initializeDateFormatting();

    _textEditingController.addListener(() {
      if (_textEditingController.text.isEmpty) {
        setState(() {
          _suggestions.clear();
        });
      } else {
        setState(() {
          _suggestions.clear();
          allcities.forEach((item) {
            if (item
                .toLowerCase()
                .startsWith(_textEditingController.text.toLowerCase())) {
              _suggestions.add(item);
            }
          });
        });
      }
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    cityfunc();
    _getCityNames();
    isFavorited();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    var status = await Permission.location.status;

    if (state == AppLifecycleState.resumed) {
      if (status == PermissionStatus.granted) {
        setState(() {
          isLoading = IsLoading.loading;
        });
        await getLocationData();
        await WeatherApi().getWeather(query: {
          'lat': locationData.latitude.toString(),
          'lon': locationData.longitude.toString()
        });
        if (locationData.latitude != null && locationData.longitude != null) {
          await GeneralFunctions().fiveDaysData();
          await HourlyFuntion().hourlyWeatherData();
        }

        setState(() {
          isLoading = IsLoading.completed;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return KeyboardAutoDismiss(
      scaffold: Scaffold(
        resizeToAvoidBottomInset: false,
        body: mainWidget(size),
      ),
    );
  }

  Widget mainWidget(Size size) {
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
                                  homePageIconWidget(),
                                  homePageWeatherDegreeWidget(),
                                  homePageCityWidget(),
                                  homePageDayWidget()
                                ],
                              )
                            : deniedTextWidget()
                      ],
                    ),
                    locationData.latitude != null &&
                                locationData.longitude != null ||
                            weatherData != null
                        ? Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              todayListViewBuilderWidget(),
                              dailyListViewBuilderWidget(),
                              todayContainerWidget(size)
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                autoComplateCities(),
                Row(
                  children: [
                    locationButtonWidget(),
                    const SizedBox(
                      width: 5,
                    ),
                    popUpWidget()
                  ],
                ),
              ],
            ),
          ],
        ),
        isLoading == IsLoading.loading ? loadingWidget() : const SizedBox(),
        favoriteButtonWidget(),
      ],
    );
  }

  Widget loadingWidget() {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height,
          color: Colors.black54,
        ),
        const Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(),
          ),
        )
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

  Widget locationButtonWidget() {
    return InkWell(
        onTap: () async {
          setState(() {
            isLoading = IsLoading.loading;
          });
          if (favList.isEmpty) {
            for (var element in cityNames) {
              await Future.delayed(Duration(milliseconds: 2000), () {});
              print('Fav şehir: $element');
              await WeatherApi().getWeatherCityFav(query: {'q': element});
              //print('Apiden Gelen Data: $weatherData');
              favList.add(weatherDataFav);
              // print('Fav List: $favList');
            }
          }
          setState(() {
            isLoading = IsLoading.completed;
          });
          print(favList[0]);

          HourlyFuntion().hourlyFavWeatherData();

          return;
          PermissionStatus locationStatus = await Permission.location.request();
          if (locationStatus == PermissionStatus.granted) {
            if (weatherData['city']['coord']['lat'].toInt() !=
                    locationData.latitude?.toInt() &&
                weatherData['city']['coord']['lon'].toInt() !=
                    locationData.longitude?.toInt()) {
              setState(() {
                isLoading = IsLoading.loading;
              });
              await getLocationData();
              print('object');
              await WeatherApi().getWeather(
                query: {
                  'lat': locationData.latitude.toString(),
                  'lon': locationData.longitude.toString(),
                },
              );
              if (locationData.latitude != null &&
                  locationData.longitude != null) {
                await GeneralFunctions().fiveDaysData();
                await HourlyFuntion().hourlyWeatherData();
              }
              setState(() {
                isLoading = IsLoading.completed;
              });
            }
          }
          if (locationStatus == PermissionStatus.denied) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Konum izini vermeniz gerekmektedir.')));
          }
          if (locationStatus == PermissionStatus.permanentlyDenied) {
            AlertDialog alert = AlertDialog(
              title: const Text("Bilgilendirme"),
              content: const Text("Konum İzni Vermeniz Gerekmektedir."),
              actions: [
                InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      openAppSettings();
                    },
                    child: Container(
                      child: const Text('Ayarlar'),
                    )),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      child: const Text('Vazgeç'),
                    ))
              ],
            );
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          }
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
          child: const Icon(color: Colors.white, Icons.location_on_outlined),
        ));
  }

  Widget homePageWeatherDegreeWidget() {
    return Container(
      child: celFah == Temperature.fahrenheit
          ? Text(
              (((weatherData['list'][0]['main']['temp']) - 273.15) * 9 / 5 + 32)
                      .toInt()
                      .toString() +
                  degree,
              style: const TextStyle(fontSize: 40),
            )
          : Text(
              ((((weatherData['list'][0]['main']['temp']) - 273.15).toInt())
                      .toString()) +
                  degree,
              style: const TextStyle(fontSize: 40),
            ),
    );
  }

  Widget homePageCityWidget() {
    return Container(
      child: Text(
        weatherData['city']['name'],
        style: const TextStyle(fontSize: 40),
      ),
    );
  }

  Widget homePageIconWidget() {
    return Container(
      child: Image.network(
        'http://openweathermap.org/img/wn/${lastWeatherList[selectedIndex]['weather'][0]['icon']}@2x.png',
      ),
    );
  }

  Widget homePageDayWidget() {
    DateTime day = DateTime.fromMillisecondsSinceEpoch(
        weatherData['list'][0]['dt'] * 1000,
        isUtc: true);
    gunAdi = format.format(day);
    return Container(
      child: Text(gunAdi),
    );
  }

  Widget deniedTextWidget() {
    return const Text('Lütfen Konum izni verin yada bir şehir girin.');
  }

  Widget autoComplateCities() {
    return Column(
      children: [
        Container(
          width: 210,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black)),
          child: TextField(
            onSubmitted: (value) async {
              city = value;
              setState(() {});
              if (city.isEmpty) {
                AlertDialog alert = AlertDialog(
                  title: const Text("Uyarı"),
                  content: const Text("Lütfen Bir Şehir Giriniz"),
                  actions: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          child: const Text('Tamam'),
                        ))
                  ],
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              } else {
                try {
                  setState(() {
                    isLoading = IsLoading.loading;
                  });
                  await WeatherApi().getWeatherCity(query: {'q': city});
                  await GeneralFunctions().fiveDaysData();
                  await HourlyFuntion().hourlyWeatherData();
                  setState(() {
                    isLoading = IsLoading.completed;
                  });
                } catch (e) {
                  AlertDialog alert = AlertDialog(
                    title: const Text("Uyarı"),
                    content: const Text("Şehir Bulunamadı"),
                    actions: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            child: const Text('Tamam'),
                          ))
                    ],
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                }
              }
            },
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: "Şehir Giriniz",
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  city = _textEditingController.text;
                  setState(() {});
                  _textEditingController.clear();
                },
              ),
            ),
          ),
        ),
        Container(
          width: 210,
          height: 200,
          child: ListView.builder(
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_suggestions[index]),
                onTap: () async {
                  setState(() {
                    _textEditingController.text = _suggestions[index];
                    city = _textEditingController.text;
                    print(city);
                    _suggestions.clear();
                    _textEditingController.clear();
                  });
                  FocusScope.of(context).unfocus();
                  if (city.isEmpty) {
                    AlertDialog alert = AlertDialog(
                      title: const Text("Uyarı"),
                      content: const Text("Lütfen Bir Şehir Giriniz"),
                      actions: [
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              child: const Text('Tamam'),
                            ))
                      ],
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  } else {
                    try {
                      setState(() {
                        isLoading = IsLoading.loading;
                      });
                      await WeatherApi().getWeatherCity(query: {'q': city});
                      await GeneralFunctions().fiveDaysData();
                      await HourlyFuntion().hourlyWeatherData();
                      setState(() {
                        selectedIndex = 0;
                        isLoading = IsLoading.completed;
                      });
                    } catch (e) {
                      AlertDialog alert = AlertDialog(
                        title: const Text("Uyarı"),
                        content: const Text("Şehir Bulunamadı"),
                        actions: [
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                child: const Text('Tamam'),
                              ))
                        ],
                      );
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    }
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget todayListViewBuilderWidget() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: hourlyWeatherList.length,
        itemBuilder: (context, index) {
          DateTime hour = DateTime.fromMillisecondsSinceEpoch(
              hourlyWeatherList[index]['dt'] * 1000,
              isUtc: true);
          hourly = hourFormat.format(hour);
          return Padding(
            padding: const EdgeInsets.only(right: 30, left: 20),
            child: Container(
              width: 90,
              child: Column(
                children: [
                  hourlyWeatherList[index] == hourlyWeatherList[0]
                      ? Text('Şimdi')
                      : Text(hourly),
                  Image.network(
                    'http://openweathermap.org/img/wn/${hourlyWeatherList[index]['weather'][0]['icon']}@2x.png',
                    scale: 2,
                  ),
                  celFah == Temperature.fahrenheit
                      ? Text(
                          ((((hourlyWeatherList[index]['main']['temp']) -
                                                  273.15) *
                                              9 /
                                              5 +
                                          32)
                                      .toInt())
                                  .toString() +
                              degree,
                          style: const TextStyle(fontSize: 15))
                      : Text(
                          (((hourlyWeatherList[index]['main']['temp'] - 273.15))
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
                      Text(((hourlyWeatherList[index]['wind']['speed']))
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

  Widget dailyListViewBuilderWidget() {
    return Container(
      height: 270,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: lastWeatherList.length,
        itemBuilder: (context, index) {
          DateTime day = DateTime.fromMillisecondsSinceEpoch(
              lastWeatherList[index]['dt'] * 1000,
              isUtc: true);

          gunAdi = format.format(day);

          return Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.network(
                        'http://openweathermap.org/img/wn/${lastWeatherList[index]['weather'][0]['icon']}@2x.png',
                        scale: 2,
                      ),
                      lastWeatherList[index] == lastWeatherList[0]
                          ? Text(gunAdi)
                          : Text(gunAdi),
                    ],
                  ),
                  celFah == Temperature.fahrenheit
                      ? Text(
                          ((((lastWeatherList[index]['main']['temp']) -
                                                  273.15) *
                                              9 /
                                              5 +
                                          32)
                                      .toInt())
                                  .toString() +
                              degree,
                          style: const TextStyle(fontSize: 20))
                      : Text(
                          (((lastWeatherList[index]['main']['temp'] - 273.15))
                                      .toInt())
                                  .toString() +
                              degree,
                          style: const TextStyle(fontSize: 20)),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget todayContainerWidget(size) {
    DateTime sunrise = DateTime.fromMillisecondsSinceEpoch(
        weatherData['city']['sunrise'] * 1000,
        isUtc: true);
    DateTime sunset = DateTime.fromMillisecondsSinceEpoch(
        weatherData['city']['sunset'] * 1000,
        isUtc: true);
    sunrisetime = hourFormat.format(sunrise);
    sunsettime = hourFormat.format(sunset);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 300,
        width: size.width,
        decoration: BoxDecoration(
            // color: Colors.amber,
            border:
                Border.all(color: Color.fromARGB(255, 71, 71, 71), width: 3),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(WeatherIcons.sunrise),
                    SizedBox(height: 10),
                    Text('Gün Doğumu ' + sunrisetime),
                  ],
                ),
                Column(
                  children: [
                    Icon(WeatherIcons.sunset),
                    SizedBox(height: 10),
                    Text('Gün Batımı ' + sunsettime),
                  ],
                )
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(WeatherIcons.thermometer),
                    SizedBox(height: 10),
                    celFah == Temperature.fahrenheit
                        ? Text('Hissedilen ' +
                            ((weatherData['list'][0]['main']['feels_like'] -
                                            273.15) *
                                        9 /
                                        5 +
                                    32)
                                .toInt()
                                .toString() +
                            degree)
                        : Text('Hissedilen ' +
                            ((weatherData['list'][0]['main']['feels_like'] -
                                        273.15)
                                    .toInt())
                                .toString() +
                            degree)
                  ],
                ),
                Column(
                  children: [
                    Icon(WeatherIcons.humidity),
                    SizedBox(height: 10),
                    Text('Nem ' +
                        weatherData['list'][0]['main']['humidity'].toString() +
                        '%'),
                  ],
                )
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(WeatherIcons.raindrops),
                    SizedBox(height: 10),
                    Text('Yağmur İhtimali ' +
                        (weatherData['list'][0]['pop'] * 100)
                            .toInt()
                            .toString() +
                        '%'),
                  ],
                ),
                Column(
                  children: [
                    const Icon(WeatherIcons.strong_wind),
                    const SizedBox(height: 10),
                    Text('Rüzgar Hızı ' +
                        ((weatherData['list'][0]['wind']['speed']))
                            .toStringAsFixed(2) +
                        ' m/s'),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget popUpWidget() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10)),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == '0') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesPage()),
            );
          }
        },
        icon: const Icon(Icons.more_vert, color: Colors.white),
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
          PopupMenuItem<String>(
            value: 'option1',
            child: const Text('Fahrenheit'),
            onTap: () {
              celFah = Temperature.fahrenheit;
              degree = '°F';
              setState(() {});
            },
          ),
          PopupMenuItem<String>(
            value: 'option2',
            child: const Text('Celsius'),
            onTap: () {
              celFah = Temperature.celsius;
              degree = '°C';
              setState(() {});
            },
          ),
          PopupMenuItem<String>(
            value: '0',
            child: const Text('Favoriler'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget favoriteButtonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.favorite,
                  color:
                      //Colors.white,
                      isFavorited() == true ? Colors.red : Colors.white,
                ),
                onPressed: () async {
                  final firebaseAuth = FirebaseAuth.instance;
                  final result = await firebaseAuth.signInAnonymously();
                  final user = result.user;
                  final cityName = weatherData["city"]["name"];

                  await FirebaseFirestore.instance
                      .collection("cities")
                      .doc(user!.uid)
                      .collection("fav")
                      .where("cityname", isEqualTo: cityName)
                      .get()
                      .then((querySnapshot) {
                    if (querySnapshot.docs.isEmpty) {
                      print('Şehir Favorilere Eklendi');
                      // Şehir bulunamadı, koleksiyona ekleyin
                      final userCollection = <String, String>{
                        "cityname": cityName,
                      };
                      FirebaseFirestore.instance
                          .collection("cities")
                          .doc(user.uid)
                          .collection("fav")
                          .add(userCollection);
                      setState(() {});
                    } else {
                      // Şehir zaten koleksiyonda mevcut
                      print(
                          "Şehir zaten koleksiyonda mevcut Favoriden kaldırıldı.");
                      // Şehir zaten koleksiyonda mevcut, silin
                      final cityRef = querySnapshot.docs.first.reference;
                      cityRef.delete();
                      setState(() {});
                    }
                  });
                  await _getCityNames();
                  print('------$cityNames');
                  isFavorited();
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

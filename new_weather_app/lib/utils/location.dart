import 'package:location/location.dart';
import 'package:new_weather_app/utils/constants.dart';

class LocationHelper {
  double? latitude;
  double? longitude;
  Future<dynamic> getCurrentLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
    //konum izni
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    } else {
      _locationData = await location.getLocation();

      latitude = _locationData.latitude;
      longitude = _locationData.longitude;
    }
  }
}

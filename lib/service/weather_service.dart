import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/model/weather_class.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASIC_URL= 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final uri= "$BASIC_URL?q=$cityName&appid=$apiKey&units=metric";
    final response= await http.get(Uri.parse(uri));

    if(response.statusCode== 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Falied to load weather data');
    }
  }

  Future<String> getCity() async {
    //know the status of permission access
    LocationPermission permission= await Geolocator.checkPermission();

    //fetch current permission
    if(permission== LocationPermission.denied) {
      permission= await Geolocator.requestPermission();
    }

    //fetch the location from user
    Position currentPostion= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    //convert the location into list of placemark objects
    List<Placemark> placemarks= await placemarkFromCoordinates(currentPostion.latitude, currentPostion.longitude);

    //extract city from first placemark object
    String? city= placemarks[0].locality;

    return city??"";
  }
}
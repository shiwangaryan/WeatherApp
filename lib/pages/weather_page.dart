import 'package:flutter/material.dart';
import 'package:weatherapp/constants.dart';
import 'package:weatherapp/model/weather_class.dart';
import 'package:weatherapp/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService(API_KEY);
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    final cityName = await _weatherService.getCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animation

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? 'loading city...'),

            //temperature
            Text('${_weather?.temperature.round()} C'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny_animation.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy_animation.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain_animation.json';
      case 'thunderstorm':
        return 'assets/thunder_animation.json';
      case 'clear':
        return 'assets/sunny_animation.json';
      default:
        return 'assets/sunny_animation.json';
    }
  }

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

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            //temperature
            Text('${_weather?.temperature.round()} C'),

            //weather condition
            Text(_weather?.mainCondition ?? "loading weather condition...")
          ],
        ),
      ),
    );
  }
}

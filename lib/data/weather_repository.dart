import 'dart:math';

import 'package:flutter_bloc_app_example/model/weather.dart';
import 'package:flutter_bloc_app_example/service/exception/NetworkException.dart';

abstract class WeatherRepository {
  Future<Weather> fetchWeather(String cityName);
}

class FakeWeatherRepository implements WeatherRepository {
  @override
  Future<Weather> fetchWeather(String cityName) {
    // TODO: implement fetchWeather
    return Future.delayed(Duration(seconds: 1), () {
      final random = Random();
      if (random.nextBool()) {
        throw NetworkException();
      }
      return Weather(
        cityName: cityName,
        temperatureCelsius: 20 + random.nextInt(15) + random.nextDouble(),
      );
    });
  }
}

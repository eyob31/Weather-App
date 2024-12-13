import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';

import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "http://api.openweathermap.org/data/2.5/weather";
  final String apiKey;
  // $BASE_URL?q=$cityName&appid=$apiKey&units=metric
  WeatherService(this.apiKey);

  // Fetch the Weather
  Future<Weather> fetchWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Weather data");
    }
  }

  // Get City Name
  Future<String> getCurrentCityName() async {
    // get permission from the user
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    // fetch current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    // convert the location into a list of placemark objects
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // Extract the city name from the first placemark
    String? city = placemark[0].locality;

    return city ?? " ";
  }
}

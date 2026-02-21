import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRequests {
  ApiRequests._();

  static final String apiKey = dotenv.env['API_KEY'] ?? "";
  static const baseUrl = "https://api.openweathermap.org/data/2.5/";

  static String currentConditionUrl({
    required String city,
  }) {
    return "${baseUrl}weather?q=$city&appid=$apiKey&units=metric";
  }

  static String fiveDaysForecastUrl({
    required String city,
  }) {
    return "${baseUrl}forecast?q=$city&appid=$apiKey&units=metric";
  }

  static String currentConditionUrlByLocation({
    required double lat,
    required double lon,
  }) {
    return "${baseUrl}weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric";
  }

  static String fiveDaysForecastUrlByLocation({
    required double lat,
    required double lon,
  }) {
    return "${baseUrl}forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric";
  }

  static String airPollutionUrl({
    required double lat,
    required double lon,
  }) {
    return "${baseUrl}air_pollution?lat=$lat&lon=$lon&appid=$apiKey";
  }
}

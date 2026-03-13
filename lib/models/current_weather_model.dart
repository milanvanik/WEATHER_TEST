import 'package:skycast/models/temperature_model.dart';

class CurrentWeatherModel {
  final DateTime localObservationDateTime;
  final String weatherText;
  final TemperatureModel temperature;
  final String mobileLink;

  CurrentWeatherModel({
    required this.localObservationDateTime,
    required this.weatherText,
    required this.temperature,
    required this.mobileLink,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) =>
      CurrentWeatherModel(
        localObservationDateTime:
            DateTime.parse(json["LocalObservationDateTime"]),
        weatherText: json["WeatherText"],
        temperature: TemperatureModel.fromJson(
            json["Temperature"] as Map<String, dynamic>),
        mobileLink: json["MobileLink"],
      );

  Map<String, dynamic> toJson() => {
        "LocalObservationDateTime": localObservationDateTime.toIso8601String(),
        "WeatherText": weatherText,
        "Temperature": temperature.toJson(),
        "MobileLink": mobileLink,
      };
}

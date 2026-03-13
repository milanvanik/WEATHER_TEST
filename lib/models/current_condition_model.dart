import 'dart:convert';

import 'package:skycast/models/country_code_model.dart';
import 'package:skycast/models/temp_main_model.dart';
import 'package:skycast/models/weather_main_model.dart';
import 'package:skycast/models/wind_model.dart';

CurrentConditionModel currentConditionModelFromJson(String str) =>
    CurrentConditionModel.fromJson(json.decode(str));

String currentConditionModelToJson(CurrentConditionModel data) =>
    json.encode(data.toJson());

class CurrentConditionModel {
  final List<WeatherMainModel> weather;
  final TempMainModel main;
  final int visibility;
  final WindModel wind;
  final CountryCodeModel countryCode;
  final String name;

  CurrentConditionModel({
    required this.weather,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.name,
    required this.countryCode,
  });

  factory CurrentConditionModel.fromJson(Map<String, dynamic> json) =>
      CurrentConditionModel(
        weather: List<WeatherMainModel>.from(
            json["weather"].map((x) => WeatherMainModel.fromJson(x))),
        main: TempMainModel.fromJson(json["main"]),
        visibility: json["visibility"],
        wind: WindModel.fromJson(json["wind"]),
        name: json["name"],
        countryCode: json["cod"],
      );

  Map<String, dynamic> toJson() => {
        "weather": List<dynamic>.from(weather.map((x) => x.toJson())),
        "main": main.toJson(),
        "visibility": visibility,
        "wind": wind.toJson(),
        "name": name,
        "cod": countryCode,
      };
}

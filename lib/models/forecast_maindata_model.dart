import 'package:skycast/models/forecast_temp_model.dart';
import 'package:skycast/models/weather_main_model.dart';
import 'package:skycast/models/wind_model.dart';

class ForecastMaindataModel {
  final ForecastTempModel main;
  final WindModel wind;
  final String dtTxt;
  final List<WeatherMainModel> weather;

  ForecastMaindataModel({
    required this.main,
    required this.wind,
    required this.dtTxt,
    required this.weather,
  });

  factory ForecastMaindataModel.fromJson(Map<String, dynamic> json) =>
      ForecastMaindataModel(
        main: ForecastTempModel.fromJson(json["main"] as Map<String, dynamic>),
        wind: WindModel.fromJson(json["wind"] as Map<String, dynamic>),
        dtTxt: json["dt_txt"] ?? "",
        weather: json["weather"] == null
            ? []
            : List<WeatherMainModel>.from((json["weather"] as List)
                .map((x) => WeatherMainModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "main": main.toJson(),
        "wind": wind.toJson(),
        "dt_txt": dtTxt,
        "weather": List<dynamic>.from(weather.map((x) => x.toJson())),
      };
}

import 'package:skycast/models/forecast/temp_values_model.dart';

class ForecastTempModel {
  final TempValuesModel minimum;
  final TempValuesModel maximum;

  ForecastTempModel({
    required this.minimum,
    required this.maximum,
  });

  factory ForecastTempModel.fromJson(Map<String, dynamic> json) =>
      ForecastTempModel(
        minimum:
            TempValuesModel.fromJson(json["Minimum"] as Map<String, dynamic>),
        maximum:
            TempValuesModel.fromJson(json["Maximum"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "Minimum": minimum.toJson(),
        "Maximum": maximum.toJson(),
      };
}

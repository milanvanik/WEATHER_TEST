import 'dart:convert';

import 'package:skycast/models/forecast_maindata_model.dart';

FiveDaysMainForecastModel fiveDaysMainForecastModelFromJson(String str) =>
    FiveDaysMainForecastModel.fromJson(json.decode(str));

String fiveDaysMainForecastModelToJson(FiveDaysMainForecastModel data) =>
    json.encode(data.toJson());

class FiveDaysMainForecastModel {
  final List<ForecastMaindataModel> list;

  FiveDaysMainForecastModel({
    required this.list,
  });

  factory FiveDaysMainForecastModel.fromJson(Map<String, dynamic> json) =>
      FiveDaysMainForecastModel(
        list: List<ForecastMaindataModel>.from(
            json["list"].map((x) => ForecastMaindataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

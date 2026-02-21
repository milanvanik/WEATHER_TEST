import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainWeatherData extends StatelessWidget {
  final String weatherType;
  final String weatherTemp;
  const MainWeatherData(
      {super.key, required this.weatherType, required this.weatherTemp});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "$weatherType ",
        style: TextStyle(
          fontFamily: "MadimiOne",
          fontSize: 24.sp,
          fontWeight: FontWeight.normal,
          color: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.color
              ?.withValues(alpha: 0.8),
        ),
        children: [
          TextSpan(
            text: "$weatherTemp°C",
            style: TextStyle(
              fontFamily: "MadimiOne",
              fontWeight: FontWeight.w300,
              fontSize: 32.sp,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class HourlyForecastCard extends StatelessWidget {
  final String value;
  final String label;
  final String? iconPath;
  final bool isLottie;

  const HourlyForecastCard({
    super.key,
    required this.value,
    required this.label,
    this.iconPath,
    this.isLottie = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconPath != null)
            isLottie
                ? Lottie.asset(iconPath!, width: 52, height: 40)
                : Image.asset(iconPath!, width: 40, height: 40),
          if (iconPath == null) SizedBox(height: 40),
          SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: "MadimiOne",
                fontWeight: FontWeight.w300,
                fontSize: 18.sp,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: "MadimiOne",
              fontWeight: FontWeight.w300,
              fontSize: 14.sp,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

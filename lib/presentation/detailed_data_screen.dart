import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';

class DetailedDataScreen extends StatelessWidget {
  final Map<String, dynamic> currentData;
  final String cityName;
  final String mainWeather;
  final String animatedIcon;
  final Map<String, dynamic>? aqiData;

  const DetailedDataScreen({
    super.key,
    required this.currentData,
    required this.cityName,
    required this.mainWeather,
    required this.animatedIcon,
    this.aqiData,
  });

  @override
  Widget build(BuildContext context) {
    final double temp = (currentData['main']['temp'] ?? 0).toDouble();
    final int humidity = currentData['main']['humidity'] ?? 0;
    final int pressure = currentData['main']['pressure'] ?? 0;
    final double windSpeed = (currentData['wind']['speed'] ?? 0).toDouble();

    final int sunriseTime = currentData['sys']['sunrise'] ?? 0;
    final int sunsetTime = currentData['sys']['sunset'] ?? 0;
    final String sunriseStr = DateFormat('h:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(sunriseTime * 1000));
    final String sunsetStr = DateFormat('h:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(sunsetTime * 1000));

    int aqi = 0;
    if (aqiData != null) {
      final list = aqiData!['list'] as List<dynamic>?;
      if (list != null && list.isNotEmpty) {
        aqi = list[0]['main']['aqi'] ?? 0;
      }
    }

    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with City Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "DETAILED DATA",
                    style: GoogleFonts.oxanium(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: textColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              // Animated Weather Icon
              Center(
                child: Lottie.asset(
                  animatedIcon,
                  width: 200.w,
                  height: 200.h,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 20.h),

              // Giant Temperature and Condition
              Center(
                child: Text(
                  "${temp.round()}°",
                  style: TextStyle(
                    fontFamily: "MadimiOne",
                    fontSize: 80.sp,
                    height: 1.0,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  mainWeather.toUpperCase(),
                  style: GoogleFonts.oxanium(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor.withValues(alpha: 0.8),
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              Spacer(),

              // Grid of detailed stats
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(
                            "WIND", "${windSpeed.round()} km/h", textColor),
                        _buildStatColumn("HUMIDITY", "$humidity%", textColor),
                        _buildStatColumn(
                            "PRESSURE", "${pressure}hPa", textColor),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn("SUNRISE", sunriseStr, textColor),
                        _buildStatColumn("SUNSET", sunsetStr, textColor),
                        _buildStatColumn("AQI", "$aqi / 5", textColor),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),

              // Bottom Row with balancing Placeholder Button and Menu
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 54.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            offset: const Offset(4, 4),
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black.withValues(alpha: 0.4)
                                    : const Color(0xFFA6ABB2)
                                        .withValues(alpha: 0.5),
                            inset: true,
                          ),
                          BoxShadow(
                            blurRadius: 8,
                            offset: const Offset(-4, -4),
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : Colors.white.withValues(alpha: 0.8),
                            inset: true,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "WEATHER INSIGHTS",
                          style: GoogleFonts.oxanium(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: textColor.withValues(alpha: 0.6),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset("assets/svgs/swipe_menu.svg"),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color textColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: "MadimiOne",
            fontSize: 16.sp,
            color: textColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.oxanium(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: textColor.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

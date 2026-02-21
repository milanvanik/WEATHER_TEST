import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:myweatherapp/core/api_requests.dart';
import 'package:myweatherapp/models/fivedays_main_forecast_model.dart';
import 'package:myweatherapp/models/temp_main_model.dart';
import 'package:myweatherapp/models/weather_main_model.dart';
import 'package:myweatherapp/widgets/custom_searchbar.dart';
import 'package:myweatherapp/widgets/get_lottie.dart';
import 'package:myweatherapp/widgets/homescreen_data_card.dart';
import 'package:myweatherapp/widgets/main_weather_data.dart';
import 'package:http/http.dart' as http;
import 'package:myweatherapp/main.dart';
import 'package:myweatherapp/presentation/detailed_data_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherMainModel? weatherDataType;
  TempMainModel? tempDataType;
  FiveDaysMainForecastModel? fiveDaysForecast;
  Map<String, dynamic>? rawCurrentData;

  String cityName = "Delhi";
  bool isLoading = false;

  Future<void> fetchWeatherType() async {
    setState(() {
      isLoading = true;
    });

    final currentResponse = await http.get(
      Uri.parse(ApiRequests.currentConditionUrl(city: cityName)),
    );

    final forecastResponse = await http.get(
      Uri.parse(ApiRequests.fiveDaysForecastUrl(city: cityName)),
    );

    if (currentResponse.statusCode == 200 &&
        forecastResponse.statusCode == 200) {
      final Map<String, dynamic> currentData =
          json.decode(currentResponse.body);
      final Map<String, dynamic> forecastData =
          json.decode(forecastResponse.body);

      rawCurrentData = currentData;

      final weatherList = currentData['weather'] as List<dynamic>;
      final mainWeather = weatherList.isNotEmpty ? weatherList[0] : {};
      final mainTemp = currentData['main'] ?? {};

      weatherDataType = WeatherMainModel.fromJson(mainWeather);
      tempDataType = TempMainModel.fromJson(mainTemp);
      fiveDaysForecast = FiveDaysMainForecastModel.fromJson(forecastData);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Oops! Something went wrong"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherType();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    SizedBox(height: topPadding);

    if (isLoading ||
        weatherDataType == null ||
        tempDataType == null ||
        fiveDaysForecast == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          overflow: TextOverflow.ellipsis,
                          cityName,
                          style: GoogleFonts.oxanium(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withValues(alpha: 0.8),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          child: Switch(
                            value: themeNotifier.value == ThemeMode.dark,
                            onChanged: (value) {
                              themeNotifier.value =
                                  value ? ThemeMode.dark : ThemeMode.light;
                            },
                            activeColor: Colors.white,
                            activeTrackColor: Colors.white24,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.black26,
                            trackOutlineColor:
                                WidgetStateProperty.all(Colors.transparent),
                            thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                                (Set<WidgetState> states) {
                              return const Icon(Icons.circle,
                                  color: Colors.transparent);
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.h,
            ),
            Lottie.asset(
              getLottieAsset(weatherDataType!.main),
              width: 390.w,
              height: 390.h,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 48.h,
            ),
            MainWeatherData(
              weatherType: weatherDataType!.main,
              weatherTemp: tempDataType!.temp.toString(),
            ),
            SizedBox(
              height: 18,
            ),
            HomescreenDataCard(fiveDaysForecast: fiveDaysForecast!),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  CustomSearchbar(
                    cityChanged: (newCity) async {
                      setState(() {
                        cityName = newCity;
                      });
                      await fetchWeatherType();
                    },
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (rawCurrentData == null) return;

                      // Fetch AQI data
                      final lat = rawCurrentData!['coord']?['lat'];
                      final lon = rawCurrentData!['coord']?['lon'];
                      Map<String, dynamic>? aqiMap;

                      if (lat != null && lon != null) {
                        try {
                          final aqiResponse = await http.get(Uri.parse(
                              ApiRequests.airPollutionUrl(
                                  lat: lat.toDouble(), lon: lon.toDouble())));
                          if (aqiResponse.statusCode == 200) {
                            aqiMap = json.decode(aqiResponse.body);
                          }
                        } catch (e) {
                          // Ignore error, aqiMap remains null
                        }
                      }

                      if (!context.mounted) return;

                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  DetailedDataScreen(
                            currentData: rawCurrentData!,
                            cityName: cityName,
                            mainWeather: weatherDataType?.description ??
                                weatherDataType!.main,
                            animatedIcon: getLottieAsset(weatherDataType!.main),
                            aqiData: aqiMap,
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: SvgPicture.asset("assets/svgs/swipe_menu.svg"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h), // Added bottom padding to lift the bar up
          ],
        ),
      ),
    );
  }
}

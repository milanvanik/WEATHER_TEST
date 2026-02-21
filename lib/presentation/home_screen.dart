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
import 'package:myweatherapp/widgets/error_view.dart';
import 'package:myweatherapp/widgets/get_lottie.dart';
import 'package:myweatherapp/widgets/homescreen_data_card.dart';
import 'package:myweatherapp/widgets/main_weather_data.dart';
import 'package:http/http.dart' as http;
import 'package:myweatherapp/main.dart';
import 'package:myweatherapp/presentation/detailed_data_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  final String? initialCity;
  const HomeScreen({
    super.key,
    this.initialCity,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  WeatherMainModel? weatherDataType;
  TempMainModel? tempDataType;
  FiveDaysMainForecastModel? fiveDaysForecast;
  Map<String, dynamic>? rawCurrentData;

  late String cityName;
  bool isLoading = false;
  bool _isWaitingForLocationSettings = false;

  DateTime? lastFetchTime;
  String? lastFetchedCity;
  String? errorMessage;

  Future<void> fetchWeatherType(
      {bool isRefresh = false, Position? position}) async {
    // Cooldown logic for current city to prevent API spam via pull-to-refresh
    if (isRefresh &&
        lastFetchTime != null &&
        lastFetchedCity == cityName &&
        position == null) {
      final difference = DateTime.now().difference(lastFetchTime!);
      if (difference < const Duration(minutes: 5) && errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Weather is up to date! Please wait a few minutes before refreshing again."),
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final currentResponse = await http
          .get(
            Uri.parse(position != null
                ? ApiRequests.currentConditionUrlByLocation(
                    lat: position.latitude, lon: position.longitude)
                : ApiRequests.currentConditionUrl(city: cityName)),
          )
          .timeout(const Duration(seconds: 10));

      final forecastResponse = await http
          .get(
            Uri.parse(position != null
                ? ApiRequests.fiveDaysForecastUrlByLocation(
                    lat: position.latitude, lon: position.longitude)
                : ApiRequests.fiveDaysForecastUrl(city: cityName)),
          )
          .timeout(const Duration(seconds: 10));

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

        if (position != null) {
          cityName = currentData['name'] ?? "Delhi";
        }

        lastFetchTime = DateTime.now();
        lastFetchedCity = cityName;
        SharedPreferences.getInstance()
            .then((prefs) => prefs.setString('last_city', cityName));
      } else if (currentResponse.statusCode == 404 ||
          forecastResponse.statusCode == 404) {
        errorMessage =
            "We couldn't find \"$cityName\".\nPlease check the spelling and try again!";
      } else {
        errorMessage =
            "An unexpected server error occurred.\nPlease try again later.";
      }
    } catch (e) {
      errorMessage =
          "No internet connection.\nPlease check your network and try again!";
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _checkLocationAndFetch() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        bool? enableLocation = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Location Services Disabled'),
            content: const Text(
                'Please enable location services to automatically fetch local weather.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No Thanks'),
              ),
              TextButton(
                onPressed: () {
                  Geolocator.openLocationSettings();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Settings'),
              ),
            ],
          ),
        );

        if (enableLocation != true) {
          fetchWeatherType();
          return;
        }

        _isWaitingForLocationSettings = true;
        return;
      } else {
        fetchWeatherType();
        return;
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        fetchWeatherType();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      fetchWeatherType();
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.medium));
      await fetchWeatherType(position: position);
    } catch (e) {
      fetchWeatherType();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    cityName = widget.initialCity ?? "Delhi";

    if (widget.initialCity == null) {
      _checkLocationAndFetch();
    } else {
      fetchWeatherType();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isWaitingForLocationSettings) {
      _isWaitingForLocationSettings = false;
      _checkLocationAndFetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    SizedBox(height: topPadding);

    if (isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return ErrorView(
        errorMessage: errorMessage!,
        onTryAgain: () => fetchWeatherType(),
        onCityChanged: (newCity) {
          setState(() {
            cityName = newCity;
          });
          fetchWeatherType();
        },
      );
    }

    if (weatherDataType == null ||
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
      body: RefreshIndicator(
        onRefresh: () => fetchWeatherType(isRefresh: true),
        color: Theme.of(context).colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                              animatedIcon:
                                  getLottieAsset(weatherDataType!.main),
                              aqiData: aqiMap,
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myweatherapp/models/fivedays_main_forecast_model.dart';
import 'package:myweatherapp/widgets/get_lottie.dart';
import 'package:myweatherapp/widgets/hourly_forecast_card.dart';
import 'package:intl/intl.dart';

class HomescreenDataCard extends StatelessWidget {
  final FiveDaysMainForecastModel fiveDaysForecast;
  const HomescreenDataCard({
    super.key,
    required this.fiveDaysForecast,
  });

  @override
  Widget build(BuildContext context) {
    final temperatureData = fiveDaysForecast.list.map((item) {
      DateTime date = DateTime.parse(item.dtTxt);
      String timeLabel = DateFormat('h a').format(date);
      String dayLabel = DateFormat('EEEE').format(date);
      return {
        "value": "${item.main.temp.round()}°",
        "label": timeLabel,
        "day": dayLabel,
        "icon": getLottieAsset(item.weather[0].main),
      };
    }).toList();

    final windData = fiveDaysForecast.list.map((item) {
      DateTime date = DateTime.parse(item.dtTxt);
      String timeLabel = DateFormat('h a').format(date);
      String dayLabel = DateFormat('EEEE').format(date);
      return {
        "value": "${item.wind.speed.round()} km/h",
        "label": timeLabel,
        "day": dayLabel,
        "icon": "assets/gif/lottie_wind_speed.json"
      };
    }).toList();

    final humidityData = fiveDaysForecast.list.map((item) {
      DateTime date = DateTime.parse(item.dtTxt);
      String timeLabel = DateFormat('h a').format(date);
      String dayLabel = DateFormat('EEEE').format(date);
      return {
        "value": "${item.main.humidity}%",
        "label": timeLabel,
        "day": dayLabel,
        "icon": "assets/gif/lottie_rainy.json"
      };
    }).toList();

    return SizedBox(
      height: 170.h,
      child: PageView(
        scrollDirection: Axis.vertical,
        children: [
          _DataPage(
            category: "Temperature",
            data: temperatureData,
            isLottie: true,
          ),
          _DataPage(
            category: "Wind Speed",
            data: windData,
            isLottie: true,
          ),
          _DataPage(
            category: "Humidity",
            data: humidityData,
            isLottie: true,
          ),
        ],
      ),
    );
  }
}

class _DataPage extends StatefulWidget {
  final String category;
  final List<Map<String, String?>> data;
  final bool isLottie;

  const _DataPage({
    required this.category,
    required this.data,
    required this.isLottie,
  });

  @override
  State<_DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<_DataPage> {
  final ScrollController _scrollController = ScrollController();
  late String _currentDay;

  @override
  void initState() {
    super.initState();
    _currentDay = widget.data.isNotEmpty ? widget.data[0]['day']! : "";
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    double itemWidth = 60.w + 8;
    int index = (_scrollController.offset / itemWidth).round();

    if (index < 0) index = 0;
    if (index >= widget.data.length) index = widget.data.length - 1;

    String newDay = widget.data[index]['day']!;
    if (newDay != _currentDay) {
      setState(() {
        _currentDay = newDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: Text(
              "${widget.category} [${_currentDay.length > 3 ? _currentDay.substring(0, 3) : _currentDay}]",
              style: TextStyle(
                fontFamily: "MadimiOne",
                fontWeight: FontWeight.w300,
                fontSize: 16.sp,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 130.h,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              final item = widget.data[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: HourlyForecastCard(
                  value: item["value"]!,
                  label: item["label"]!,
                  iconPath: item["icon"],
                  isLottie: widget.isLottie,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

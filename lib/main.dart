import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myweatherapp/presentation/home_screen.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();
  final String? lastCity = prefs.getString('last_city');

  // Time based theme loading (7 AM to 7 PM is light, otherwise dark)
  final int currentHour = DateTime.now().hour;
  if (currentHour >= 7 && currentHour < 19) {
    themeNotifier.value = ThemeMode.light;
  } else {
    themeNotifier.value = ThemeMode.dark;
  }

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(MyApp(initialCity: lastCity));
}

class MyApp extends StatelessWidget {
  final String? initialCity;
  const MyApp({super.key, this.initialCity});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return ScreenUtilInit(
          designSize: const Size(412, 917),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: currentMode,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0XFFE7EAEF),
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.deepPurple, brightness: Brightness.light),
              useMaterial3: true,
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Color(0XFF3C4042)),
              ),
              iconTheme: const IconThemeData(color: Color(0XFF3C4042)),
            ),
            darkTheme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFF1B2530),
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.deepPurple, brightness: Brightness.dark),
              useMaterial3: true,
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            home: HomeScreen(initialCity: initialCity),
          ),
        );
      },
    );
  }
}

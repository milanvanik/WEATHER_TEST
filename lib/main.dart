import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myweatherapp/presentation/home_screen.dart';
import 'package:flutter/services.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            home: const HomeScreen(),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:myweatherapp/widgets/custom_searchbar.dart';

class ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onTryAgain;
  final Function(String) onCityChanged;

  const ErrorView({
    super.key,
    required this.errorMessage,
    required this.onTryAgain,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                    "assets/gif/lottie_wind_speed.json",
                                    width: 180.w),
                                SizedBox(height: 20.h),
                                Text(
                                  "Whoops!",
                                  style: GoogleFonts.oxanium(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  errorMessage,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.oxanium(
                                    fontSize: 16.sp,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withValues(alpha: 0.7),
                                  ),
                                ),
                                SizedBox(height: 40.h),
                                GestureDetector(
                                  onTap: onTryAgain,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40.w, vertical: 15.h),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 8,
                                          offset: const Offset(4, 4),
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.black
                                                  .withValues(alpha: 0.4)
                                              : const Color(0xFFA6ABB2)
                                                  .withValues(alpha: 0.5),
                                        ),
                                        BoxShadow(
                                          blurRadius: 8,
                                          offset: const Offset(-4, -4),
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                                  .withValues(alpha: 0.05)
                                              : Colors.white
                                                  .withValues(alpha: 0.8),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      "TRY AGAIN",
                                      style: GoogleFonts.oxanium(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withValues(alpha: 0.8),
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CustomSearchbar(
                          cityChanged: onCityChanged,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

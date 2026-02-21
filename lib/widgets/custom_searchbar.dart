import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchbar extends StatelessWidget {
  final Function(String)? cityChanged;
  const CustomSearchbar({super.key, this.cityChanged});

  @override
  Widget build(BuildContext context) {
    Offset distance = const Offset(4, 4);
    double blur = 8;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 328.w,
      height: 54.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: blur,
            offset: distance,
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : const Color(0xFFA6ABB2).withValues(alpha: 0.5),
            inset: true,
          ),
          BoxShadow(
            blurRadius: blur,
            offset: -distance,
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.8),
            inset: true,
          ),
        ],
      ),
      child: Center(
        child: TextField(
          style: TextStyle(
            fontFamily: "MadimiOne",
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(left: 16),
            hintText: "ENTER CITY",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Color(0XFFA1A1A1)),
          ),
          onSubmitted: (value) {
            if (cityChanged != null && value.trim().isNotEmpty) {
              cityChanged!(value.trim());
            }
          },
        ),
      ),
    );
  }
}

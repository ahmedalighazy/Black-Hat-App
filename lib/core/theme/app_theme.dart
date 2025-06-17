import 'package:black_hat_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  colorScheme: const ColorScheme.dark(),
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle:
          AppTextStyles.appBarTitle().copyWith(fontFamily: "Inter")),
);

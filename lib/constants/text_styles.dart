import 'package:flutter/material.dart';
import 'colors.dart';

// كل الستايلات النصية في المشروع
class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.black,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.grey,
  );
}

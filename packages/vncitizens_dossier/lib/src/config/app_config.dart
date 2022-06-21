import 'package:flutter/material.dart';

class AppConfig {
  /// your package name
  static const String packageName = "vncitizens_dossier";

  /// storage box name
  static const String storageBox = packageName;

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  // ------------------------------------
  // PACKAGE PRIVACY
  // ------------------------------------

  /// storage key name
  static const String apiEndpoint = "apiEndpoint";

  static const String size = '10';
  static const int statusMaxLength = 20;
  static const int requestTimeout = 3;

  /// colors
  static const statusColor = [
    Color.fromARGB(255, 114, 2, 219),
    Color.fromARGB(255, 255, 160, 0),
    Color.fromARGB(255, 170, 183, 24),
    Color.fromARGB(255, 0, 170, 170),
    Color.fromARGB(255, 33, 150, 83),
    Color.fromARGB(255, 34, 114, 205),
    Color.fromARGB(255, 205, 0, 12),
    Color.fromARGB(255, 189, 189, 189),
  ];

  /// dossier status
  static const dossierStatus = [
    'Chờ tiếp nhận',
    'Đang xử lý',
    'Chờ bổ sung',
    'Chờ nộp tiền',
    'Đã xử lý',
    'Đã rút không nộp',
    'Đã từ chối xử lý',
  ];
}

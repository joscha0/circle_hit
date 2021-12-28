import 'dart:math';

import 'package:circle_hit/pages/game/game_page.dart';
import 'package:circle_hit/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  int highscoreSurvival = 0;
  int highscoreOneMin = 0;

  bool get isDarkTheme => Get.find<ThemeService>().isDarkMode.value;

  late double targetValue;
  Rx<Color> targetColor = Colors.blue.obs;
  double sliderValue = 50;

  final box = GetStorage();

  @override
  void onInit() {
    getHighScores();
    targetValue = (Random().nextDouble() + 0.015) * 95;
    targetColor.value =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
    super.onInit();
  }

  void getHighScores() {
    highscoreSurvival = box.read('highscoreSurvival') ?? 0;
    highscoreOneMin = box.read('highscoreOneMin') ?? 0;
  }

  void pressedSurvival() {
    Get.to(() => GamePage(), arguments: {'mode': 'survival'});
  }

  void pressedOneMinute() {
    Get.to(() => GamePage(), arguments: {'mode': 'oneMinute'});
  }

  void switchTheme() {
    Get.find<ThemeService>().switchTheme();
  }
}

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GameController extends GetxController {
  RxDouble sliderValue = 50.0.obs;
  RxDouble targetValue = 100.0.obs;
  Rx<Color> targetColor = Colors.blue.obs;
  int score = 0;
  int highscoreSurvival = 0;
  int highscoreOneMin = 0;
  bool isSurvival = false;
  bool isPlaying = true;
  double startTime = 60;
  RxDouble time = 60.0.obs;
  Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {});

  final box = GetStorage();

  @override
  void onInit() {
    getHighScores();
    super.onInit();
    String mode = Get.arguments['mode'] ?? 'survival';
    switch (mode) {
      case 'survival':
        isSurvival = true;
        startSurvival();
        break;
      case 'oneMinute':
        isSurvival = false;
        startOneMinute();
        break;
      default:
    }
  }

  void getHighScores() async {
    highscoreSurvival = box.read('highscoreSurvival') ?? 0;
    highscoreOneMin = box.read('highscoreOneMin') ?? 0;
  }

  void randomizeCircles() {
    targetValue.value = (Random().nextDouble() + 0.015) * 95;
    targetColor.value =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  void startSurvival() {
    time.value = (exp(-(0.04 * score)) * 50) + 10;
    startTime = time.value;
    timer.cancel();
    timer = new Timer.periodic(
      Duration(milliseconds: 100),
      (Timer timer) async {
        if (time <= 0) {
          timer.cancel();
          if (score > highscoreSurvival) {
            box.write("highscoreSurvival", score);
            highscoreSurvival = score;
          }
          showScore();
        } else {
          time.value--;
        }
      },
    );
  }

  void startOneMinute() {
    time.value = 60;
    startTime = time.value;
    timer.cancel();
    timer = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) async {
        if (time <= 0) {
          timer.cancel();
          if (score > highscoreOneMin) {
            box.write("highscoreOneMin", score);
            highscoreOneMin = score;
          }

          showScore();
        } else {
          time.value--;
        }
      },
    );
  }

  void changeSlider(double value) {
    if (isPlaying) {
      sliderValue.value = value;
      if (targetValue.value - 1 < value && value < targetValue.value) {
        score++;
        randomizeCircles();
        if (isSurvival) {
          startSurvival();
        }
      }
    }
  }

  void showScore() {
    isPlaying = false;
    Get.defaultDialog(title: 'score: $score', middleText: '', actions: []);
  }
}

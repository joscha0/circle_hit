import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  RxDouble sliderValue = 50.0.obs;
  RxDouble targetValue = 100.0.obs;
  Rx<Color> targetColor = Colors.blue.obs;
  int score = 0;
  int highscoreSurvival = 0;
  int highscoreOneMin = 0;
  RxBool isPlaying = false.obs;
  bool isSurvival = false;
  double startTime = 60;
  RxDouble time = 60.0.obs;
  Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {});

  final box = GetStorage();

  @override
  void onInit() {
    getHighScores();
    print(highscoreSurvival);
    print(highscoreOneMin);
    super.onInit();
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
          isPlaying.value = false;
          randomizeCircles();
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
          isPlaying.value = false;
          randomizeCircles();
        } else {
          time.value--;
        }
      },
    );
  }

  void changeSlider(double value) {
    sliderValue.value = value;
    if (targetValue.value - 1 < value && value < targetValue.value) {
      score++;
      randomizeCircles();
      if (isSurvival) {
        startSurvival();
      }
    }
  }

  void pressedSurvival() {
    score = 0;
    isPlaying.value = true;
    isSurvival = true;
    randomizeCircles();
  }

  void pressedOneMinute() {
    score = 0;
    isPlaying.value = true;
    isSurvival = false;
    randomizeCircles();
    startOneMinute();
  }
}

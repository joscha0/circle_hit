import 'dart:async';
import 'dart:math';

import 'package:circle_hit/pages/home/home_page.dart';
import 'package:circle_hit/services/theme_service.dart';
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
  RxBool isPlaying = true.obs;
  bool isHighScore = false;
  double startTime = 60;
  RxDouble time = 60.0.obs;
  Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {});
  late String mode;

  bool get isDarkTheme => Get.find<ThemeService>().isDarkMode.value;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    mode = Get.arguments['mode'];
    start(mode);
  }

  void start(String mode) {
    randomizeCircles();
    getHighScores();
    score = 0;
    time.value = 60;
    isPlaying.value = true;
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
        if (isPlaying.value) {
          if (time <= 0) {
            timer.cancel();
            if (score > highscoreSurvival) {
              box.write("highscoreSurvival", score);
              isHighScore = true;
            }
            showScore();
          } else {
            time.value--;
          }
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
        if (isPlaying.value) {
          if (time <= 0) {
            timer.cancel();
            if (score > highscoreOneMin) {
              box.write("highscoreOneMin", score);
              isHighScore = true;
            }

            showScore();
          } else {
            time.value--;
          }
        }
      },
    );
  }

  void changeSlider(double value) {
    if (isPlaying.value) {
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
    isPlaying.value = false;
    Get.dialog(
      Center(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Score: $score',
                style: Get.textTheme.headline4?.copyWith(color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                isHighScore
                    ? 'NEW HIGHSCORE!'
                    : 'Best score: ' +
                        (isSurvival
                            ? highscoreSurvival.toString()
                            : highscoreOneMin.toString()),
                style: Get.textTheme.headline6?.copyWith(color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                    start(mode);
                  },
                  style: ElevatedButton.styleFrom(primary: targetColor.value),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Restart',
                      style: TextStyle(
                        color: targetColor.value.computeLuminance() < 0.5
                            ? Colors.white
                            : Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => HomePage());
                    Get.offAll(() => HomePage()); // fix show score
                  },
                  style: ElevatedButton.styleFrom(primary: targetColor.value),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Home',
                      style: TextStyle(
                        color: targetColor.value.computeLuminance() < 0.5
                            ? Colors.white
                            : Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black87,
    );
  }

  void showPause() {
    isPlaying.value = false;
    Get.dialog(
      Center(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Paused',
                style: Get.textTheme.headline4?.copyWith(color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                    isPlaying.value = true;
                  },
                  style: ElevatedButton.styleFrom(primary: targetColor.value),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: targetColor.value.computeLuminance() < 0.5
                            ? Colors.white
                            : Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                    start(mode);
                  },
                  style: ElevatedButton.styleFrom(primary: targetColor.value),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Restart',
                      style: TextStyle(
                        color: targetColor.value.computeLuminance() < 0.5
                            ? Colors.white
                            : Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => HomePage());
                  },
                  style: ElevatedButton.styleFrom(primary: targetColor.value),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Home',
                      style: TextStyle(
                        color: targetColor.value.computeLuminance() < 0.5
                            ? Colors.white
                            : Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black87,
    );
  }
}

import 'dart:async';
import 'dart:math';

import 'package:circle_hit/widgets/LineCircle.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  double _sliderValue = 50;
  double _targetValue = 100;
  Color _targetColor = Colors.blue;
  int score = 0;
  int highscoreSurvival = 0;
  int highscoreOneMin = 0;
  bool isPlaying = false;
  bool isSurvival = false;
  double startTime = 60;
  double time = 60;
  Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isPlaying ? '$score' : "start playing",
          style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
        ),
        isPlaying
            ? Padding(
                padding: const EdgeInsets.fromLTRB(75, 25, 75, 0),
                child: LinearProgressIndicator(
                  color: _targetColor,
                  backgroundColor: _targetColor.withOpacity(0.3),
                  minHeight: 20,
                  value: time / startTime,
                ),
              )
            : Text(
                'last score $score' + (isSurvival ? " (survival)" : " (1 min)"),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
        SizedBox(
          height: 50,
        ),
        Center(
            child: Stack(alignment: AlignmentDirectional.center, children: [
          LineCircle(
              size: 2 * _targetValue, color: _targetColor, strokeWidth: 25),
          LineCircle(
            size: 2 * _sliderValue,
            color: Colors.black,
            strokeWidth: 15,
          ),
          SizedBox(
            height: 200,
          )
        ])),
        SizedBox(
          height: 50,
        ),
        isPlaying
            ? Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 20,
                    thumbColor: Colors.black,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 25.0),
                    activeTrackColor: _targetColor,
                    inactiveTrackColor: _targetColor,
                  ),
                  child: Slider(
                    value: _sliderValue,
                    min: 1,
                    max: 100,
                    onChanged: (double value) {
                      setState(() {
                        _sliderValue = value;
                        if (_targetValue - 1 < value && value < _targetValue) {
                          score++;
                          randomizeCircles();
                          if (isSurvival) {
                            startSurvival();
                          }
                        }
                      });
                    },
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: _targetColor),
                      onPressed: () {
                        setState(() {
                          score = 0;
                          isPlaying = true;
                          isSurvival = true;
                          randomizeCircles();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "PLAY survival",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      )),
                  Text(
                    'highscore $highscoreSurvival',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: _targetColor),
                      onPressed: () {
                        setState(() {
                          score = 0;
                          isPlaying = true;
                          isSurvival = false;
                          randomizeCircles();
                          startOneMinute();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "PLAY 1 min",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      )),
                  Text(
                    'highscore $highscoreOneMin',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ],
    );
  }

  void randomizeCircles() {
    setState(() {
      _targetValue = (Random().nextDouble() + 0.015) * 95;
      _targetColor =
          Colors.primaries[Random().nextInt(Colors.primaries.length)];
    });
  }

  void startSurvival() {
    time = (exp(-(0.04 * score)) * 50) + 10;
    startTime = time;
    timer.cancel();
    timer = new Timer.periodic(
      Duration(milliseconds: 100),
      (Timer timer) {
        if (time <= 0) {
          setState(() {
            timer.cancel();
            if (score > highscoreSurvival) {
              highscoreSurvival = score;
            }

            isPlaying = false;
            randomizeCircles();
          });
        } else {
          setState(() {
            time--;
          });
        }
      },
    );
  }

  void startOneMinute() {
    time = 60;
    startTime = time;
    timer.cancel();
    timer = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (time <= 0) {
          setState(() {
            timer.cancel();
            if (score > highscoreOneMin) {
              highscoreOneMin = score;
            }

            isPlaying = false;
            randomizeCircles();
          });
        } else {
          setState(() {
            time--;
          });
        }
      },
    );
  }
}

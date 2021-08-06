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
  int highscore = 0;
  bool isPlaying = false;
  double startTime = 0;
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
        Text(
          isPlaying ? '$startTime' : 'highscore $highscore',
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
          height: 100,
        ),
        isPlaying
            ? Slider(
                value: _sliderValue,
                min: 0,
                max: 100,
                onChanged: (double value) {
                  setState(() {
                    _sliderValue = value;
                    if (_targetValue - 1 < value && value < _targetValue) {
                      score++;
                      randomizeCircles();
                      startTimer();
                    }
                  });
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          score = 0;
                          isPlaying = true;
                          randomizeCircles();
                        });
                      },
                      child: Text(
                        "PLAY survival",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          score = 0;
                          isPlaying = true;
                          randomizeCircles();
                        });
                      },
                      child: Text(
                        "PLAY 1 min",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
      ],
    );
  }

  void randomizeCircles() {
    setState(() {
      _targetValue = Random().nextDouble() * 100;
      _targetColor =
          Colors.primaries[Random().nextInt(Colors.primaries.length)];
    });
  }

  void startTimer() {
    startTime = (exp(-(0.04 * score)) * 50) + 10;
    timer.cancel();
    timer = new Timer.periodic(
      Duration(milliseconds: 100),
      (Timer timer) {
        if (startTime <= 0) {
          setState(() {
            timer.cancel();
            if (score > highscore) {
              highscore = score;
            }

            isPlaying = false;
            randomizeCircles();
          });
        } else {
          setState(() {
            startTime--;
          });
        }
      },
    );
  }
}

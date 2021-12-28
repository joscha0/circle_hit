import 'package:circle_hit/widgets/LineCircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
        init: HomeController(),
        builder: (c) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "circle hit",
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                ),
                // Text(
                //   'last score ${c.score}' +
                //       (c.isSurvival ? " (survival)" : " (1 min)"),
                //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                // ),
                SizedBox(
                  height: 50,
                ),
                Center(
                    child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                      LineCircle(
                          size: 2 * c.targetValue,
                          color: c.targetColor.value,
                          strokeWidth: 25),
                      LineCircle(
                        size: 2 * c.sliderValue,
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: c.targetColor.value),
                        onPressed: () => c.pressedSurvival(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "PLAY survival",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Text(
                      'highscore ${c.highscoreSurvival}',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: c.targetColor.value),
                        onPressed: () => c.pressedOneMinute(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "PLAY 1 min",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Text(
                      'highscore ${c.highscoreOneMin}',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

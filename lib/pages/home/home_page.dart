import 'package:circle_hit/services/theme_service.dart';
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
            floatingActionButton: IconButton(
              icon: Icon(
                c.isDarkTheme ? Icons.dark_mode : Icons.light_mode,
              ),
              onPressed: c.switchTheme,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "circle hit",
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 20,
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
                        color: c.isDarkTheme ? Colors.white : Colors.black,
                        strokeWidth: 15,
                      ),
                      SizedBox(
                        height: 200,
                      )
                    ])),
                SizedBox(
                  height: 30,
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
                                color:
                                    c.targetColor.value.computeLuminance() < 0.5
                                        ? Colors.white
                                        : Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Highscore: ',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          c.highscoreSurvival.toString(),
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: c.targetColor.value,
                        ),
                        onPressed: () => c.pressedOneMinute(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "PLAY 1 min",
                            style: TextStyle(
                                color:
                                    c.targetColor.value.computeLuminance() < 0.5
                                        ? Colors.white
                                        : Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Highscore: ',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          c.highscoreOneMin.toString(),
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

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
                  c.isPlaying.value ? '${c.score}' : "circle hit",
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                ),
                c.isPlaying.value
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(75, 25, 75, 0),
                        child: LinearProgressIndicator(
                          color: c.targetColor.value,
                          backgroundColor: c.targetColor.value.withOpacity(0.3),
                          minHeight: 20,
                          value: c.time.value / c.startTime,
                        ),
                      )
                    : Text(
                        'last score ${c.score}' +
                            (c.isSurvival ? " (survival)" : " (1 min)"),
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                SizedBox(
                  height: 50,
                ),
                Center(
                    child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                      LineCircle(
                          size: 2 * c.targetValue.value,
                          color: c.targetColor.value,
                          strokeWidth: 25),
                      LineCircle(
                        size: 2 * c.sliderValue.value,
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
                c.isPlaying.value
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 20,
                            thumbColor: Colors.black,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 25.0),
                            activeTrackColor: c.targetColor.value,
                            inactiveTrackColor: c.targetColor.value,
                          ),
                          child: Slider(
                            value: c.sliderValue.value,
                            min: 1,
                            max: 100,
                            onChanged: (double value) => c.changeSlider(value),
                          ),
                        ),
                      )
                    : Column(
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
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          Text(
                            'highscore ${c.highscoreSurvival}',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
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
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          Text(
                            'highscore ${c.highscoreOneMin}',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ],
            ),
          );
        });
  }
}

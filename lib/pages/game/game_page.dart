import 'package:circle_hit/widgets/LineCircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'game_controller.dart';

class GamePage extends GetView<GameController> {
  @override
  Widget build(BuildContext context) {
    return GetX<GameController>(
        init: GameController(),
        builder: (c) {
          return Scaffold(
            floatingActionButton: IconButton(
              icon: Icon(Icons.pause),
              onPressed: () => c.showPause(),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerTop,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  c.score.toString(),
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(75, 25, 75, 0),

                  child: LinearPercentIndicator(
                    percent:
                        (c.time.value > 0 ? c.time.value : 0) / c.startTime,
                    backgroundColor: c.targetColor.value.withOpacity(0.3),
                    progressColor: c.targetColor.value,
                    lineHeight: 20,
                    animateFromLastPercent: true,
                    animation: true,
                    animationDuration: 100,
                    alignment: MainAxisAlignment.center,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                  ),
                  // LinearProgressIndicator(
                  //   color: c.targetColor.value,
                  //   backgroundColor: c.targetColor.value.withOpacity(0.3),
                  //   minHeight: 20,
                  //   value:  c.time.value / c.startTime,
                  // ),
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
                Padding(
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
                ),
              ],
            ),
          );
        });
  }
}

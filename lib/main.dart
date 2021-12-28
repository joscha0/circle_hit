import 'package:circle_hit/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'services/theme_service.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends GetView<ThemeService> {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ThemeService>(
        init: ThemeService(),
        builder: (c) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: c.themeMode.value,
            theme:
                ThemeData.light().copyWith(elevatedButtonTheme: c.buttonTheme),
            darkTheme: ThemeData.dark().copyWith(
              elevatedButtonTheme: c.buttonTheme,
              scaffoldBackgroundColor: Colors.black,
            ),
            home: HomePage(),
          );
        });
  }
}

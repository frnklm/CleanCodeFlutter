import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/screens.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
      50: const Color.fromRGBO(136, 14, 79, .1),
      100: const Color.fromRGBO(136, 14, 79, .2),
      200: const Color.fromRGBO(136, 14, 79, .3),
      300: const Color.fromRGBO(136, 14, 79, .4),
      400: const Color.fromRGBO(136, 14, 79, .5),
      500: const Color.fromRGBO(136, 14, 79, .6),
      600: const Color.fromRGBO(136, 14, 79, .7),
      700: const Color.fromRGBO(136, 14, 79, .8),
      800: const Color.fromRGBO(136, 14, 79, .9),
      900: const Color.fromRGBO(136, 14, 79, 1),
    };

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    MaterialColor colorCustom = MaterialColor(0xFF880E4F, color);
    const primaryColor = Color.fromRGBO(136, 14, 79, 1);
    const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
    return MaterialApp(
      title: 'App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: colorCustom,
        ).copyWith(
          secondary: primaryColor,
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: primaryColorDark,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColorLight),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          alignLabelWithHint: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      // home: const LoginScreen(),
    );
  }
}

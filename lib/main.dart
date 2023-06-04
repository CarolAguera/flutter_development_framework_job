import 'package:flutter/material.dart';
import 'package:trabalho_consumo_api/characters_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trabalho_consumo_api/character_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const Color primaryColor = const Color(0xFFED1D24);
const Color accentColor = const Color(0xFFFF0000);
const Color backgroundColor = const Color(0xFF000000);
const Color textColor = const Color(0xFFFFFFFF);

final ThemeData marvelTheme = ThemeData(
  primaryColor: primaryColor,
  accentColor: accentColor,
  backgroundColor: backgroundColor,
  scaffoldBackgroundColor: backgroundColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: textColor),
    bodySmall: TextStyle(color: textColor),
  ).apply(
    bodyColor: textColor,
    displayColor: textColor,
  ),
);


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: marvelTheme,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seu App',
      theme: marvelTheme,
      home: BlocProvider(
        create: (context) =>
            CharacterBloc()..add(FetchCharacters(offset: 0, limit: 20)),
        child: CharactersPage(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Models/expense.dart';
import 'Screens/home_screen.dart';
import 'Screens/splash_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox('settings');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final settingsBox = Hive.box('settings');
  bool isDarkMode = false;
  bool get isDark => isDarkMode;

  @override
  void initState() {
    super.initState();

    isDarkMode = settingsBox.get('darkMode', defaultValue: false);
  }

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });

    settingsBox.put('darkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
      ),

      home: const SplashScreen(),
    );
  }
}
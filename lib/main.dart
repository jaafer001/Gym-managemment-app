import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/Dashboard_screen.dart';
import 'screens/add_member_screen.dart';
import 'screens/member_details_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'database/database_helper.dart';
import 'utils/notifications_helper.dart';
import 'models/member.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database; // Initialize DB
  await NotificationsHelper.init(); // Initialize notifications
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isDarkMode = false;
  Locale _locale = Locale('en'); // Default to English

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
      final localeCode = prefs.getString('languageCode') ?? 'en';
      _locale = Locale(localeCode);
    });
  }

  void updateTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    setState(() {
      _isDarkMode = isDark;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void updateLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym_membership',
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
        Locale('ja'),
        Locale('ru'),
        Locale('ko'),
        Locale('es'),
      ],
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => DashboardScreen());
          case '/add_member':
            return MaterialPageRoute(builder: (_) => AddMemberScreen());
          case '/member_details':
            final member = settings.arguments as Member;
            return MaterialPageRoute(builder: (_) => MemberDetailsScreen(member: member));
          case '/notifications':
            return MaterialPageRoute(builder: (_) => NotificationsScreen());
          case '/settings':
            return MaterialPageRoute(
              builder: (_) => SettingsScreen(
                onThemeChanged: updateTheme,
                onLanguageChanged: updateLocale,
                currentLocale: _locale,
              ),
            );
          default:
            return MaterialPageRoute(builder: (_) => DashboardScreen());
        }
      },
    );
  }
}
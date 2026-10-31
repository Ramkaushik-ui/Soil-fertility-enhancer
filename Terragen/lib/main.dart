import 'package:flutter/material.dart';
import 'l10n/app_strings.dart';
import 'repositories/auth_repository.dart';
import 'repositories/soil_repository.dart';
import 'repositories/device_repository.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/soil_analysis_screen.dart';
import 'screens/ai_advisory_screen.dart';
import 'screens/device_management_screen.dart';
import 'screens/profile_and_settings_screen.dart';

void main() {
  runApp(const TerragenFlutterApp());
}

class LanguageNotifier extends ChangeNotifier {
  static final LanguageNotifier _instance = LanguageNotifier._internal();
  factory LanguageNotifier() => _instance;
  LanguageNotifier._internal();

  String _langCode = 'en';
  String get langCode => _langCode;

  void toggleLanguage() {
    _langCode = _langCode == 'en' ? 'ta' : 'en';
    notifyListeners();
  }
}

class TerragenFlutterApp extends StatefulWidget {
  const TerragenFlutterApp({super.key});

  @override
  State<TerragenFlutterApp> createState() => _TerragenFlutterAppState();
}

class _TerragenFlutterAppState extends State<TerragenFlutterApp> {
  final LanguageNotifier _languageNotifier = LanguageNotifier();
  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    _languageNotifier.addListener(_onStateChanged);
    _authRepository.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _languageNotifier.removeListener(_onStateChanged);
    _authRepository.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terragen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: _authRepository.isLoggedIn
          ? MainNavigationScreen(languageNotifier: _languageNotifier)
          : AuthScreen(langCode: _languageNotifier.langCode),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final LanguageNotifier languageNotifier;
  const MainNavigationScreen({super.key, required this.languageNotifier});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final lang = widget.languageNotifier.langCode;

    final pages = [
      DashboardScreen(
        langCode: lang,
        onNavigate: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      SoilAnalysisScreen(langCode: lang),
      AiAdvisoryScreen(langCode: lang),
      DeviceManagementScreen(langCode: lang),
      ProfileAndSettingsScreen(
        langCode: lang,
        onToggleLanguage: widget.languageNotifier.toggleLanguage,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.get(lang, 'appName'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              AppStrings.get(lang, 'appTagline'),
              style: const TextStyle(fontSize: 11, color: Colors.black87),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'Switch Language / மொழி',
            onPressed: widget.languageNotifier.toggleLanguage,
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            label: AppStrings.get(lang, 'navDashboard'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.analytics),
            label: AppStrings.get(lang, 'navSoil'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.psychology),
            label: AppStrings.get(lang, 'navAi'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.memory),
            label: AppStrings.get(lang, 'navDevices'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person),
            label: AppStrings.get(lang, 'navProfile'),
          ),
        ],
      ),
    );
  }
}

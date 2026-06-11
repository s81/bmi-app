import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config.dart';
import 'providers/auth_provider.dart';
import 'providers/bmi_provider.dart';
import 'providers/history_provider.dart';
import 'screens/calculator_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/methodology_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/results_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BmiProvider()),
        ChangeNotifierProxyProvider<AuthProvider, HistoryProvider>(
          create: (_) => HistoryProvider(),
          update: (_, auth, history) => history!..onAuthChanged(auth),
        ),
      ],
      child: const BmiApp(),
    ),
  );
}

class BmiApp extends StatelessWidget {
  const BmiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _goTo(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onGetStarted: () => _goTo(1)),
      CalculatorScreen(onCalculated: () => _goTo(2)),
      ResultsScreen(onRecalculate: () => _goTo(1)),
      const MethodologyScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                ['Home', 'Calculator', 'Results', 'Methodology', 'History', 'Profile'][_index],
                style: const TextStyle(
                  color: Color(0xFF8BB8E8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _goTo,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.calculate_outlined), selectedIcon: Icon(Icons.calculate), label: 'Calculator'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Results'),
          NavigationDestination(icon: Icon(Icons.science_outlined), selectedIcon: Icon(Icons.science), label: 'Methodology'),
          NavigationDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// 1. Structure de base de l'application

import 'package:flutter/material.dart';
import 'package:mon_cv/firebase_options.dart';
import 'package:mon_cv/screens/experiences_screen.dart';
import 'package:provider/provider.dart';
import 'package:mon_cv/providers/providers.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/app_theme.dart';
import 'screens/contact_screen.dart';
import 'screens/project_screen.dart';
import 'screens/skills_screens.dart';
import 'screens/widget/profil_headers.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class CVApp extends StatelessWidget {
  const CVApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return MaterialApp(
      title: 'Mon CV Interactif',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // ThemeData(
      //   primarySwatch: Colors.blue,
      //   brightness: themeModel.isDarkMode ? Brightness.dark : Brightness.light,

      //   // Personnalisez les thèmes ici
      // ),
      home: const HomeScreen(),
    );
  }
}

// 2. Écran d'accueil avec animation

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _position;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _position = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecam Papa'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeModel>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeModel>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Photo de profil et en-tête
          FadeTransition(
            opacity: _opacity,
            child: SlideTransition(position: _position, child: ProfileHeader()),
          ),
          // Navigation vers les différentes sections
          Expanded(child: MainNavigation()),
        ],
      ),
    );
  }
}

// 3. En-tête de profil

// 4. Navigation principale

class MainNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildNavItem(
          context,
          'Compétences',
          Icons.code,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SkillsScreen()),
          ),
        ),
        _buildNavItem(
          context,
          'Expériences',
          Icons.work,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExperienceScreen()),
          ),
        ),
        _buildNavItem(context, 'Formation', Icons.school, () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => EducationScreen()),
          // );
        }),
        _buildNavItem(
          context,
          'Projets',
          Icons.folder,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProjectsScreen()),
          ),
        ),
        _buildNavItem(
          context,
          'Contact',
          Icons.email,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactScreen()),
          ),
        ),
        _buildNavItem(context, 'À propos', Icons.info, () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => AboutScreen()),
          // );
        }),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 8. Formulaire de contact

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeModel()),
        // Ajoutez d'autres providers pour vos données Firebase
        ChangeNotifierProvider(create: (context) => SkillsProvider()),
        ChangeNotifierProvider(create: (context) => ExperiencesProvider()),
        ChangeNotifierProvider(create: (context) => ProjectsProvider()),
        // Vous ajouterez un EducationProvider plus tard
      ],
      child: const CVApp(),
    ),
  );
}

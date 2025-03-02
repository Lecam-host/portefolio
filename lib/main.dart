// 1. Structure de base de l'application

import 'package:flutter/material.dart';
import 'package:mon_cv/firebase_options.dart';
import 'package:mon_cv/model/model.dart' show ExperienceItem;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:mon_cv/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/skills_screens.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDarkMode = false;

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: themeModel.isDarkMode ? Brightness.dark : Brightness.light,
        // Personnalisez les thèmes ici
      ),
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
        title: const Text('Prénom Nom'),
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

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Avatar avec effet d'ombre
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 75,
              backgroundImage: AssetImage('assets/profile_image.jpg'),
            ),
          ),
          const SizedBox(height: 24),
          // Nom et titre
          const Text(
            'Prénom Nom',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Développeur Flutter',
            style: TextStyle(fontSize: 20, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          // Description courte
          const Text(
            'Passionné par le développement mobile et les interfaces utilisateur intuitives, avec 3 ans d\'expérience en Flutter.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

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
            Icon(
              icon,
              size: 40,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 5. Écran des compétences avec barres de progression animées

// class SkillsScreen extends StatefulWidget {
//   @override
//   _SkillsScreenState createState() => _SkillsScreenState();
// }

// class _SkillsScreenState extends State<SkillsScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   final List<SkillItem> _skills = [
//     SkillItem(name: 'Flutter', level: 0.9),
//     SkillItem(name: 'Dart', level: 0.85),
//     SkillItem(name: 'Firebase', level: 0.8),
//     SkillItem(name: 'State Management', level: 0.75),
//     SkillItem(name: 'UI/UX Design', level: 0.7),
//     SkillItem(name: 'REST API', level: 0.8),
//     SkillItem(name: 'Git', level: 0.75),
//     SkillItem(name: 'Agile/SCRUM', level: 0.65),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Compétences')),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: _skills.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: AnimatedBuilder(
//               animation: _controller,
//               builder: (context, child) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _skills[index].name,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     LinearProgressIndicator(
//                       value: _controller.value * _skills[index].level,
//                       minHeight: 10,
//                       backgroundColor: Colors.grey[300],
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         Theme.of(context).primaryColor,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${(_controller.value * _skills[index].level * 100).toInt()}%',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class SkillItem {
//   final String name;
//   final double level; // 0.0 to 1.0

//   SkillItem({required this.name, required this.level});
// }

// 6. Timeline pour l'expérience professionnelle

class ExperienceScreen extends StatelessWidget {
  final List<ExperienceItem> experiences = [
    ExperienceItem(
      company: 'Entreprise XYZ',
      position: 'Développeur Flutter Senior',
      duration: 'Jan 2023 - Présent',
      description:
          'Développement d\'applications mobiles pour des clients dans divers secteurs. Responsable de l\'architecture et du développement frontend.',
      technologies: ['Flutter', 'Firebase', 'Git', 'REST API'],
    ),
    ExperienceItem(
      company: 'Startup ABC',
      position: 'Développeur Flutter',
      duration: 'Mars 2021 - Déc 2022',
      description:
          'Création d\'une application de e-commerce avec plus de 50 000 utilisateurs actifs. Implémentation de fonctionnalités de paiement et de géolocalisation.',
      technologies: ['Flutter', 'Bloc', 'Firebase', 'Google Maps API'],
    ),
    ExperienceItem(
      company: 'Freelance',
      position: 'Développeur Mobile',
      duration: 'Jan 2020 - Fév 2021',
      description:
          'Réalisation de plusieurs applications pour des clients indépendants. Focus sur les interfaces utilisateur et l\'expérience utilisateur.',
      technologies: ['Flutter', 'Provider', 'RESTful APIs'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expérience Professionnelle')),
      body: ListView.builder(
        itemCount: experiences.length,
        itemBuilder: (context, index) {
          return ExperienceCard(
            experience: experiences[index],
            isFirst: index == 0,
            isLast: index == experiences.length - 1,
          );
        },
      ),
    );
  }
}

// class ExperienceItem {
//   final String company;
//   final String position;
//   final String duration;
//   final String description;
//   final List<String> technologies;

//   ExperienceItem({
//     required this.company,
//     required this.position,
//     required this.duration,
//     required this.description,
//     required this.technologies,
//   });
// }

class ExperienceCard extends StatelessWidget {
  final ExperienceItem experience;
  final bool isFirst;
  final bool isLast;

  const ExperienceCard({
    Key? key,
    required this.experience,
    this.isFirst = false,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline line and dot
          Container(
            width: 80,
            child: Column(
              children: [
                // Line above
                if (!isFirst)
                  Container(
                    width: 2,
                    height: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                // Dot
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                // Line below
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Card(
              margin: const EdgeInsets.fromLTRB(0, 16, 16, 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.position,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      experience.company,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      experience.duration,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 12),
                    Text(experience.description),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          experience.technologies
                              .map(
                                (tech) => Chip(
                                  label: Text(tech),
                                  backgroundColor:
                                      Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer,
                                  labelStyle: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 7. Écran des projets avec affichage en grille et modal détaillé

class ProjectsScreen extends StatelessWidget {
  final List<ProjectItem> projects = [
    ProjectItem(
      title: 'Application E-commerce',
      description:
          'Application complète avec panier, paiement et gestion de profil.',
      imageAsset: 'assets/projects/ecommerce.jpg',
      technologies: ['Flutter', 'Provider', 'Firebase', 'Stripe API'],
      githubUrl: 'https://github.com/username/ecommerce-app',
    ),
    ProjectItem(
      title: 'Application Météo',
      description:
          'Application de prévisions météo avec animations personnalisées et géolocalisation.',
      imageAsset: 'assets/projects/weather.jpg',
      technologies: ['Flutter', 'Bloc', 'OpenWeather API', 'Geolocator'],
      githubUrl: 'https://github.com/username/weather-app',
    ),
    ProjectItem(
      title: 'Gestionnaire de Tâches',
      description:
          'Application de productivité avec notifications et synchronisation cloud.',
      imageAsset: 'assets/projects/tasks.jpg',
      technologies: ['Flutter', 'GetX', 'Hive', 'Firebase'],
      githubUrl: 'https://github.com/username/task-manager',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projets')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return ProjectCard(project: projects[index]);
        },
      ),
    );
  }
}

class ProjectItem {
  final String title;
  final String description;
  final String imageAsset;
  final List<String> technologies;
  final String githubUrl;

  ProjectItem({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.technologies,
    required this.githubUrl,
  });
}

class ProjectCard extends StatelessWidget {
  final ProjectItem project;

  const ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) => ProjectDetailModal(project: project),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Image.asset(project.imageAsset, fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailModal extends StatelessWidget {
  final ProjectItem project;

  const ProjectDetailModal({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              project.imageAsset,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(project.description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          const Text(
            'Technologies utilisées',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                project.technologies
                    .map(
                      (tech) => Chip(
                        label: Text(tech),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.code),
            label: const Text('Voir sur GitHub'),
            onPressed: () {
              // Implémentez la logique pour ouvrir l'URL
              // Pour l'instant, affichons juste un snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ouverture de ${project.githubUrl}')),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}

// 8. Formulaire de contact

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contactez-moi',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'N\'hésitez pas à me contacter pour toute opportunité ou question.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              // Nom
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Message
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  prefixIcon: Icon(Icons.message),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Bouton d'envoi
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Envoyer'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Simuler l'envoi du formulaire
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Message envoyé avec succès!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // Réinitialiser le formulaire
                    _nameController.clear();
                    _emailController.clear();
                    _messageController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 24),
              // Liens sociaux
              const Text(
                'Retrouvez-moi également sur:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _socialButton(
                    context,
                    'LinkedIn',
                    Icons.link,
                    Colors.blue.shade800,
                    () {},
                  ),
                  _socialButton(
                    context,
                    'GitHub',
                    Icons.code,
                    Colors.black,
                    () {},
                  ),
                  _socialButton(
                    context,
                    'Twitter',
                    Icons.chat,
                    Colors.blue.shade400,
                    () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}

// 1. Ajoutez les dépendances dans pubspec.yaml
// dependencies:
//   flutter:
//     sdk: flutter
//   provider: ^6.0.5
//   firebase_core: ^2.14.0
//   cloud_firestore: ^4.8.1
//   firebase_auth: ^4.6.3 // Optionnel si vous avez besoin d'authentification

// 2. Initialiser Firebase dans main.dart

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

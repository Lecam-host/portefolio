import 'package:flutter/material.dart';
import 'package:mon_cv/screens/widget/theme_icon_widget.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import 'widget/project_card.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les données depuis Firebase au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProjectsProvider>(context, listen: false).loadProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projets'),
        actions: [ThemeIconWidget()],
      ),
      body: Consumer<ProjectsProvider>(
        builder: (context, projectsProvider, child) {
          if (projectsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (projectsProvider.error.isNotEmpty) {
            return Center(child: Text('Erreur: ${projectsProvider.error}'));
          }

          if (projectsProvider.projects.isEmpty) {
            return const Center(child: Text('Aucun projet disponible'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: projectsProvider.projects.length,
            itemBuilder: (context, index) {
              return ProjectCard(project: projectsProvider.projects[index]);
            },
          );
        },
      ),
    );
  }
}

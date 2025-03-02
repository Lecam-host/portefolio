// Écran des compétences (skills_screen.dart)
import 'package:flutter/material.dart';
import 'package:mon_cv/main.dart' show ExperienceCard;
import 'package:mon_cv/model/model.dart';
import 'package:mon_cv/providers/providers.dart';
import 'package:provider/provider.dart';

class SkillsScreen extends StatefulWidget {
  @override
  _SkillsScreenState createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Charger les données depuis Firebase au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SkillsProvider>(context, listen: false).loadSkills();
    });

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
      appBar: AppBar(title: const Text('Compétences')),
      body: Consumer<SkillsProvider>(
        builder: (context, skillsProvider, child) {
          if (skillsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (skillsProvider.error.isNotEmpty) {
            return Center(child: Text('Erreur: ${skillsProvider.error}'));
          }

          if (skillsProvider.skills.isEmpty) {
            return const Center(child: Text('Aucune compétence disponible'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: skillsProvider.skills.length,
            itemBuilder: (context, index) {
              final skill = skillsProvider.skills[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skill.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _controller.value * skill.level,
                          minHeight: 10,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(_controller.value * skill.level * 100).toInt()}%',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Écran des expériences (experience_screen.dart)

class ExperienceScreen extends StatefulWidget {
  @override
  _ExperienceScreenState createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les données depuis Firebase au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExperiencesProvider>(
        context,
        listen: false,
      ).loadExperiences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expérience Professionnelle')),
      body: Consumer<ExperiencesProvider>(
        builder: (context, experiencesProvider, child) {
          if (experiencesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (experiencesProvider.error.isNotEmpty) {
            return Center(child: Text('Erreur: ${experiencesProvider.error}'));
          }

          if (experiencesProvider.experiences.isEmpty) {
            return const Center(child: Text('Aucune expérience disponible'));
          }

          return ListView.builder(
            itemCount: experiencesProvider.experiences.length,
            itemBuilder: (context, index) {
              return ExperienceCard(
                experience: experiencesProvider.experiences[index],
                isFirst: index == 0,
                isLast: index == experiencesProvider.experiences.length - 1,
              );
            },
          );
        },
      ),
    );
  }
}

// Écran des projets (projects_screen.dart)

class ProjectsScreen extends StatefulWidget {
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
      appBar: AppBar(title: const Text('Projets')),
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

// Mise à jour de ProjectCard pour utiliser imageUrl au lieu de imageAsset
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
            Expanded(
              child:
                  project.imageUrl.startsWith('assets/')
                      // Pour la compatibilité avec les anciens assets
                      ? Image.asset(project.imageUrl, fit: BoxFit.cover)
                      // Pour les images Firebase Storage
                      : Image.network(
                        project.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image, size: 50),
                          );
                        },
                      ),
            ),
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

// Mise à jour de ProjectDetailModal pour utiliser imageUrl
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
            child:
                project.imageUrl.startsWith('assets/')
                    ? Image.asset(
                      project.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                    : Image.network(
                      project.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          ),
                        );
                      },
                    ),
          ),
          // Le reste du code reste identique...
        ],
      ),
    );
  }
}

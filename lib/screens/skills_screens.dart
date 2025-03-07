// Écran des compétences (skills_screen.dart)
import 'package:flutter/material.dart';
import 'package:mon_cv/model/model.dart';
import 'package:mon_cv/providers/providers.dart';
import 'package:mon_cv/screens/widget/theme_icon_widget.dart';
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
      appBar: AppBar(
        title: const Text('Compétences'),
        actions: [ThemeIconWidget()],
      ),
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

// Écran des projets (projects_screen.dart)

// Mise à jour de ProjectCard pour utiliser imageUrl au lieu de imageAsset

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

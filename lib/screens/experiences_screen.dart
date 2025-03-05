import 'package:flutter/material.dart';
import 'package:mon_cv/providers/providers.dart';
import 'package:provider/provider.dart';

import 'widget/experience_card.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

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

// education_screen.dart
import 'package:flutter/material.dart';
import 'package:mon_cv/model/model.dart' show EducationItem;
import 'package:mon_cv/screens/widget/theme_icon_widget.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class EducationScreen extends StatefulWidget {
  @override
  _EducationScreenState createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les données depuis Firebase au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EducationProvider>(context, listen: false).loadEducation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formation'),
        actions: [ThemeIconWidget()],
      ),
      body: Consumer<EducationProvider>(
        builder: (context, educationProvider, child) {
          if (educationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (educationProvider.error.isNotEmpty) {
            return Center(child: Text('Erreur: ${educationProvider.error}'));
          }

          if (educationProvider.education.isEmpty) {
            return const Center(child: Text('Aucune formation disponible'));
          }

          return ListView.builder(
            itemCount: educationProvider.education.length,
            itemBuilder: (context, index) {
              return EducationCard(
                education: educationProvider.education[index],
                isFirst: index == 0,
                isLast: index == educationProvider.education.length - 1,
              );
            },
          );
        },
      ),
    );
  }
}

class EducationCard extends StatelessWidget {
  final EducationItem education;
  final bool isFirst;
  final bool isLast;

  const EducationCard({
    Key? key,
    required this.education,
    this.isFirst = false,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline line and dot (similaire à ExperienceCard)
          Container(
            width: 80,
            child: Column(
              children: [
                if (!isFirst)
                  Container(
                    width: 2,
                    height: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
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
                      education.degree,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      education.field,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      education.institution,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      education.duration,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 12),
                    Text(education.description),
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

// providers/education_provider.dart

class EducationProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<EducationItem> _education = [];
  bool _isLoading = false;
  String _error = '';

  List<EducationItem> get education => _education;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadEducation() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _education = await _firebaseService.getEducation();
    } catch (e) {
      _error = 'Erreur lors du chargement des formations: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ajoutez les méthodes CRUD comme pour les autres providers
}

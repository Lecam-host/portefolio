// providers/skills_provider.dart
import 'package:flutter/foundation.dart';
import '../model/model.dart';
import '../services/services.dart';

class SkillsProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<SkillItem> _skills = [];
  bool _isLoading = false;
  String _error = '';

  List<SkillItem> get skills => _skills;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadSkills() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _skills = await _firebaseService.getSkills();
    } catch (e) {
      _error = 'Erreur lors du chargement des compétences: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addSkill(SkillItem skill) async {
    _isLoading = true;
    notifyListeners();

    try {
      final id = await _firebaseService.addDocument('skills', skill.toMap());
      if (id != null) {
        _skills.add(SkillItem(id: id, name: skill.name, level: skill.level));
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Erreur lors de l\'ajout de la compétence: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ajoutez les méthodes update et delete similairement
}

// providers/experiences_provider.dart

class ExperiencesProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<ExperienceItem> _experiences = [];
  bool _isLoading = false;
  String _error = '';

  List<ExperienceItem> get experiences => _experiences;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadExperiences() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _experiences = await _firebaseService.getExperiences();
    } catch (e) {
      _error = 'Erreur lors du chargement des expériences: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ajoutez les méthodes CRUD comme pour SkillsProvider
}

// providers/projects_provider.dart

class ProjectsProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<ProjectItem> _projects = [];
  bool _isLoading = false;
  String _error = '';

  List<ProjectItem> get projects => _projects;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadProjects() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _projects = await _firebaseService.getProjects();
    } catch (e) {
      _error = 'Erreur lors du chargement des projets: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ajoutez les méthodes CRUD comme pour SkillsProvider
}

// Créez un provider similaire pour Education

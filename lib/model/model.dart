// models/skill_model.dart
class SkillItem {
  final String id;
  final String name;
  final double level; // 0.0 to 1.0

  SkillItem({required this.id, required this.name, required this.level});

  factory SkillItem.fromMap(String id, Map<String, dynamic> map) {
    return SkillItem(
      id: id,
      name: map['name'] ?? '',
      level: (map['level'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'level': level};
  }
}

// models/experience_model.dart
class ExperienceItem {
  //final String id;
  final String company;
  final String position;
  final String duration;
  final String description;
  final List<String> technologies;

  ExperienceItem({
    // required this.id,
    required this.company,
    required this.position,
    required this.duration,
    required this.description,
    required this.technologies,
  });

  factory ExperienceItem.fromMap(String id, Map<String, dynamic> map) {
    return ExperienceItem(
      // id: id,
      company: map['company'] ?? '',
      position: map['position'] ?? '',
      duration: map['duration'] ?? '',
      description: map['description'] ?? '',
      technologies: List<String>.from(map['technologies'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'position': position,
      'duration': duration,
      'description': description,
      'technologies': technologies,
    };
  }
}

// models/project_model.dart
class ProjectItem {
  final String id;
  final String title;
  final String description;
  final String
  imageUrl; // Changé de imageAsset à imageUrl pour Firebase Storage
  final List<String> technologies;
  final String githubUrl;

  ProjectItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technologies,
    required this.githubUrl,
  });

  factory ProjectItem.fromMap(String id, Map<String, dynamic> map) {
    return ProjectItem(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      technologies: List<String>.from(map['technologies'] ?? []),
      githubUrl: map['githubUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'technologies': technologies,
      'githubUrl': githubUrl,
    };
  }
}

// models/education_model.dart
class EducationItem {
  final String id;
  final String institution;
  final String degree;
  final String field;
  final String duration;
  final String description;

  EducationItem({
    required this.id,
    required this.institution,
    required this.degree,
    required this.field,
    required this.duration,
    required this.description,
  });

  factory EducationItem.fromMap(String id, Map<String, dynamic> map) {
    return EducationItem(
      id: id,
      institution: map['institution'] ?? '',
      degree: map['degree'] ?? '',
      field: map['field'] ?? '',
      duration: map['duration'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'institution': institution,
      'degree': degree,
      'field': field,
      'duration': duration,
      'description': description,
    };
  }
}

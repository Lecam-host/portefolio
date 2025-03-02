// services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthodes pour les compétences
  Future<List<SkillItem>> getSkills() async {
    try {
      final snapshot =
          await _firestore.collection('skills').orderBy('name').get();
      return snapshot.docs
          .map((doc) => SkillItem.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des compétences: $e');
      return [];
    }
  }

  // Méthodes pour les expériences
  Future<List<ExperienceItem>> getExperiences() async {
    try {
      final snapshot =
          await _firestore
              .collection('experiences')
              .orderBy(
                'order',
                descending: true,
              ) // Utilisez un champ 'order' pour définir l'ordre
              .get();
      return snapshot.docs
          .map((doc) => ExperienceItem.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des expériences: $e');
      return [];
    }
  }

  // Méthodes pour les projets
  Future<List<ProjectItem>> getProjects() async {
    try {
      final snapshot = await _firestore.collection('projects').get();
      return snapshot.docs
          .map((doc) => ProjectItem.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des projets: $e');
      return [];
    }
  }

  // Méthodes pour les formations
  Future<List<EducationItem>> getEducation() async {
    try {
      final snapshot =
          await _firestore
              .collection('education')
              .orderBy('order', descending: true)
              .get();
      return snapshot.docs
          .map((doc) => EducationItem.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des formations: $e');
      return [];
    }
  }

  // Méthodes CRUD supplémentaires si nécessaire
  // Ajouter un élément
  Future<String?> addDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(collection)
          .add(data);
      return docRef.id;
    } catch (e) {
      print('Erreur lors de l\'ajout du document: $e');
      return null;
    }
  }

  // Mettre à jour un élément
  Future<bool> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(id).update(data);
      return true;
    } catch (e) {
      print('Erreur lors de la mise à jour du document: $e');
      return false;
    }
  }

  // Supprimer un élément
  Future<bool> deleteDocument(String collection, String id) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
      return true;
    } catch (e) {
      print('Erreur lors de la suppression du document: $e');
      return false;
    }
  }
}

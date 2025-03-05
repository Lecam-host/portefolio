import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

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
              backgroundImage: AssetImage('assets/images/photo.jpeg'),
            ),
          ),
          const SizedBox(height: 24),
          // Nom et titre
          const Text(
            'Lecam Papa',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Développeur Flutter',
            style: TextStyle(fontSize: 20, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          // Description courte
          Text(
            'Passionné par le développement mobile et les interfaces utilisateur intuitives, avec 3 ans d\'expérience en Flutter.',

            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

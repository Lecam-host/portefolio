import 'package:flutter/material.dart';
import 'package:mon_cv/model/model.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';

class ExperienceCard extends StatelessWidget {
  final ExperienceItem experience;
  final bool isFirst;
  final bool isLast;

  const ExperienceCard({
    super.key,
    required this.experience,
    this.isFirst = false,
    this.isLast = false,
  });

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

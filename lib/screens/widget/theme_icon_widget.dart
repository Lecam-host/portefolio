import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class ThemeIconWidget extends StatelessWidget {
  const ThemeIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Provider.of<ThemeModel>(context).isDarkMode
            ? Icons.light_mode
            : Icons.dark_mode,
      ),
      onPressed: () {
        Provider.of<ThemeModel>(context, listen: false).toggleTheme();
      },
    );
  }
}

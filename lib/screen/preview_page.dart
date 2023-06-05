import 'dart:io';

import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  final String path;

  final String name;

  const PreviewPage({super.key, required this.path, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [Image.file(File(path)), Text(name)],
        ),
      ),
    );
  }
}

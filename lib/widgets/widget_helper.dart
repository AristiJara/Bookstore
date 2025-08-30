import 'dart:io';
import 'package:flutter/material.dart';

Widget buildBookImage(String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) {
    return const Icon(Icons.image_not_supported, size: 40, color: Colors.grey);
  }

  if (imagePath.startsWith('http')) {
    return Image.network(imagePath, fit: BoxFit.cover);
  } else {
    return Image.file(File(imagePath), fit: BoxFit.cover);
  }
}

import 'package:flutter/material.dart';

class RecentFile extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;

  const RecentFile({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          Image.network(imagePath, width: 50, height: 50, fit: BoxFit.cover),
      title: Text(title),
      subtitle: Text(date),
    );
  }
}

import 'package:flutter/material.dart';

class BioBox extends StatelessWidget {
  final String text;
  const BioBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20)),
        child: Text(text.isNotEmpty ? text : "bio",
            style: TextStyle(color: Theme.of(context).colorScheme.primary)));
  }
}

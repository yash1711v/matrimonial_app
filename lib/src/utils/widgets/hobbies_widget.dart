import 'package:flutter/material.dart';

class HobbiesWrap extends StatelessWidget {
  final Set<String> allHobbies;

  const HobbiesWrap({required this.allHobbies, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Container(
        // padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor,
        ),
        child: Wrap(
          spacing: 5.0, // Horizontal spacing between items
          runSpacing: 8.0, // Vertical spacing between rows
          children: allHobbies.map((hobby) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF4B164C).withOpacity(0.80),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                hobby,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
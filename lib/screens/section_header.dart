import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section.dart';

class SectionHeader extends StatelessWidget {
  final Section section;

  SectionHeader( this.section);

  @override
  Widget build(BuildContext context) {
    return Text(
      section.name,
      style:  TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 18,
      ),
    );
  }
}

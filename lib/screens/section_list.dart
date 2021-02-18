import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:loja_virtual/screens/item_tile.dart';
import 'package:loja_virtual/screens/section_header.dart';

class SectionList extends StatelessWidget {
  final Section section;

  SectionList(this.section);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionHeader(section),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index){
                return ItemTile(section.items[index]);
              },
              separatorBuilder: (_, __) => const SizedBox(width: 4,),
              itemCount: section.items.length,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:black_hat_app/core/widgets/widgets_helper.dart';
import 'package:flutter/material.dart';

Widget buildSearchScreen() {
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      WidgetHelpers.sectionTitle('Recent Searches'),
      ...['Linux tips', 'Sports news', 'Parenting', 'Tech']
          .map((search) => ListTile(
                leading: const Icon(Icons.search),
                title: Text(search),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              )),
      WidgetHelpers.sectionTitle('Popular Topics'),
      ...['Technology', 'Relationships', 'Sports', 'Programming']
          .map((topic) => ListTile(
                leading: const Icon(Icons.tag),
                title: Text('#$topic'),
                trailing: Text('${topic.length * 100} posts'),
              )),
    ],
  );
}

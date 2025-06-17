import 'package:black_hat_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

AppBar appBar(
    {required bool showSearch,
    required TextEditingController searchController,
    required Function(bool) setState}) {
  return AppBar(
    title: showSearch
        ? TextField(
            controller: searchController,
            style: AppTextStyles.appBarTitle(),
            decoration: const InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          )
        : const Text('Black Hat'),
    actions: [
      IconButton(
        icon: Icon(showSearch ? Icons.close : Icons.search),
        onPressed: () => setState(showSearch),
      ),
    ],
    
  );
}

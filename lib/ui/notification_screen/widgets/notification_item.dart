import 'package:flutter/material.dart';

Widget buildNotificationItem(String text, String time) {
  return ListTile(
    leading:  const CircleAvatar(
      child: Icon(Icons.notifications),
      backgroundColor: Colors.grey,
    ),
    title: Text(text),
    subtitle: Text(time),
    trailing: const Icon(Icons.chevron_right),
  );
}

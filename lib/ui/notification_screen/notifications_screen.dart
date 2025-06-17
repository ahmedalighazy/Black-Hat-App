import 'package:black_hat_app/ui/notification_screen/widgets/notification_item.dart';
import 'package:flutter/material.dart';

Widget buildNotificationsScreen() {
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      buildNotificationItem('New comment on your post', '5m'),
      buildNotificationItem('Your post got 15 likes', '1h'),
      buildNotificationItem('3 new followers', '2h'),
      buildNotificationItem('Trending in Technology', '4h'),
    ],
  );
}

import 'package:flutter/material.dart';

Future<String?> showCurrencyPicker(BuildContext context) {
  return showModalBottomSheet<String>(
    useRootNavigator: true,
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300]),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Text('₽', style: TextStyle(fontSize: 20)),
            title: const Text('Российский рубль ₽'),
            onTap: () => Navigator.of(context).pop('₽'),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          ListTile(
            leading: const Text('\$', style: TextStyle(fontSize: 20)),
            title: const Text('Американский доллар \$'),
            onTap: () => Navigator.of(context).pop('\$'),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          ListTile(
            leading: const Text('€', style: TextStyle(fontSize: 20)),
            title: const Text('Евро'),
            onTap: () => Navigator.of(context).pop('€'),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          ListTile(
            leading: const Icon(Icons.close, color: Colors.white),
            title: const Text('Отмена', style: TextStyle(color: Colors.white)),
            tileColor: Colors.redAccent,
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

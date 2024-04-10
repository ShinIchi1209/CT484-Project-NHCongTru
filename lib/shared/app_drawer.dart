import 'package:ct484_project/screens/account_edit.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Options'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Account edit'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(AccountEdit.routeName);
              }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pushReplacementNamed('/');
              // context.read<AuthManager>().logout();
            },
          ),
        ],
      ),
    );
  }
}

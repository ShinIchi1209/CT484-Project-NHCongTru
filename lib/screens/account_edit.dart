import 'package:flutter/material.dart';
import '../shared/app_drawer.dart';

class AccountEdit extends StatefulWidget {
  static const routeName = '/accountEdit';

  @override
  _AccountEditState createState() => _AccountEditState();
}

class _AccountEditState extends State<AccountEdit> {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Edit'),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'New Email',
                ),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'New Password',
                ),
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Thực hiện cập nhật thông tin
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

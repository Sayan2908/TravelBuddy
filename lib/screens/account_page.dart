import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = user;
    });
  }

  void _signIn() {
    // Navigate back to the authentication page
    Navigator.pop(context);
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_user != null)
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_user!.photoURL ?? ''),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Account Name: ${_user!.displayName}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Email: ${_user!.email}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: Text('Sign Out'),
                  ),
                ],
              )
            else
              ElevatedButton(
                onPressed: _signIn,
                child: Text('Sign In'),
              ),
          ],
        ),
      ),
    );
  }
}

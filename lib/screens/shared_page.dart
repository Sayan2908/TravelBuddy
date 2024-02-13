import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_checklist/firebasefunctions.dart';
import 'package:travel_checklist/screens/planspage.dart';

class SharedPage extends StatefulWidget {
  const SharedPage({Key? key}) : super(key: key);

  @override
  State<SharedPage> createState() => _SharedPageState();
}

class _SharedPageState extends State<SharedPage> {
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _userSignedIn = false;

  @override
  void initState() {
    super.initState();
    // Check if the user is signed in
    _checkUserSignIn();
  }

  Future<void> _checkUserSignIn() async {
    // Your logic to check if the user is signed in
    bool signedIn = await (_auth.currentUser!=null);
    setState(() {
      _userSignedIn = signedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userSignedIn ? _buildPlansList() : _buildSignInButton(),
      floatingActionButton: _userSignedIn
          ? SizedBox(
        width: 128,
        height: 64,
        child: FloatingActionButton.extended(
          onPressed: _showAddPlanDialog,
          label: Text('Add Plan'),
        ),
      )
          : null,
    );
  }

  Widget _buildPlansList() {
    return FutureBuilder<List<String>>(
      future: _firebaseFunctions.getAllPlans(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<String> plans = snapshot.data ?? [];
          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    plans[index],
                    style: TextStyle(color: Colors.black87),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _firebaseFunctions.deletePlan(plans[index]);
                      setState(() {});
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlanTasksPage(planName: plans[index])),
                    );
                  },
                  tileColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildSignInButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Add your logic to sign in the user
          // Example: Navigator.pushNamed(context, '/sign-in');
        },
        child: Text('Sign In'),
      ),
    );
  }

  void _showAddPlanDialog() {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Plan'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter plan name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String planName = _controller.text.trim();
                if (planName.isNotEmpty) {
                  await _firebaseFunctions.createNewPlan(planName);
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}

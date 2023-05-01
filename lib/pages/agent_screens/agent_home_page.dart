import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthensure/pages/patient_screens/insurance_claims.dart';
import '../../auth/login_page.dart';

class Agent extends StatefulWidget {
  const Agent({super.key});

  @override
  State<Agent> createState() => _AgentState();
}

class _AgentState extends State<Agent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insurance Requests"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: StreamBuilder(
        // return streams of list insurance application form
        stream: readInsurance(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final insurance = snapshot.data!;

            return ListView(
              children: insurance.map(buildInsurance).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildInsurance(InsuranceForm form) => ListTile(
        leading: CircleAvatar(child: Text('${form.insuranceId}')),
        title: Text(form.company),
        subtitle: Text(form.name),
      );

  Stream<List<InsuranceForm>> readInsurance() => FirebaseFirestore.instance
      .collection('insurance')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => InsuranceForm.fromJson(doc.data()))
          .toList());

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}

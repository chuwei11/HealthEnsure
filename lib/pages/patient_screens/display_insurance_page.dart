import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InsuranceDisplay extends StatefulWidget {
  @override
  _InsuranceDisplayState createState() => _InsuranceDisplayState();
}

class _InsuranceDisplayState extends State<InsuranceDisplay> {
  CollectionReference _dataCollection =
      FirebaseFirestore.instance.collection('collection_name');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Display Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _dataCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['insurance']),
                subtitle: Text(data['insuranceCompany']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

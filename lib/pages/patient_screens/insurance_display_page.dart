import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InsuranceDisplay extends StatelessWidget {
  Future<void> retrieveData() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('insurance')
        .where('email', isEqualTo: 'steve@gmail.com')
        .get();

    final List<Map<String, dynamic>> documents =
        snapshot.docs.map((doc) => doc.data()).toList();

    documents.forEach((document) {
      final String insuranceCompany = document['insuranceCompany'];
      final String name = document['name'];
      final String status = document['status'];
      print('$insuranceCompany, $name, $status');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insurance Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('insurance')
            .where('email', isEqualTo: 'steve@gmail.com')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Company name: ${document['insuranceCompany']}',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Name: ${document['name']}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Status: ${document['status']}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import '../../auth/login_page.dart';

class Agent extends StatefulWidget {
  const Agent({Key? key}) : super(key: key);

  @override
  State<Agent> createState() => _AgentState();
}

class _AgentState extends State<Agent> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;
  String selectedStatus = 'pending';
  List<DocumentSnapshot> insuranceData = [];

  @override
  void initState() {
    super.initState();
    fetchInsuranceData();
  }

  void fetchInsuranceData() async {
    QuerySnapshot querySnapshot = await firestore.collection('insurance').get();
    setState(() {
      insuranceData = querySnapshot.docs;
    });
  }

  void updateInsuranceStatus(String docId, String newStatus) async {
    await firestore
        .collection('insurance')
        .doc(docId)
        .update({'status': newStatus});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Insurance status updated.'),
    ));
    fetchInsuranceData();
  }

  void showAlert(QuickAlertType quickAlertType) {
    QuickAlert.show(context: context, type: quickAlertType);
  }

  List<Widget> buildInsuranceList() {
    return insuranceData
        .where((doc) =>
            (doc.data() as Map<String, dynamic>)['status'] == selectedStatus)
        .map((doc) => ListTile(
              title: Text(
                  (doc.data() as Map<String, dynamic>)['insuranceCompany'] ??
                      ''),
              subtitle: Text(
                  '${(doc.data() as Map<String, dynamic>)['name'] ?? ''} (${(doc.data() as Map<String, dynamic>)['age'] ?? ''})'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text((doc.data() as Map<String, dynamic>)['insuranceId'] ??
                      ''),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Change status',
                              style: TextStyle(fontSize: 5)),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    changeInsuranceStatus(doc.id, 'Approved');
                                    Navigator.pop(context);
                                  },
                                  child: Text('Approve'),
                                ),
                                SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    changeInsuranceStatus(doc.id, 'Rejected');
                                    Navigator.pop(context);
                                  },
                                  child: Text('Reject'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text('Change status'),
                  ),
                ],
              ),
            ))
        .toList();
  }

  Future<void> changeInsuranceStatus(String docId, String newStatus) async {
    await firestore
        .collection('insurance')
        .doc(docId)
        .update({'status': newStatus});
    fetchInsuranceData();
  }

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

  @override
  Widget build(BuildContext context) {
    //var _insuranceProvider = Provider.of<InsuranceProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Insurance Application List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              logout(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Pending'),
              selected: selectedStatus == 'pending',
              onTap: () {
                setState(() {
                  selectedStatus = 'pending';
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text('Approved'),
              selected: selectedStatus == 'approved',
              onTap: () {
                setState(() {
                  selectedStatus = 'approved';
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text('Rejected'),
              selected: selectedStatus == 'rejected',
              onTap: () {
                setState(() {
                  selectedStatus = 'rejected';
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedStatus = 'pending';
                    });
                  },
                  child: Text('Pending'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedStatus = 'approved';
                    });
                  },
                  child: Text('Approved'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedStatus = 'rejected';
                    });
                  },
                  child: Text('Rejected'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: insuranceData.length,
                itemBuilder: (context, index) {
                  if ((insuranceData[index].data()
                          as Map<String, dynamic>)['status'] !=
                      selectedStatus) {
                    return SizedBox.shrink();
                  }
                  return Container(
                    height: 120,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              (insuranceData[index].data() as Map<String,
                                      dynamic>)['insuranceCompany'] ??
                                  '',
                            ),
                            subtitle: Text(
                              '${(insuranceData[index].data() as Map<String, dynamic>)['name'] ?? ''} (${(insuranceData[index].data() as Map<String, dynamic>)['age'] ?? ''})',
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  (insuranceData[index].data() as Map<String,
                                          dynamic>)['insuranceId'] ??
                                      '',
                                ),
                                SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () async {
                                    String imageUrl = (insuranceData[index]
                                            .data()
                                        as Map<String, dynamic>)['imageUrl'];
                                    if (imageUrl != null) {
                                      var imageBytes = await FirebaseStorage
                                          .instance
                                          .refFromURL(imageUrl)
                                          .getData();
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: Image.memory(imageBytes!),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text('View Image'),
                                ),
                                SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.edit),
                                            SizedBox(width: 8),
                                            Text(
                                              'Change status',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  changeInsuranceStatus(
                                                    insuranceData[index].id,
                                                    'approved',
                                                  );
                                                  Navigator.pop(context);
                                                  showAlert(
                                                      QuickAlertType.success);
                                                },
                                                child: Text('Approve'),
                                              ),
                                              SizedBox(height: 12),
                                              ElevatedButton(
                                                onPressed: () {
                                                  changeInsuranceStatus(
                                                    insuranceData[index].id,
                                                    'rejected',
                                                  );
                                                  Navigator.pop(context);
                                                  showAlert(
                                                      QuickAlertType.success);
                                                },
                                                child: Text('Reject'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (context) => AlertDialog(
                                    //     title: Text(
                                    //       'Change status',
                                    //       style: TextStyle(fontSize: 18),
                                    //     ),
                                    //     content: SingleChildScrollView(
                                    //       child: Column(
                                    //         mainAxisSize: MainAxisSize.min,
                                    //         children: [
                                    //           ElevatedButton(
                                    //             onPressed: () {
                                    //               changeInsuranceStatus(
                                    //                 insuranceData[index].id,
                                    //                 'approved',
                                    //               );
                                    //               Navigator.pop(context);
                                    //               showAlert(
                                    //                   QuickAlertType.success);
                                    //             },
                                    //             child: Text('Approve'),
                                    //           ),
                                    //           SizedBox(height: 12),
                                    //           ElevatedButton(
                                    //             onPressed: () {
                                    //               changeInsuranceStatus(
                                    //                 insuranceData[index].id,
                                    //                 'rejected',
                                    //               );
                                    //               Navigator.pop(context);
                                    //               showAlert(
                                    //                   QuickAlertType.success);
                                    //             },
                                    //             child: Text('Reject'),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Text('Change status'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

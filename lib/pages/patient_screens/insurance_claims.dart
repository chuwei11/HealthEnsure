import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthensure/utils/config.dart';
import 'package:quickalert/quickalert.dart';

class InsuranceClaimsPage extends StatefulWidget {
  const InsuranceClaimsPage({super.key});

  @override
  State<InsuranceClaimsPage> createState() => _InsuranceClaimsPageState();
}

class _InsuranceClaimsPageState extends State<InsuranceClaimsPage> {
  final _insuranceIdController = TextEditingController();
  final _insuranceCompanyController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  void showAlert(QuickAlertType quickAlertType) {
    QuickAlert.show(context: context, type: quickAlertType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Insurance Application Form'),
          actions: [
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                Navigator.of(context).pushNamed('InsuranceDisplay');
              },
            ),
          ],
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(padding: EdgeInsets.all(15), children: <Widget>[
              TextField(
                controller: _insuranceIdController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.local_hospital_rounded),
                    border: OutlineInputBorder(),
                    hintText: 'Insurance Id'),
              ),
              Config.smallSpacingBox,
              TextField(
                controller: _insuranceCompanyController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.local_hospital_rounded),
                    border: OutlineInputBorder(),
                    hintText: 'Insurance Company'),
              ),
              Config.smallSpacingBox,
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_2),
                    border: OutlineInputBorder(),
                    hintText: 'Your Name'),
              ),
              Config.smallSpacingBox,
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_2),
                    border: OutlineInputBorder(),
                    hintText: 'Your Age'),
                keyboardType: TextInputType.number,
              ),
              Config.smallSpacingBox,
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_rounded),
                    border: OutlineInputBorder(),
                    hintText: 'Your email address'),
              ),
              Config.smallSpacingBox,
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone_android_rounded),
                    border: OutlineInputBorder(),
                    hintText: 'Your phone no'),
              ),
              Config.largeSpacingBox,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Submit'),
                    onPressed: () async {
                      final insurance = await InsuranceForm(
                        insuranceId: _insuranceIdController.text.trim(),
                        company: _insuranceCompanyController.text.trim(),
                        name: _nameController.text.trim(),
                        phone: _phoneController.text.trim(),
                        email: _emailController.text.trim(),
                        age: int.parse(_ageController.text),
                      ); // insuranceApplication

                      await createInsuranceForm(insurance);
                      Navigator.of(context).pushNamed('patientMain');
                      //Navigator.pop(context);

                      showAlert(QuickAlertType.success);
                    },
                  ),
                ],
              )
            ]),
          ),
        ));
  }

  // Future<InsuranceForm> insuranceApplication(
  //     {required String insuranceId,
  //     required String company,
  //     required String name,
  //     required String phone,
  //     required String email,
  //     required int age
  //     }) async {
  //   // Reference to document
  //   final insurance = FirebaseFirestore.instance.collection('insurance').doc();

  //   final json = {
  //     'insuranceId': insuranceId,
  //     'insuranceCompany': company,
  //     'name': name,
  //     'age': age,
  //     'phone': phone,
  //     'email': email,
  //   };

  //   // Create doc and write data to firebase
  //   await insurance.set(json);

  //   return (InsuranceForm(
  //     id,
  //     insuranceId,
  //     company,
  //     name,
  //     phone,
  //     email,
  //     age,
  //   ));
  // }

  Future createInsuranceForm(InsuranceForm insurance) async {
    final docInsurance =
        FirebaseFirestore.instance.collection('insurance').doc();
    insurance.id = docInsurance.id;

    final json = insurance.toJson();
    await docInsurance.set(json);
  }

  Stream<List<InsuranceForm>> readInsurance() => FirebaseFirestore.instance
      .collection('insurance')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => InsuranceForm.fromJson(doc.data()))
          .toList());
}

class InsuranceForm {
  String id;
  final String insuranceId;
  final String company;
  final String name;
  final String phone;
  final String email;
  final int age;

  InsuranceForm(
      {this.id = '',
      required this.insuranceId,
      required this.company,
      required this.name,
      required this.phone,
      required this.email,
      required this.age});

  Map<String, dynamic> toJson() => {
        'id': id,
        'insuranceId': insuranceId,
        'insuranceCompany': company,
        'email': email,
        'name': name,
        'age': age,
        'phone': phone,
      };

  static InsuranceForm fromJson(Map<String, dynamic> json) => InsuranceForm(
        insuranceId: json['insuranceId'],
        company: json['insuranceCompany'],
        name: json['name'],
        age: json['age'],
        email: json['email'],
        phone: json['phone'],
      );
}

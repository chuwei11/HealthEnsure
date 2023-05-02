import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthensure/utils/config.dart';
import 'package:quickalert/quickalert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

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

  String imageUrl = '';

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
                    hintText: 'Your phone no.'),
              ),
              Config.mediumSpacingBox,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blueGrey)),
                    child: Text(
                      'Upload Doctor Prescription',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    onPressed: () async {
                      // Pick image
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'jpeg', 'png'],
                      );

                      if (result == null) return;
                      String uniqueFileName =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      // Upload to Firebase Storage

                      //Get reference to storage root
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('docPrescriptions');

                      //Create reference for doctor prescription to be stored
                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);

                      try {
                        // Store file
                        await referenceImageToUpload
                            .putData(result.files.single.bytes!);
                        // upon success, get download URL
                        imageUrl =
                            await referenceImageToUpload.getDownloadURL();
                        print('Image uploaded to $imageUrl');

                        // Update the UI with the new image URL
                        setState(() {});
                      } catch (error) {
                        print('Error uploading image: $error');
                      }
                    },
                  ),
                  Config.smallSpacingBox,
                  imageUrl != ''
                      ? Image.network(
                          imageUrl,
                          height: 200.0,
                        )
                      : SizedBox(height: 0.0),
                  Config.smallSpacingBox,
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
                        status: 'pending',
                        date: DateTime.now(),
                        imageUrl: imageUrl,
                      ); // insuranceApplication
                      //Add a dialog box to show image uploaded
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
  final String status;
  final DateTime date;
  String imageUrl;

  InsuranceForm({
    this.id = '',
    required this.insuranceId,
    required this.company,
    required this.name,
    required this.phone,
    required this.email,
    required this.age,
    required this.status,
    required this.date,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'insuranceId': insuranceId,
        'insuranceCompany': company,
        'email': email,
        'name': name,
        'age': age,
        'phone': phone,
        'status': 'pending',
        'date': date.toIso8601String(),
        'imageUrl': imageUrl,
      };

  static InsuranceForm fromJson(Map<String, dynamic> json) => InsuranceForm(
        insuranceId: json['insuranceId'],
        company: json['insuranceCompany'],
        name: json['name'],
        age: json['age'],
        email: json['email'],
        phone: json['phone'],
        status: json['status'],
        date: DateTime.parse(json['date']),
        imageUrl: json['imageUrl'],
      );
}

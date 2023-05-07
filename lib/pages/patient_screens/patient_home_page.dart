import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthensure/components/appointment_card.dart';
import 'package:healthensure/components/doctor_card.dart';
import 'package:healthensure/models/auth_model.dart';
import 'package:healthensure/providers/dio_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/login_page.dart';
import '../../utils/config.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  @override
  State<PatientHomePage> createState() => PatientHomePageState();
}

void _logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}

class PatientHomePageState extends State<PatientHomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic> user1 = {};
  Map<String, dynamic> doctor = {};
  List<dynamic> favList = [];
  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.userDoctor,
      "specialty": "General",
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "specialty": "Cardiology",
    },
    {
      "icon": FontAwesomeIcons.child,
      "specialty": "Pediatrics",
    },
    {
      "icon": FontAwesomeIcons.tooth,
      "specialty": "Dentistry",
    },
    {
      "icon": FontAwesomeIcons.personPregnant,
      "specialty": "Gynecology",
    },
    {
      "icon": FontAwesomeIcons.bone,
      "specialty": "Orthopedics",
    },
    {
      "icon": FontAwesomeIcons.brain,
      "specialty": "Psychiatry",
    },
  ];

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    user1 = Provider.of<AuthModel>(context, listen: false).getUser;
    doctor = Provider.of<AuthModel>(context, listen: false).getAppointment;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;

    return Scaffold(
        body: user1.isEmpty
            ? Center(
                // if user is empty, return progress indicator instead
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Signed in as: ' + user.email!,
                              textAlign: TextAlign.start,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                // retrieve instance of SharedPref and gets token value
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final token = prefs.getString('token') ?? '';

                                // if token found
                                if (token.isNotEmpty && token != '') {
                                  // sends logout request to server
                                  final response =
                                      await DioProvider().logout(token);

                                  if (response == 200) {
                                    //once deleted the access token
                                    //remove token saved at Shared Preference too
                                    await prefs.remove('token');
                                    setState(() {
                                      //redirect to login page
                                      // MaterialPageRoute(
                                      //     builder: (context) => LoginPage());
                                    });
                                  }
                                  ;
                                  _logout(context);
                                }
                              },
                              color: Colors.deepPurpleAccent[200],
                              child: Text('Logout'),
                              height: 30,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              user1['name'].toString(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage('assets/profile/profile1.png'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Config.smallSpacingBox,
                        // specialty listing
                        const Text('Specialties',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                        Config.smallSpacingBox,
                        SizedBox(
                          height: Config.heightSize * 0.05,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children:
                                List<Widget>.generate(medCat.length, (index) {
                              return Card(
                                margin: const EdgeInsets.only(right: 20),
                                color: Color.fromARGB(255, 35, 180, 137),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      FaIcon(medCat[index]['icon'],
                                          color: Colors.white),
                                      const SizedBox(width: 20),
                                      Text(medCat[index]['specialty'],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        Config.smallSpacingBox,
                        Text(
                          'Today\'s Appointment',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Config.smallSpacingBox,
                        // passing appointment details here
                        doctor.isNotEmpty
                            ? AppointmentCard(
                                doctor: doctor, color: Config.primaryColor)
                            : Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      '-- No Appointment For Today --',
                                      style: TextStyle(
                                        decorationThickness: 1.5,
                                        letterSpacing: 2,
                                        wordSpacing: 5,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        Config.smallSpacingBox,
                        Text(
                          'Recommended Doctors',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Config.smallSpacingBox,
                        Column(
                          children:
                              List.generate(user1['doctor'].length, (index) {
                            return DoctorCard(
                              //route: 'docDetails',
                              doctor: user1['doctor'][index],
                              isFav: favList.contains(
                                      user1['doctor'][index]['doc_id'])
                                  ? true
                                  : false,
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                )));
  }

  // }
}

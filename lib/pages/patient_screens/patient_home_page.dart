import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthensure/components/appointment_card.dart';
import 'package:healthensure/components/doctor_card.dart';
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
      "specialize": "General",
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "specialize": "Cardiology",
    },
    {
      "icon": FontAwesomeIcons.child,
      "specialize": "Pediatrics",
    },
    {
      "icon": FontAwesomeIcons.tooth,
      "specialize": "Dentistry",
    },
    {
      "icon": FontAwesomeIcons.personPregnant,
      "specialize": "Gynecology",
    },
    {
      "icon": FontAwesomeIcons.bone,
      "specialize": "Orthopedics",
    },
    {
      "icon": FontAwesomeIcons.brain,
      "specialize": "Psychiatry",
    },
  ];

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    // user = Provider.of<AuthModel>(context, listen: false).getUser;
    // doctor = Provider.of<AuthModel>(context, listen: false).getAppointment;
    // favList = Provider.of<AuthModel>(context, listen: false).getFav;

    return Scaffold(
        //   //if user is empty, then return progress indicator
        //   body: user.isEmpty
        //       ? const Center(
        //           child: CircularProgressIndicator(),
        //         )
        //       : Padding(
        //           padding: const EdgeInsets.symmetric(
        //             horizontal: 15,
        //             vertical: 15,
        //           ),
        //           child: SafeArea(
        //             child: SingleChildScrollView(
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: <Widget>[
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: <Widget>[
        //                       Text(
        //                         user['name'],
        //                         style: const TextStyle(
        //                           fontSize: 24,
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //                       const SizedBox(
        //                         child: CircleAvatar(
        //                           radius: 30,
        //                           backgroundImage:
        //                               AssetImage('assets/profile1.jpg'),
        //                         ),
        //                       )
        //                     ],
        //                   ),
        //                   Config.spaceMedium,
        //                   const Text(
        //                     'Specialization',
        //                     style: TextStyle(
        //                       fontSize: 16,
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                   Config.spaceSmall,
        //                   SizedBox(
        //                     height: Config.heightSize * 0.05,
        //                     child: ListView(
        //                       scrollDirection: Axis.horizontal,
        //                       children:
        //                           List<Widget>.generate(medCat.length, (index) {
        //                         return Card(
        //                           margin: const EdgeInsets.only(right: 20),
        //                           color: Config.primaryColor,
        //                           child: Padding(
        //                             padding: const EdgeInsets.symmetric(
        //                                 horizontal: 15, vertical: 10),
        //                             child: Row(
        //                               mainAxisAlignment:
        //                                   MainAxisAlignment.spaceAround,
        //                               children: <Widget>[
        //                                 FaIcon(
        //                                   medCat[index]['icon'],
        //                                   color: Colors.white,
        //                                 ),
        //                                 const SizedBox(
        //                                   width: 20,
        //                                 ),
        //                                 Text(
        //                                   medCat[index]['specialize'],
        //                                   style: const TextStyle(
        //                                     fontSize: 16,
        //                                     color: Colors.white,
        //                                   ),
        //                                 ),
        //                               ],
        //                             ),
        //                           ),
        //                         );
        //                       }),
        //                     ),
        //                   ),
        //                   Config.spaceSmall,
        //                   const Text(
        //                     'Appointment Today',
        //                     style: TextStyle(
        //                       fontSize: 16,
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                   Config.spaceSmall,
        //                   doctor.isNotEmpty
        //                       ? AppointmentCard(
        //                           doctor: doctor,
        //                           color: Config.primaryColor,
        //                         )
        //                       : Container(
        //                           width: double.infinity,
        //                           decoration: BoxDecoration(
        //                             color: Colors.grey.shade300,
        //                             borderRadius: BorderRadius.circular(10),
        //                           ),
        //                           child: const Center(
        //                             child: Padding(
        //                               padding: EdgeInsets.all(20),
        //                               child: Text(
        //                                 'No Appointment Today',
        //                                 style: TextStyle(
        //                                   fontSize: 16,
        //                                   fontWeight: FontWeight.w600,
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                   Config.spaceSmall,
        //                   const Text(
        //                     'Top Doctors',
        //                     style: TextStyle(
        //                       fontSize: 16,
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                   Config.spaceSmall,
        //                   Column(
        //                     children: List.generate(user['doctor'].length, (index) {
        //                       return DoctorCard(
        //                         doctor: user['doctor'][index],
        //                         //if lates fav list contains particular doctor id, then show fav icon
        //                         isFav: favList
        //                                 .contains(user['doctor'][index]['doc_id'])
        //                             ? true
        //                             : false,
        //                       );
        //                     }),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        // );

        //*implementation */
        //     body: Center(
        //         child: Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Text('signed in as: ' + user.email!),
        //     MaterialButton(
        //       onPressed: () {
        //         FirebaseAuth.instance.signOut();
        //       },
        //       color: Colors.deepPurpleAccent[200],
        //       child: Text('Sign Out'),
        //     )
        //   ],
        // ));
        body: Padding(
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        MaterialButton(
                          onPressed: () => _logout(context),
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
                          'Steve', // hardcode username
                          style: const TextStyle(
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
                    // specialize listing
                    const Text('Category', // hardcode username
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                    Config.smallSpacingBox,
                    SizedBox(
                      height: Config.heightSize * 0.05,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List<Widget>.generate(medCat.length, (index) {
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
                                  Text(medCat[index]['specialize'],
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Config.smallSpacingBox,
                    AppointmentCard(),
                    Config.smallSpacingBox,
                    Text(
                      'Doctor List',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Config.smallSpacingBox,
                    Column(
                      children: List.generate(10, (index) {
                        return DoctorCard(route: 'docDetails');
                      }),
                    )
                  ],
                ),
              ),
            )));
  }
}

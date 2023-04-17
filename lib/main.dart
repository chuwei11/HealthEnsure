import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthensure/auth/login_page.dart';
import 'package:healthensure/pages/common/doctor_details.dart';
import 'package:healthensure/pages/patient_screens/booking_page.dart';
import 'package:healthensure/pages/patient_screens/booking_success.dart';
import 'package:healthensure/pages/patient_screens/patient_main_layout.dart';
import 'package:healthensure/auth/register_page.dart';
import 'firebase_options.dart';
import 'main_layout.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),

      navigatorKey: navigatorKey,
      title: 'HealthEnsure App',
      //initialRoute: '/',
      routes: {
        //'/': (context) => const LoginPage(),
        'patientMain': (context) => const PatientMainLayout(),
        'booking_page': (context) => const BookingPage(),
        'docDetails': (context) => const DoctorDetails(),
        'succBooked': (context) => const AppointmentBooked(),
      },
    );
  }
}

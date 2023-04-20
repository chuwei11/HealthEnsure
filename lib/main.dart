import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthensure/auth/login_page.dart';
import 'package:healthensure/models/auth_model.dart';
import 'package:healthensure/pages/common/doctor_details.dart';
import 'package:healthensure/pages/patient_screens/booking_page.dart';
import 'package:healthensure/pages/patient_screens/booking_success.dart';
import 'package:healthensure/pages/patient_screens/patient_main_layout.dart';
import 'package:healthensure/auth/register_page.dart';
import 'firebase_options.dart';
import 'main_layout.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
    options: const FirebaseOptions(
      apiKey: "AIzaSyCs-2SF1Q0FS0s1QdIvmqrszMq20bFfzZA",
      appId: "1:1018668404314:android:6c5ce1922c580cc70a5263",
      messagingSenderId: "1018668404314",
      projectId: "healthensure-4c0a8",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthModel>(
      create: (context) => AuthModel(),
      child: MaterialApp(
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
      ),
    );
  }
}

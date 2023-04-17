import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/config.dart';

class AppointmentBooked extends StatefulWidget {
  const AppointmentBooked({super.key});

  @override
  State<AppointmentBooked> createState() => _AppointmentBookedState();
}

class _AppointmentBookedState extends State<AppointmentBooked> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(height: 180),
        Lottie.asset('assets/animated/SeeYou.json', repeat: true),
        Config.mediumSpacingBox,
        Text(
          'Booking Success!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Config.tinySpacingBox,
        Text(
          'See you soon!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Config.mediumSpacingBox,
        Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    textStyle:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
                onPressed: () {
                  Navigator.of(context).pushNamed('patientMain');
                },
                icon: Icon(Icons.home),
                label: Text('Back To Homepage')))
      ]),
    );
  }
}

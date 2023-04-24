import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:healthensure/pages/patient_screens/doctor_details.dart';

import '../utils/config.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({Key? key, required this.route, required this.doctor})
      : super(key: key);

  final String route;
  final Map<String, dynamic> doctor; // tp retrieve doc details

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(children: [
            SizedBox(
              width: Config.widthSize * 0.33,
              child: Image.network(
                  "http://127.0.0.1:8000${doctor['doctor_profile']}",
                  fit: BoxFit.fill),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Dr ${doctor['doctor_name']}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${doctor['specialties']}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const <Widget>[
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Spacer(flex: 1),
                        Text('4.5'),
                        Spacer(flex: 1),
                        Text('Reviews'),
                        Spacer(flex: 1),
                        Text('(20)'),
                        Spacer(flex: 7),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
        onTap: () {
          // redirect to doc details page
          Navigator.of(context).pushNamed(route, arguments: doctor);
        },
      ),
    );
  }
}

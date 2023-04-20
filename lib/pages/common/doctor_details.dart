import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthensure/components/custom_appbar.dart';

import '../../components/button.dart';
import '../../utils/config.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({Key? key}) : super(key: key);

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    // get arguments passed from doctor card (components/doctor_card)
    final doctor = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Doctor Details',
          icon: const FaIcon(Icons.arrow_back_ios_new),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isFav = !isFav;
                });
              },
              icon: FaIcon(
                isFav ? Icons.favorite_rounded : Icons.favorite_outline,
                color: Colors.red,
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // pass doc details here
              AboutDoctor(
                doctor: doctor,
              ),
              DetailContent(
                doctor: doctor,
              ),
              Spacer(),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Button(
                    width: double.infinity,
                    disabled: false,
                    onPressed: () {
                      // navigate to booking page
                      Navigator.of(context).pushNamed('booking_page');
                    },
                    title: 'Book Appointment',
                  ))
            ],
          ),
        ));
  }
}

// build doctor avatar and intro
class AboutDoctor extends StatelessWidget {
  const AboutDoctor({Key? key, required this.doctor}) : super(key: key);

  final Map<dynamic, dynamic> doctor;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
        //width: double.infinity,
        child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10),
          // child: CircleAvatar(
          //   radius: 70.0,
          //   backgroundImage: AssetImage('assets/profile/Doctor2.png'),
          //   backgroundColor: Colors.white,
          // ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 5.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://127.0.0.1:8000${doctor['doctor_profile']}"),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Config.mediumSpacingBox,
        Text(
          "Dr ${doctor['doctor_name']}",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w800,
            decoration: TextDecoration.underline,
            decorationThickness: 2.0,
            decorationStyle: TextDecorationStyle.solid,
            fontStyle: FontStyle.italic,
          ),
        ),
        Config.smallSpacingBox,
        SizedBox(
            width: Config.widthSize * 0.75,
            child: Text(
              'MBBS (International Medical University, Malaysia, MRCP (Royal College of Physicians, United Kingdom)',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            )),
        Config.smallSpacingBox,
        SizedBox(
          width: Config.widthSize * 0.75,
          child: Text(
            '"Gleneagles Hospital Penang"',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        )
      ],
    ));
  }
}

class DetailContent extends StatelessWidget {
  const DetailContent({Key? key, required this.doctor}) : super(key: key);
  final Map<dynamic, dynamic> doctor;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: EdgeInsets.all(10),
      //margin: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Config.smallSpacingBox,
          // doc exp, patient and rating
          DoctorInfo(
            no_of_patients: doctor['patients_count'],
            experience: doctor['experience'],
          ),
          Config.mediumSpacingBox,
          Text('About Doc',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Config.smallSpacingBox,
          Text(
            'Dr ${doctor['doctor_name']} is an experienced ${doctor['specialties']} Specialist in Penang. He/She is graduated since 2009, and have completed his/her training at Sabah General Hospital',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class DoctorInfo extends StatelessWidget {
  const DoctorInfo(
      {super.key, required this.no_of_patients, required this.experience});

  final int no_of_patients;
  final int experience;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InfoCard(
          label: 'Patient Count',
          value: '$no_of_patients',
        ),
        SizedBox(width: 10),
        InfoCard(
          label: 'Experience',
          value: '$experience years',
        ),
        SizedBox(width: 10),
        InfoCard(
          label: 'Rating',
          value: '4.8',
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const InfoCard({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: Config.primaryColor,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            Text(label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
            Config.tinySpacingBox,
            Text(value,
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }
}

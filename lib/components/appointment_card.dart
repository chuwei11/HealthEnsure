import 'package:flutter/material.dart';
import 'package:healthensure/utils/config.dart';
import 'package:healthensure/main.dart';
import 'package:healthensure/providers/dio_provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({super.key, required this.doctor, required this.color});

  final Map<String, dynamic> doctor;
  final Color color;

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          //color: Config.primaryColor,
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "http://127.0.0.1:8000${widget.doctor['doctor_profile']}"),
                    ),
                    SizedBox(width: 8),
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Dr ${widget.doctor['doctor_name']}",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 2),
                        Text(widget.doctor['specialties'],
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 255, 215, 64),
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                Config.smallSpacingBox,
                // Schedule appointment info
                ScheduleCard(appointment: widget.doctor['appointments']),
                Config.smallSpacingBox,
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Cancellation not allowed"),
                                content: Text(
                                    "Please contact hospital admin to cancel the appointment."),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                        ),
                        child: Text(
                          'Completed',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return RatingDialog(
                                    initialRating: 1.0,
                                    title: Text('Rate this Doctor',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w800)),
                                    // app's logo
                                    image: const FlutterLogo(
                                      //'assets/icon/logo.png',
                                      size: 80,
                                    ), //const FlutterLogo(size: 100),
                                    message: Text(
                                      'Please rate our doctor based on your experience',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    submitButtonText: "Submit",
                                    commentHint: "Type your reviews...",
                                    onSubmitted: (response) async {
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      final token =
                                          prefs.getString('token') ?? '';

                                      // The token is used to authenticate the user's request when
                                      // they submit a review using the DioProvider.storeReviews() method.
                                      final rating = await DioProvider()
                                          .storeReviews(
                                              response.comment,
                                              response.rating,
                                              // appointment id
                                              widget.doctor['appointments']
                                                  ['id'],
                                              // doctor id
                                              widget.doctor['doc_id'],
                                              token);
                                      print(rating);
                                      // once review submitted successfully, refresh the patient main page
                                      if (rating == 200 && rating != '') {
                                        Navigator.of(context)
                                            .pushNamed('patientMain');
                                        // MyApp.navigatorKey.currentState!
                                        //     .pushNamed('patientMain');
                                      }
                                    });
                              });
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

// Schedule Widget
class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key, required this.appointment});
  final Map<String, dynamic> appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.calendar_month_sharp,
            color: Colors.white,
            size: 15,
          ),
          SizedBox(width: 5),
          Text("${appointment['day']}, ${appointment['date']}",
              style: TextStyle(color: Colors.white)),
          SizedBox(width: 20),
          Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          SizedBox(width: 5),
          Flexible(
              child: Text("${appointment['time']}",
                  style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }
}

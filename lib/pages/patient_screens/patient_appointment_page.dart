import 'package:flutter/material.dart';
import 'package:healthensure/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthensure/providers/dio_provider.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class PatientAppointmentPage extends StatefulWidget {
  const PatientAppointmentPage({super.key});

  @override
  State<PatientAppointmentPage> createState() => _PatientAppointmentPageState();
}

// appointment status
enum AppointmentStatus { upcoming, complete, cancelled }

class _PatientAppointmentPageState extends State<PatientAppointmentPage> {
  // set initial status as 'upcoming'
  AppointmentStatus status = AppointmentStatus.upcoming;
  Alignment _alignment = Alignment.centerLeft;
  List<dynamic> schedules = [];

  // get appointment details after booking is done
  Future<void> getAppointments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final appointment = await DioProvider().getAppointments(token);
    if (appointment != 'Unable to get Response!') {
      setState(() {
        schedules = json.decode(appointment);
        print(schedules);
      });
    }
  }

  // Function to cancel an appointment
  void cancelAppointment(int appointmentId) async {
    final database = await openDatabase('doc_app.db');
    try {
      final db = await database;
      await db.update(
        'appointments',
        {'status': 'cancelled'},
        where: 'id = ?',
        whereArgs: [appointmentId],
      );
      print('Appointment cancelled successfully!');
    } catch (error) {
      print('Failed to cancel appointment: $error');
    }
  }

  @override
  void initState() {
    getAppointments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return filtered appointment
    // schedule info
    List<dynamic> filteredSchedule = schedules.where((var schedule) {
      switch (schedule['status']) {
        case 'upcoming':
          schedule['status'] = AppointmentStatus.upcoming;
          break;
        case 'complete':
          schedule['status'] = AppointmentStatus.complete;
          break;
        case 'cancelled':
          schedule['status'] = AppointmentStatus.cancelled;
          break;
      }
      return schedule['status'] == status;
    }).toList();

    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(left: 25, top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Appointment Schedule',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.smallSpacingBox,
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // filtered tabs arrangement
                    for (AppointmentStatus appStatus
                        in AppointmentStatus.values)
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (appStatus == AppointmentStatus.upcoming) {
                                    status = AppointmentStatus.upcoming;
                                    _alignment = Alignment.centerLeft;
                                  } else if (appStatus ==
                                      AppointmentStatus.complete) {
                                    status = AppointmentStatus.complete;
                                    _alignment = Alignment.center;
                                  } else if (appStatus ==
                                      AppointmentStatus.cancelled) {
                                    status = AppointmentStatus.cancelled;
                                    _alignment = Alignment.centerRight;
                                  }
                                });
                              },
                              child: Center(child: Text(appStatus.name))))
                  ],
                ),
              ),
              AnimatedAlign(
                alignment: _alignment,
                duration: Duration(milliseconds: 200),
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Config.primaryColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      status.name,
                      style: TextStyle(
                        color: Colors.yellowAccent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Config.smallSpacingBox,
          Expanded(
            child: ListView.builder(
                itemCount: filteredSchedule.length,
                itemBuilder: (context, index) {
                  var schedule = filteredSchedule[index];
                  bool isLastElem = filteredSchedule.length + 1 == index;
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    margin: !isLastElem
                        ? const EdgeInsets.only(bottom: 20)
                        : EdgeInsets.zero,
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "http://127.0.0.1:8000${schedule['doctor_profile']}"),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(schedule['doctor_name'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          //color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    SizedBox(height: 5),
                                    Text(schedule['specialties'],
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Config.smallSpacingBox,
                            // Schedule Card
                            ScheduleCard(
                              date: schedule['date'],
                              day: schedule['day'],
                              time: schedule['time'],
                            ),
                            Config.smallSpacingBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Cancellation not allowed"),
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
                                    child: Text('Cancel',
                                        style: TextStyle(
                                            color: Config.secondaryColor)),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Config.secondaryColor,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                Text("Reschedule not allowed"),
                                            content: Text(
                                                "Please contact hospital admin to reschedule the appointment."),
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
                                    child: Text('Reschedule',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  );
                }),
          ),
        ],
      ),
    ));
  }
}

// Schedule Widget
class ScheduleCard extends StatelessWidget {
  const ScheduleCard(
      {super.key, required this.date, required this.day, required this.time});
  final String time;
  final String date;
  final String day;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(
            Icons.calendar_month_sharp,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(width: 5),
          Text('$day, $date', style: TextStyle(color: Colors.white)),
          const SizedBox(width: 20),
          const Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          const SizedBox(width: 5),
          Flexible(child: Text(time, style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }
}

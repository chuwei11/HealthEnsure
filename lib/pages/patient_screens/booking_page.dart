import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthensure/components/button.dart';
import 'package:healthensure/components/custom_appbar.dart';
import 'package:healthensure/utils/config.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currDay = DateTime.now();
  int? _currIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Appointment',
        icon: FaIcon(Icons.arrow_back_ios),
      ),
      body: CustomScrollView(slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              // display table calendar here
              _tableCalendar(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 28, horizontal: 10),
                child: Center(
                    child: Text(
                  'Choose Your Booking Time',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'RobotoSlab',
                    fontWeight: FontWeight.w500,
                  ),
                )),
              )
            ],
          ),
        ),
        _isWeekend
            // if weekend is selected, shown unavailable
            ? SliverToBoxAdapter(
                child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                alignment: Alignment.center,
                child: Text(
                  'Consultation not available on weekend, please choose another date',
                  style: TextStyle(
                      letterSpacing: 2.0,
                      fontSize: 16,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500),
                ),
              ))
            // if weekday is selected, display available time
            : SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        splashColor: Colors.white,
                        onTap: () {
                          // once selected, update currIndex
                          setState(() {
                            _currIndex = index;
                            _timeSelected = true;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _currIndex == index
                                  ? Colors.transparent
                                  : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            color: _currIndex == index
                                ? Config.primaryColor
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: _currIndex == index ? Colors.white : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: 8,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 1.5),
              ),
        SliverToBoxAdapter(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
              // button is disabled when time and date not selected
              child: Button(
                width: 10,
                title: 'Book Now',
                onPressed: () {
                  Navigator.of(context).pushNamed('succBooked');
                },
                disabled: _timeSelected && _dateSelected ? false : true,
              )),
        )
      ]),
    );
  }

  // table calendar
  Widget _tableCalendar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text("Selected Day = " + _focusDay.toString().split(" ")[0],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          TableCalendar(
            locale: "en_US",
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              formatButtonPadding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            ),
            availableGestures: AvailableGestures.all,
            focusedDay: _focusDay,
            firstDay: DateTime.now(),
            lastDay: DateTime(2023, 12, 31),
            calendarFormat: _format,
            currentDay: _currDay,
            rowHeight: 45,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                  color: Config.primaryColor, shape: BoxShape.circle),
            ),
            availableCalendarFormats: {
              CalendarFormat.month: 'Month',
            },
            onFormatChanged: (format) {
              setState(() {
                _format = format;
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _currDay = selectedDay;
                _focusDay = focusedDay;
                _dateSelected = true;

                // if weekend is selected, time is not shown
                if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
                  _isWeekend = true;
                  _timeSelected = false;
                  _currIndex = null;
                } else {
                  _isWeekend = false;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

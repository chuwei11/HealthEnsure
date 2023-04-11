import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utils/config.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({Key? key, required this.route}) : super(key: key);

  final String route;

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
              child:
                  Image.asset('assets/profile/Doctor2.png', fit: BoxFit.fill),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Dr Lisa Madison',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Dental',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const <Widget>[
                        Icon(Icons.star_border, color: Colors.yellow, size: 16),
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
          Navigator.of(context).pushNamed(route);
        },
      ),
    );
  }
}

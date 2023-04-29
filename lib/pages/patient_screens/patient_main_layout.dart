import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthensure/pages/patient_screens/fav_doc_page.dart';
import 'package:healthensure/pages/patient_screens/insurance_claims.dart';
import 'package:healthensure/pages/patient_screens/patient_appointment_page.dart';
import 'package:healthensure/pages/patient_screens/patient_home_page.dart';
import 'package:healthensure/pages/patient_screens/profile_page.dart';
import 'package:healthensure/utils/config.dart';

class PatientMainLayout extends StatefulWidget {
  const PatientMainLayout({Key? key}) : super(key: key);

  @override
  State<PatientMainLayout> createState() => _PatientMainLayoutState();
}

class _PatientMainLayoutState extends State<PatientMainLayout> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  List<Widget> _pageOptions = [
    const PatientHomePage(),
    FavPage(),
    const PatientAppointmentPage(),
    InsuranceClaimsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index;
    });
    //_pageController.jumpToPage(index);
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pageOptions,
        onPageChanged: ((index) {
          setState(() {
            // update page index when tab pressed/switch page
            _currentPage = index;
          });
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.houseChimneyMedical),
            label: 'Home',
            backgroundColor: Config.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidHeart),
            label: 'Favourite',
            backgroundColor: Config.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidCalendarCheck),
            label: 'Appointments',
            backgroundColor: Config.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.fileContract),
            label: 'Insurance',
            backgroundColor: Config.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidUser),
            label: 'Profile',
            backgroundColor: Config.primaryColor,
          ),
        ],
      ),
    );
  }
}

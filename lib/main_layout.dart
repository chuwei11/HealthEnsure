// import 'package:flutter/material.dart';
// import 'package:healthensure/auth/home_page.dart';
// import 'package:healthensure/pages/appointment_page.dart';

// class MainLayout extends StatefulWidget {
//   const MainLayout({Key? key}) : super(key: key);

//   @override
//   State<MainLayout> createState() => _MainLayoutState();
// }

// class _MainLayoutState extends State<MainLayout> {
//   // variable declaration
//   int currentPage = 0;
//   final PageController _page = PageController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _page,
//         onPageChanged: ((value) {
//           setState(() {
//             // update page index when tab pressed/switch page
//             currentPage = value;
//           });
//         }),
//         children: const <Widget>[
//           HomePage(),
//           AppointmentPage(),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentPage,
//         onTap: (page) {
//           setState(() {
//             currentPage = page;
//             _page.animateToPage(
//               page,
//               duration: const Duration(milliseconds: 500),
//               curve: Curves.easeInOut,
//             );
//           });
//         },
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: 'Appointment',
//           ),
//         ],
//       ),
//     );
//   }
// }

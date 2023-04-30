import 'package:flutter/material.dart';
import "package:healthensure/components/doctor_card.dart";
import "package:provider/provider.dart";

import "../../models/auth_model.dart";

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 18, top: 22, right: 18),
        child: Column(
          children: [
            const Text(
              'My Favorite Doctors',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            Expanded(
              // usage of consumer(provider) for instantly update latest fav doc list
              child: Consumer<AuthModel>(
                builder: (context, auth, child) {
                  return ListView.builder(
                    // return the fav doc list length
                    itemCount: auth.getFavDoc.length,
                    itemBuilder: (context, index) {
                      return DoctorCard(
                          doctor: auth.getFavDoc[index], isFav: true
                          //doctor: auth.getFavDoc[index],
                          //show fav icon
                          //isFav: true, route: '',
                          );
                    },
                  );
                },
                //child:
              ),
            ),
          ],
        ),
      ),
    );
  }
}

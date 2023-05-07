import 'package:flutter/material.dart';
import 'package:healthensure/models/health_data_model.dart';
import 'package:healthensure/utils/health_data_preferences.dart';
import 'package:healthensure/widget/appbar_widget.dart';
import 'package:healthensure/widget/button_widget.dart';
import 'package:healthensure/widget/textfield_widget.dart';

class EditHealthDataPage extends StatefulWidget {
  @override
  _EditHealthDataPageState createState() => _EditHealthDataPageState();
}

class _EditHealthDataPageState extends State<EditHealthDataPage> {
  late HealthData healthData;

  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _bloodTypeController = TextEditingController();
  TextEditingController _bmiController = TextEditingController();
  TextEditingController _vaccinationStatusController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateControllers();

    // healthData = HealthData(
    //   height: 165.0,
    //   weight: 65.0,
    //   bloodType: 'A+',
    //   bmi: 24.0,
    //   vaccinationStatus: 'Fully Vaccinated',
    //   date: DateTime.now(),
    //   isDarkMode: false,
    // );
  }

  void _updateControllers() {
    healthData = HealthDataPreferences.getHealthData();

    _heightController.text = healthData.height.toString();
    _weightController.text = healthData.weight.toString();
    _bloodTypeController.text = healthData.bloodType;
    _bmiController.text = healthData.bmi.toString();
    _vaccinationStatusController.text = healthData.vaccinationStatus;
    _dateController.text = healthData.date.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 24),
          TextFieldWidget(
              label: 'Height',
              text: healthData.height.toString(),
              controller:
                  TextEditingController(text: healthData.height.toString()),
              onChanged: (height) {
                try {
                  healthData =
                      healthData.copyWith(height: double.parse(height));
                  HealthDataPreferences.setHealthData(healthData);
                } catch (e) {
                  print('error saving height');
                }
              }),
          const SizedBox(height: 24),
          TextFieldWidget(
              label: 'Weight',
              text: healthData.weight.toString(),
              controller:
                  TextEditingController(text: healthData.weight.toString()),
              onChanged: (weight) {
                try {
                  healthData =
                      healthData.copyWith(weight: double.parse(weight));
                  HealthDataPreferences.setHealthData(healthData);
                } catch (e) {
                  print('error saving weight');
                }
              }),
          const SizedBox(height: 24),
          TextFieldWidget(
              label: 'Blood Type',
              text: healthData.bloodType,
              controller:
                  TextEditingController(text: healthData.bloodType.toString()),
              onChanged: (bloodType) {
                try {
                  healthData = healthData.copyWith(bloodType: bloodType);
                  HealthDataPreferences.setHealthData(healthData);
                } catch (e) {
                  print('error saving blood type');
                }
              }),
          const SizedBox(height: 24),
          TextFieldWidget(
              label: 'BMI',
              text: healthData.bmi.toString(),
              controller:
                  TextEditingController(text: healthData.bmi.toString()),
              onChanged: (bmi) {
                try {
                  healthData = healthData.copyWith(bmi: double.parse(bmi));
                  HealthDataPreferences.setHealthData(healthData);
                } catch (e) {
                  print('error saving bmi');
                }
              }),
          const SizedBox(height: 24),
          TextFieldWidget(
              label: 'Vaccination Status',
              text: healthData.vaccinationStatus,
              controller: TextEditingController(
                  text: healthData.vaccinationStatus.toString()),
              onChanged: (vacStatus) {
                try {
                  healthData =
                      healthData.copyWith(vaccinationStatus: (vacStatus));
                  HealthDataPreferences.setHealthData(healthData);
                } catch (e) {
                  print('error saving vaccination status');
                }
              }),
          const SizedBox(height: 24),
          TextField(
            enabled: false,
            decoration: InputDecoration(
              labelText: 'Date',
            ),
            controller: TextEditingController(text: healthData.date.toString()),
          ),
          const SizedBox(height: 30),
          ButtonWidget(
            text: 'Save',
            onClicked: () {
              HealthDataPreferences.setHealthData(healthData);
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Success'),
                    content: Text('Your health data has been updated.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// to connect to database
// to post/get data from laravel database
// using Laravel Sanctum requires API token to get data, hence JWT authorization is used

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider {
//   // to get token
//   Future<dynamic> getToken(String email, String password) async {
//     try {
//       // url "http://127.0.0.1:8000/api/login" is local database
//       // api/login is the end point that will be set later in laravel
//       var response = await Dio().post('http://127.0.0.1:8000/api/login',
//           data: {'email': email, 'password': password});

// // if request set successfully, the return token
//       if (response.statusCode == 200 && response.data != '') {
//         return response.data;
//       }
//     } catch (error) {
//       return error;
//     }
//   }

  Future<dynamic> getToken(String email, String password) async {
    try {
      // url "http://127.0.0.1:8000/api/login" is local database

      var response = await Dio().post('http://127.0.0.1:8000/api/login',
          data: {'email': email, 'password': password});

// if request set successfully, the return token
      if (response.statusCode == 200 && response.data != '') {
        // store returned token into shared preferences to get other data later
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data);
        return true;
      } else {
        return false;
      }
    }
    // catch (error) {
    //   return error;
    // }
    catch (error) {
      if (error is DioError) {
        // handle DioError specifically
        if (error.response != null) {
          print('Error fetching token: ${error.response!.statusCode}');
        } else {
          print('Connection failed due to internet connection');
        }
      } else {
        // handle other types of errors
        print('Error fetching token: $error');
      }
      return null; // indicate an error occurred
    }
  }

  // Future<bool> getToken(String email, String password) async {
  //   try {
  //     var response = await Dio().post('http://127.0.0.1:8000/api/login',
  //         data: {'email': email, 'password': password});

  //     if (response.statusCode == 200 && response.data != '') {
  //       final SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('token', response.data);
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (error) {
  //     // If an error occurs, throw it as an exception
  //     throw Exception('Error fetching token: $error');
  //   }
  // }

  // to get user data
  Future<dynamic> getUser(String token) async {
    try {
      var user = await Dio().get('http://127.0.0.1:8000/api/user',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      // if request set successfully, the return user data
      if (user.statusCode == 200 && user.data != '') {
        return json.encode(user.data);
      }
    } catch (error) {
      return error;
    }
  }

  // to register user in laravel app & store in local database
  Future<dynamic> registerUser(
      String username, String email, String password) async {
    try {
      var user = await Dio().post('http://127.0.0.1:8000/api/register',
          data: {'name': username, 'email': email, 'password': password});
      if (user.statusCode == 201 && user.data != '') {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return error;
    }
  }

  //store booking details
  Future<dynamic> bookAppointment(
      String date, String day, String time, int doctor, String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/book',
          data: {'date': date, 'day': day, 'time': time, 'doctor_id': doctor},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //retrieve booking details
  Future<dynamic> getAppointments(String token) async {
    try {
      var response = await Dio().get('http://127.0.0.1:8000/api/appointments',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

// return error if the response is empty
      if (response.statusCode == 200 && response.data != '') {
        return json.encode(response.data);
      } else {
        return 'Unable to get Response!';
      }
    } catch (error) {
      return error;
    }
  }

  //store rating details
  Future<dynamic> storeReviews(
      String reviews, double ratings, int id, int doctor, String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/reviews',
          data: {
            'ratings': ratings,
            'reviews': reviews,
            'appointment_id': id,
            'doctor_id': doctor
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

//cancel appointment
  Future<dynamic> cancelAppointment(int id, String token) async {
    try {
      var response = await Dio().post(
        'http://127.0.0.1:8000/api/cancel',
        data: {'appointment_id': id},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  // store favourite doctor
  // update the fav list into local database
  Future<dynamic> storeFavDoc(String token, List<dynamic> favList) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/fav',
          data: {
            'favList': favList,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

//logout
  Future<dynamic> logout(String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }
}

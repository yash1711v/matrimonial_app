import 'dart:async';
import 'dart:developer';
import 'package:bureau_couple/getx/repository/api/api_client.dart';
import 'package:bureau_couple/getx/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';

import '../../../src/apis/login/login_api.dart';
import '../../../src/constants/shared_prefs.dart';
import '../../controllers/auth_controller.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});

  // Future<String> login({required String number}) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   String varificationId = "";
  //   await auth.verifyPhoneNumber(
  //       phoneNumber: "+91${number}",
  //       verificationCompleted: (PhoneAuthCredential cred) {},
  //       verificationFailed: (e) {
  //         log(e.toString(), name: "error at login screen");
  //       },
  //       codeSent: (vrificationId, code) {
  //         debugPrint("code  sent");
  //         varificationId = vrificationId;
  //         Get.find<AuthController>().setVarificationId(varificationId);
  //         // _repo.login(number: (state.number ?? "").trim()).then((value) {
  //         //   if (value['status']) {
  //         //     _vrificationId = vrificationId;
  //         //     context.read<OtpCubit>().setPhoneNumber(state.number ?? "", _vrificationId);
  //         //     Navigator.pushReplacementNamed(context, OtpScreen.id);
  //         //   } else {
  //         //     emit(LoginState(error: "Something went wrong", number: state.number));
  //         //   }
  //         // });
  //       },
  //       codeAutoRetrievalTimeout: (val) {});
  //   debugPrint("varificationId $varificationId");
  //   return varificationId;
  // }
  //
  // Future<bool> verifyOTP(
  //     {BuildContext? context,
  //     required String otp,
  //     required String varificationId,
  //     required String number})
  // async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   if (otp.toString().trim().length == 6) {
  //     if (varificationId.isNotEmpty) {
  //       // Create credential using verification ID and OTP
  //       final credential = PhoneAuthProvider.credential(
  //         verificationId: varificationId!,
  //         smsCode: otp,
  //       );
  //
  //       try {
  //         // Sign in using the credential
  //         await auth.signInWithCredential(credential).then((value) {
  //           if (value.user!.uid.isNotEmpty) {
  //             ScaffoldMessenger.of(context!).showSnackBar(
  //               const SnackBar(
  //                 content: Text('Verify Successfully'),
  //               ),
  //             );
  //             loginApi(mobileNumber: number);
  //             Get.find<AuthController>().setVarificationDone(true);
  //             return true;
  //           } else {
  //             Get.find<AuthController>().setVarificationDone(false);
  //             false;
  //           }
  //         });
  //       } catch (e) {
  //         Navigator.pop(context!);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Failed to verify OTP: $e'),
  //           ),
  //         );
  //         print('Failed to verify OTP: $e');
  //         return false;
  //       }
  //     } else {
  //       print('Verification ID is null');
  //       ScaffoldMessenger.of(context!).showSnackBar(
  //         const SnackBar(
  //           content: Text('Failed to verify OTP: '),
  //         ),
  //       );
  //       return false;
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context!).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please enter Valid otp'),
  //       ),
  //     );
  //     return false;
  //   }
  //
  //   return false;
  // }

  Future<void> checkUser() async {

  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  Future<bool> saveUserToken(
    String token,
    /*String zoneTopic*/
  ) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    // sharedPreferences.setString(AppConstants.zoneTopic, zoneTopic);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  Future<bool> saveEmail(
    String email,
    /*String zoneTopic*/
  ) async {
    apiClient.email = email;
    // sharedPreferences.setString(AppConstants.zoneTopic, zoneTopic);
    return await sharedPreferences.setString(AppConstants.username, email);
  }

  Future<bool> saveImage(
    String image,
    /*String zoneTopic*/
  ) async {
    apiClient.image = image;
    // sharedPreferences.setString(AppConstants.zoneTopic, zoneTopic);
    return await sharedPreferences.setString(AppConstants.image, image);
  }

  // Future<bool> saveFirstName(String firstName, /*String zoneTopic*/) async {
  //   apiClient.firstName = firstName;
  //   // sharedPreferences.setString(AppConstants.zoneTopic, zoneTopic);
  //   return await sharedPreferences.setString(AppConstants.firstName, firstName);
  // }

  String getFirstName() {
    return sharedPreferences.getString(AppConstants.firstName) ?? "";
  }

  Future<bool> saveLastName(
    String lastName,
    /*String zoneTopic*/
  ) async {
    apiClient.lastName = lastName;
    // sharedPreferences.setString(AppConstants.zoneTopic, zoneTopic);
    return await sharedPreferences.setString(AppConstants.lastName, lastName);
  }

  // String getLastName() {
  //   return sharedPreferences.getString(AppConstants.lastName) ?? "";
  // }
  /* Future<bool> saveImage(String image, */ /*String zoneTopic*/ /*) async {
    apiClient.image = image;
    // sharedPreferences.setString(AppConstants.zoneTopic, zoneTopic);
    return await sharedPreferences.setString(AppConstants.image, image);
  }
*/
  String getUserImage() {
    return sharedPreferences.getString(AppConstants.image) ?? "";
  }

  String getUserEmail() {
    return sharedPreferences.getString(AppConstants.username) ?? "";
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  Future<void> saveUserNumberAndPassword(
      String username, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.password, password);
      await sharedPreferences.setString(AppConstants.username, username);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveFirstNameAndLastName(
      String firstName, String lastName) async {
    try {
      await sharedPreferences.setString(AppConstants.firstName, firstName);
      await sharedPreferences.setString(AppConstants.lastName, lastName);
    } catch (e) {
      rethrow;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.username) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.password) ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.username);
    return await sharedPreferences.remove(AppConstants.password);
  }

  Future<Response> getAttributesUrl() {
    return apiClient.getData(AppConstants.attributesUrl);
  }
  Future<Response> getDegree() {
    return apiClient.getDataApi(AppConstants.degree);
  }
  Future<Response> getInterests() {
    return apiClient.getDataApi(AppConstants.interests);
  }
  Future<dynamic> saveInterests(dynamic data) async {
   var headers = {
   'Content-Type': 'application/json; charset=UTF-8',
   'Accept' : 'application/json',
     'Authorization': 'Bearer ${await SharedPrefs().getLoginToken()}'
    };
   debugPrint("request====>: $data");
    var response =  await apiClient.postData(AppConstants.saveInterests, data,headers: headers);
  return response;
  }

  Future<Response> getCommunityUrl(id) {
    return apiClient
        .getData('${AppConstants.communityListUrl}?religion_id=$id');
  }

  ///
}

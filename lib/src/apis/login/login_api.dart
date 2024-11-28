import 'dart:convert';

import 'package:bureau_couple/src/constants/shared_prefs.dart';
import 'package:bureau_couple/src/utils/urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../getx/controllers/auth_controller.dart';
import '../../../getx/repository/repo/auth_repo.dart';
import '../../models/LoginResponse.dart';
import 'package:get/get.dart';

Future<dynamic> loginApi({
  required String mobileNumber,
}) async {
  try{
   http.post(Uri.parse('${baseUrl}check-mobile'),body: {
      'mobile': mobileNumber,
    }).then((response) async {
      var resp = jsonDecode(response.body);

      if(resp["message"] == "Mobile number does not exist."){
        // Get.find<AuthController>().setVarificationDone(false);
      } else {
        // Get.find<AuthController>().setVarificationDone(true);
        // Get.find<AuthController>().saveUserToken(resp['token']);
        await SharedPrefs().setLoginToken(resp["token"]);
      }

   });
  } catch(e){
    print(e);
  }



  }
  //   return resp;
  // } else {
  //   print(resp);
  //   print(response.reasonPhrase);
  //   print(response.statusCode);
  //   return resp;
  // }



Future<dynamic> logOutApi() async {
   var headers = {
   'Authorization': 'Bearer ${SharedPrefs().getLoginToken()}'
  };
  var request = http.MultipartRequest(
      'POST',
      Uri.parse('${baseUrl}logout'));
   request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  var resp = jsonDecode(await response.stream.bytesToString());
  print(resp);
  if (response.statusCode == 200) {
    return resp;
  } else {
    print(resp);
    print(response.reasonPhrase);
    print(response.statusCode);
    return resp;
  }
}


//
// Future login({
//   required BuildContext context,
//   required String email,
//   required String password,
//   // required String phone,
// }) async {
//   var headers = {
//     'Content-Type': 'application/x-www-form-urlencoded'
//   };
//   var request = http.Request('POST', Uri.parse('$baseUrl/api/login'));
//   request.bodyFields = {
//     if(email.contains("@")) 'email': email,
//     if(!email.contains('@')) 'phone': email,
//     'password': password,
//
//   };
//   print(request.bodyFields);
//   request.headers.addAll(headers);
//   http.StreamedResponse response = await request.send();
//   var resp = jsonDecode(await response.stream.bytesToString());
//   if(response.statusCode == 200) {
//     if(resp['status'] == true){
//       return LoginResponse.fromJson(resp);
//     } else {
//       Globals().showErrorMessage(context, 'Please enter correct details.');
//       return LoginResponse(
//         code: 1,
//         status: false,
//         message: 'message',
//         data: UserLogin(
//             id: 1,
//             name: 'name',
//             username: 'username',
//             email: 'email',
//             phone: 'phone',
//             photo: 'photo'),
//         token: 'token',);
//     }
//   } else {
//     print(resp);
//     print(response.statusCode);
//     print(response.reasonPhrase);
//     return false;
//   }
// }
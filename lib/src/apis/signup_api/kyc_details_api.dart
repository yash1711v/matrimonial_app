import 'dart:convert';
import 'package:bureau_couple/src/constants/shared_prefs.dart';
import 'package:bureau_couple/src/utils/urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

Future<dynamic> kycDetailsApi({
  required String designation,
  required String identityProof,
  // required String joiningDate,
  required String photo,

}) async {
/*  var prefs = await SharedPreferences.getInstance();
  var v = prefs.getString(Keys().token);*/
  var headers = {
    'Authorization': 'Bearer ${SharedPrefs().getLoginToken()}'
  };

  var request = http.MultipartRequest(
      'POST',
      Uri.parse('${baseUrl}kyc/store'));
  request.fields.addAll({
    'identity_no': designation,
    'id_type': identityProof == "Aadhar Card" ? "0" :identityProof == "Pan Card"? "1":identityProof == "Driving License"?"2":identityProof == "Passport"?"3":"4",
    // 'joining_date': joiningDate
  });

  request.fields['identity_no'] = designation;
  request.fields['id_type'] =  identityProof == "Aadhar Card" ? "0" :identityProof == "Pan Card"? "1":identityProof == "Driving License"?"2":identityProof == "Passport"?"3":"4";


  if (photo != null && photo.isNotEmpty) {
    var mimeType =
    lookupMimeType(photo); // Detect MIME type (e.g., image/jpeg)
    var file = await http.MultipartFile.fromPath(
      'identity_proof', // Field name expected by the backend
      photo, // File path
      contentType: MediaType.parse(mimeType!), // Set MIME type explicitly
    );
    request.files.add(file);
  }

  debugPrint(request.fields.toString());
  request.headers.addAll(headers);
  print(request.fields);
  print(headers);
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

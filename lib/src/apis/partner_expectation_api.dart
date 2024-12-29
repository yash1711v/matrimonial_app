import 'dart:convert';
import 'package:bureau_couple/src/constants/shared_prefs.dart';
import 'package:bureau_couple/src/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<dynamic> partnerExpectationUpdateApi({
  required String generalRequirement,
  required String country,
  required String minAge,
  required String maxAge,
  required String minHeight,
  required String maxHeight,
  required String maxWeight,
  required List<int?>? religion,
  required List<int?>  community,
  required String smokingStatus,
  required String drinkingStatus,
  required List<int?>  profession,
  required String minDegree,
  required String financialCondition,
  required String language,
  required List<int?> motherTongue, required String foodPreference,


}) async {
  var headers = {
    'Authorization': 'Bearer ${SharedPrefs().getLoginToken()}'
  };

  var request = http.MultipartRequest(
      'POST',
      Uri.parse('${baseUrl}profile-update'));
  request.fields.addAll({
    'method': 'partnerExpectation',
    "general_requirement" : generalRequirement,
    'mother_tongue' : jsonEncode(motherTongue),
    'country': country,
    'min_age': minAge,
    'max_age': maxAge,
    'min_height': minHeight,
    "max_height" : maxHeight,
    'max_weight': maxWeight,
    'religion': jsonEncode(religion),
    'community': jsonEncode(community),
    'smoking_status': smokingStatus,
   'drinking_status': drinkingStatus,
   "profession": jsonEncode(profession),
   "min_degree":minDegree,
    "food_preference": foodPreference
   // "financial_condition":financialCondition,
    // "language[]": language


  });
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

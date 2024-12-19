import 'dart:convert';

import 'package:bureau_couple/src/utils/urls.dart';
import 'package:http/http.dart' as http;

import '../../constants/shared_prefs.dart';

Future getProfileApi() async {
  var headers = {
    'Authorization': 'Bearer ${SharedPrefs().getLoginToken()}'
  };
  var request = http.Request('POST', Uri.parse('${baseUrl}profileData'));
  request.headers.addAll(headers);
  print(headers);
  http.StreamedResponse response = await request.send();
  var resp = jsonDecode(await response.stream.bytesToString());
  if(response.statusCode == 200 ) {
    print(resp);
    return resp;
  } else {
    print(resp);
    print(response.statusCode);
    print(response.reasonPhrase);
    return resp;
  }
}

bool isValidUrl(String url) {
  try {
    final uri = Uri.parse(url);
    return uri.hasScheme && uri.hasAuthority; // Ensures it has a valid scheme and authority
  } catch (e) {
    return false;
  }
}

Future<dynamic> addProfileImageAPi({
  required String photo,
}) async {
  // Define headers
  var headers = {
    'Authorization': 'Bearer ${SharedPrefs().getLoginToken()}'
  };

  // Create the request
  var request = http.MultipartRequest(
      'POST', Uri.parse('${baseUrl}profile/picture/update'));

  // Check if the photo is a URL
  if (isValidUrl(photo)) {
    // If photo is a URL, add it as a field
    request.fields['image_url'] = photo;
  } else {
    // If photo is a file path, add it as a file
    request.files.add(await http.MultipartFile.fromPath('image', photo));
  }

  // Add headers to the request
  request.headers.addAll(headers);

  // Debugging prints
  print(request.fields);
  print(headers);

  // Send the request and handle the response
  http.StreamedResponse response = await request.send();
  var resp = jsonDecode(await response.stream.bytesToString());
  print(resp);

  // Return the response
  if (response.statusCode == 200) {
    return resp;
  } else {
    print(resp);
    print(response.reasonPhrase);
    print(response.statusCode);
    return resp;
  }
}


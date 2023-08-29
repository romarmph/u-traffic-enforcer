import 'dart:convert';

import 'package:http/http.dart' as http;
import '../config/utils/exports.dart';

class ScanApiServices {
  ScanApiServices._();

  static ScanApiServices get instance => ScanApiServices._();

  final _apiKey = "07ba51e882a9549227fb11534e0d04c0";

  Future<LicenseDetail?> sendRequest(String docPath) async {
    var url = Uri.parse(
        'https://api.mindee.net/v1/products/mcromar00/ph-driver-license/v1/predict');

    var request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'Authorization': 'Token $_apiKey',
      })
      ..files.add(http.MultipartFile.fromString(
        'document',
        docPath,
      ));

    var response = await request.send();

    if (response.statusCode == 201) {
      final stringResponse = await response.stream.bytesToString();
      final parsedJson = json.decode(stringResponse);
      return LicenseDetail.fromJson(parsedJson);
    } else {
      return null;
    }
  }
}

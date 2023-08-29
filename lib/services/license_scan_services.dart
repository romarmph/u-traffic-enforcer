import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:u_traffic_enforcer/config/extensions/string_date_formatter.dart';
import '../config/utils/exports.dart';
import 'json_data.dart';

class ScanApiServices {
  ScanApiServices._();

  static ScanApiServices get instance => ScanApiServices._();

  final _apiKey = "07ba51e882a9549227fb11534e0d04c0";

  Future<LicenseDetail?> sendRequest(String docPath) async {
    // var url = Uri.parse(
    //     'https://api.mindee.net/v1/products/mcromar00/ph-driver-license/v1/predict');

    // var request = http.MultipartRequest('POST', url)
    //   ..headers.addAll({
    //     'Authorization': 'Token $_apiKey',
    //   })
    //   ..files.add(http.MultipartFile.fromString(
    //     'document',
    //     docPath,
    //   ));

    // var response = await request.send();

    // if (response.statusCode == 201) {
    if (true) {
      // final stringResponse = await response.stream.bytesToString();
      // final Map<String, dynamic> raw = json.decode(stringResponse);
      final Map<String, dynamic> raw = data;
      final Map<String, dynamic> prediction =
          raw['document']['inference']['pages'][0]['prediction'];

      final Map<String, dynamic> document = {};

      prediction.forEach((key, value) {
        Iterable<Map<String, dynamic>> list = value['values'];
        document[key] = list.map((e) => e['content'].toString()).join();
      });

      document.forEach((key, value) {
        print("$key : $value");
      });

      String date = document['birthdate'];
      document['birthdate'] =
          date.replaceAll('/', '-').tryParseToDateTime ?? "";
      date = document['expirationdate'];
      document['expirationdate '] =
          date.replaceAll('/', '-').tryParseToDateTime ?? "";

      return LicenseDetail.fromJson(document);
    } //else {
    //   return null;
    // }
  }
}

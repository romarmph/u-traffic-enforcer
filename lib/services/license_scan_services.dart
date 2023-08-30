import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:u_traffic_enforcer/config/extensions/string_date_formatter.dart';
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
      final Map<String, dynamic> raw = json.decode(stringResponse);
      final Map<String, dynamic> prediction =
          raw['document']['inference']['pages'][0]['prediction'];

      final Map<String, dynamic> document = {};

      prediction.forEach((key, value) {
        List<dynamic> list = value['values'];
        document[key] = list.map((e) => e['content'].toString()).join();
      });

      document.forEach((key, value) {
        String temp = document[key];

        switch (key) {
          case 'birthdate':
            document[key] = temp.replaceAll('/', '-').tryParseToDateTime ?? "";
            break;
          case 'expirationdate':
            document[key] = temp.replaceAll('/', '-').tryParseToDateTime ?? "";
            break;
          case 'height':
            document[key] = double.tryParse(temp) ?? "";
            break;
          case 'weight':
            document[key] = double.tryParse(temp) ?? "";
            break;
          default:
            break;
        }
      });

      return LicenseDetail.fromJson(document);
    } else {
      return null;
    }
  }
}

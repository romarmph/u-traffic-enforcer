import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:u_traffic_enforcer/config/extensions/string_date_formatter.dart';

class LicenseScanServices {
  LicenseScanServices._();

  static LicenseScanServices get instance => LicenseScanServices._();

  final _apiKey = "07ba51e882a9549227fb11534e0d04c0";

  Future<Map<String, dynamic>?> sendRequest(String docPath) async {
    File imageFile = File(docPath);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    var url = Uri.parse(
        'https://api.mindee.net/v1/products/mcromar00/ph_drivers_license_parser/v1/predict');

    var request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'Authorization': 'Token $_apiKey',
      })
      ..files.add(http.MultipartFile.fromString(
        'document',
        base64Image,
      ));

    try {
      var response = await request.send();

      if (response.statusCode == 201) {
        final stringResponse = await response.stream.bytesToString();
        final Map<String, dynamic> raw = json.decode(stringResponse);
        final Map<String, dynamic> prediction =
            raw['document']['inference']['pages'][0]['prediction'];

        final Map<String, dynamic> document = {};

        prediction.forEach((key, value) {
          List<dynamic> list = value['values'];
          document[key] = list.map((e) => e['content'].toString()).join(' ');
        });

        document.forEach((key, value) {
          String temp = document[key];

          switch (key) {
            case 'birthdate':
              document[key] =
                  temp.replaceAll('/', '-').tryParseToDateTime ?? "";
              break;
            case 'expirationdate':
              document[key] =
                  temp.replaceAll('/', '-').tryParseToDateTime ?? "";
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

        return document;
      } else {
        throw Exception('failed-to-send-request');
      }
    } catch (e) {
      throw Exception('error-occured-while-sending-request');
    }
  }
}

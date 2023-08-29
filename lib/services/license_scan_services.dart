import 'package:http/http.dart' as http;

class ScanApiServices {
  ScanApiServices._();

  static ScanApiServices get instance => ScanApiServices._();

  final _apiKey = "07ba51e882a9549227fb11534e0d04c0";
  final _testDoc =
      'https://media.discordapp.net/attachments/1138674544530440226/1138674683261231164/license.jpeg?width=942&height=588';

  Future<void> sendRequest(String docPath) async {
    var url = Uri.parse(
        'https://api.mindee.net/v1/products/mcromar00/ph-driver-license/v1/predict');

    var request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'Authorization': 'Token $_apiKey',
      })
      ..files.add(await http.MultipartFile.fromPath(
        'document',
        _testDoc,
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}

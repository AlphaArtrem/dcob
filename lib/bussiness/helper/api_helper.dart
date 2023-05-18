import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';


class ApiHelper{
  ApiHelper._();

  static final Logger _logger = Logger();

  static Future<Map<String, dynamic>> uploadFile(
      String url, {
        String? bearerToken,
        Map<String, String> fields = const {},
        required String filePath,
        required String fileField,
      }) async {
    try {
      http.MultipartRequest request =
      http.MultipartRequest("POST", Uri.parse(url));

      if (bearerToken != null) {
        request.headers['Authorization'] = 'Basic $bearerToken';
      }

      if (fields.isNotEmpty) {
        request.fields.addAll(fields);
      }

      _logger.d("Sending request with file : $filePath");

      http.MultipartFile file =
      await http.MultipartFile.fromPath(fileField, filePath);
      request.files.add(file);

      http.StreamedResponse response = await request.send();

      _logger
          .d("request sent and got response with code :${response.statusCode}");

      if (response.statusCode == 200) {
        _logger.d("getting response data");

        Uint8List responseData = await response.stream.toBytes();
        String responseString = String.fromCharCodes(responseData);
        _logger.d(jsonDecode(responseString));

        return jsonDecode(responseString);
      } else {
        throw response.reasonPhrase ?? "Unable upload file";
      }
    } catch (e) {
      _logger.d(e);
      rethrow;
    }
  }
}
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../data/app_exceptions.dart';
import 'base_api_services.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(
    String url, {
    bool? isAuth,
    String? token,
  }) async {
    print(url);
    dynamic responseJson;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": isAuth ?? false ? "Bearer $token" : "",
        },
      ).timeout(
        const Duration(seconds: 20),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(
        'Please ensure your device is connected to the internet and try again',
      );
    } on TimeoutException {
      throw RequestTimedOutException('Server took too long to respond');
    }

    return responseJson;
  }

  @override
  Future<Map<String, dynamic>> postApi(
    String url,
    dynamic data, {
    bool? isAuth,
    bool? sendAsFormData,
    String? fieldName,
    String? token,
    List<Map<String, File?>>? files,
  }) async {
    print(url);
    // print(token);
    // print(data);
    // print(files);
    Map<String, dynamic> responseJson;
    try {
      if ((sendAsFormData ?? false) || (files != null && files.isNotEmpty)) {
        var request = http.MultipartRequest('POST', Uri.parse(url));

        data.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        if (files != null && files.isNotEmpty) {
          for (var fileMap in files) {
            if (fileMap.values.first != null) {
              var stream = http.ByteStream(fileMap.values.first!.openRead());
              var length = await fileMap.values.first!.length();
              var multipartFile = http.MultipartFile(
                fileMap.keys.first,
                stream,
                length,
                filename: fileMap.values.first!.path.split('/').last,
              );
              request.files.add(multipartFile);
            }
          }
        }

        // Add headers, including authorization if needed
        request.headers.addAll({
          "Accept": "application/json",
          if (isAuth ?? false) "Authorization": "Bearer $token",
        });

        var streamedResponse = await request.send().timeout(
              const Duration(seconds: 30),
            );

        final response = await http.Response.fromStream(streamedResponse);
        responseJson = returnResponse(response);
      } else {
        final response = await http.post(
          Uri.parse(url),
          body: jsonEncode(data),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": isAuth ?? false ? "Bearer $token" : "",
          },
        ).timeout(
          const Duration(seconds: 30),
        );
        responseJson = returnResponse(response);
      }
    } on SocketException {
      throw InternetException(
          'Please ensure your device is connected to the internet and try again');
    } on TimeoutException {
      throw RequestTimedOutException('Server took too long to respond');
    } catch (e) {
      print(e);
      rethrow;
    }

    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    print("RESPONSE >>> " + "${response.statusCode} - ${response.body}");
    final res = jsonDecode(response.body);
    // print("res >>>" + res.toString());
    switch (response.statusCode) {
      case 200:
      case 201:
        return res;
      case 400:
      case 422:
        throw BadRequestException(res['message']);
      case 403:
      case 401:
        throw UnauthorizedException(res['message']);
      case 404:
        throw NotFoundException(res['message']);
      case 500:
        throw ServerException(res['message']);
      default:
        throw GeneralException('${response.statusCode}');
    }
  }

  @override
  Future<dynamic> deleteApi(String url, {bool? isAuth, String? token}) async {
    dynamic responseJson;
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": isAuth ?? false ? "Bearer $token" : "",
        },
      ).timeout(
        const Duration(seconds: 20),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(
        'Please ensure your device is connected to the internet and try again',
      );
    } on TimeoutException {
      throw RequestTimedOutException('Server took too long to respond');
    }

    return responseJson;
  }
}

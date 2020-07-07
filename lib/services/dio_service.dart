import 'dart:convert';

import 'package:dio/dio.dart';

class DioService {
  Dio _client;

  Dio _createHttpClient(){
    var dio = Dio();

    return dio;
  }

  Future<Response> getRequest(String url) async {
    _client = _createHttpClient();
    Response response = await _client.get(url);
    if(response.statusCode == 200){
      return response;
    }else{
      throw Exception("Some error here.");
    }
  }

  Future<Response> postRequest(String url, Map<String, dynamic> body) async {
    _client = _createHttpClient();
    print(jsonEncode(body));
    Response response = await _client.post(url, data: body);
    if(response.statusCode == 200){
      return response;
    }else{
      throw Exception("POST failed.");
    }
  }
}
import 'package:dio/dio.dart';
import 'package:spencerstolworthy_goals/src/config/config.dart';
import 'package:spencerstolworthy_goals/src/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(Constants.tokenStorageKey);
}

Dio _d() {
  Dio _dio = new Dio();
  _dio.options.baseUrl = Config.baseUrl;
  _dio.interceptors
      .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
    String token = await getToken();
    options.headers['Authorization'] = 'bearer $token';
    return options;
  }));
  return _dio;
}

Dio appHttpHandler = _d();

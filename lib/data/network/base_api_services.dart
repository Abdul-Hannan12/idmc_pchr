abstract class BaseApiServices {
  Future<dynamic> getApi(String url);
  Future<dynamic> postApi(String url, Map<String, dynamic> data);
  Future<dynamic> deleteApi(String url, {bool? isAuth, String? token});
}

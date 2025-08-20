part of '_index.dart';

// import 'package:flutter_dotenv/flutter_dotenv.dart';

const tokenKey = "user_token";
final baseUrl = dotenv.env['BASE_URL']!;
// final baseUrl = "https://skill-sage-backend-njh6.onrender.com";
// final baseUrl = "http://10.0.2.2:8004";

final httpProvider = Provider((ref) => HttpProvider(ref));

class HttpProvider {
  late Dio http;
  Ref ref;

  HttpProvider(this.ref) : http = Dio(BaseOptions(baseUrl: baseUrl)) {
    init();
  }

  Future<void> init([SharedPreferences? p]) async {
    final pref = p ?? await SharedPreferences.getInstance();
    final token = pref.getString(tokenKey);

    if (token != null) {
      http.options.headers["Authorization"] = "Bearer $token";
    }
  }

  Future<bool> checkToken() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString(tokenKey);
      print("token == $token");
      if (token != null) {
        await init(pref);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future removeToken() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(tokenKey);
  }

  Future setToken(String token) async {
    print("setting token == $token");
    final pref = await SharedPreferences.getInstance();
    var b = await pref.setString(tokenKey, token);
    print("setting token $b");
    http.options.headers["Authorization"] = "Bearer $token";
  }
}

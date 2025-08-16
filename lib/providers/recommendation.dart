part of '_index.dart';

final recommenderProvider =
    ChangeNotifierProvider((ref) => RecommenderProvider(ref));

class RecommenderProvider extends ChangeNotifier {
  Ref ref;

  List<String> userSkills = [];
  List<String> missingSkills = [];
  bool isLoading = false;
  String? error;

  Dio get http => ref.read(httpProvider).http;
  RecommenderProvider(this.ref) {
    init();
  }

  void init() {
    http.interceptors.add(InterceptorsWrapper(
      onResponse: (res, handler) async {
        if (res.statusCode == 401) {
          print("Unauthorized");
          // await logout();
        }

        return handler.next(res);
      },
    ));
  }

  Future loadRecommendations() async {
    final resp = await cather(() => http.get('/user/recommend_skills'));
    if (!resp.success) throw Exception("failed");

    // Parse the response to get skills array
    final data = resp;
    notifyListeners();
    return data; // Return the parsed data with skills array
  }
}

//   Future loadRecommendations() async {
//     // try {
//     final resp = await cather(() => http.get('/user/recommend_skills'));
//     // print('res: ${resp.result}');
//     if (!resp.success) return throw Exception("failed");
//     // final Resp<List<Skills?>> data = resp.parseList(Skills.fromJson);
//     // skills = data.result;
//     notifyListeners();
//     return resp;
//     // } catch (err) {
//     //   return false;
//     // }
//   }
// }

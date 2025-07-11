import 'package:worker_manager/worker_manager.dart';


Future<T> deserializeInIsolate<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
    ) {
  return workerManager.execute(
        () => fromJson(json),
  );
}

Future<List<T>> deserializeListInIsolate<T>(
    List<dynamic> jsonList,
    T Function(Map<String, dynamic>) fromJson,
    ) async {
  return Future.wait(
    jsonList.map((json) => workerManager.execute(() => fromJson(json))).toList(),
  );
}

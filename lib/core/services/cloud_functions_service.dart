import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'cloud_functions_service.g.dart';

class CloudFunctionsService {
  final _functions = FirebaseFunctions.instance;

  Future<void> saveQrReading(String restaurantId) async {
    await _functions
        .httpsCallable('saveReadQrEvent')
        .call({"restaurantId": restaurantId});
  }
}

@riverpod
CloudFunctionsService cloudFunctionsService(ref) {
  return CloudFunctionsService();
}

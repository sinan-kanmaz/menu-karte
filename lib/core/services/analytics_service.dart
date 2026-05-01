import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  saveQrReading(String marketId) async {
    await _analytics.logEvent(
      name: "read qr",
      parameters: {"marketId": marketId},
    );
  }
}

@riverpod
AnalyticsService analyticsService(ref) {
  return AnalyticsService();
}

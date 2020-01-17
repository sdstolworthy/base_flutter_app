import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:meta/meta.dart';

class AnalyticsRepository {
  final FirebaseAnalytics _firebaseAnalytics;
  AnalyticsRepository({FirebaseAnalytics firebaseAnalytics})
      : _firebaseAnalytics = firebaseAnalytics ?? FirebaseAnalytics();

  void logEvent({@required String name, Map<String, dynamic> parameters}) {
    _firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }
}

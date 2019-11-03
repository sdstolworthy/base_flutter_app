import 'package:meta/meta.dart';

@immutable
abstract class JournalFeedEvent {}

class FetchFeed extends JournalFeedEvent {}

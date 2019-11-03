import 'package:meta/meta.dart';

@immutable
abstract class PageViewEvent {}

class PreviousPage extends PageViewEvent {}

class NextPage extends PageViewEvent {}

class SetPage extends PageViewEvent {
  final int page;
  SetPage(this.page);
}

class NotifyPageChange extends PageViewEvent {
  final int page;
  NotifyPageChange(this.page);
}

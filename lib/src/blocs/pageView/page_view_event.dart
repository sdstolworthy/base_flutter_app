import 'package:meta/meta.dart';

@immutable
abstract class PageViewEvent {}

class PreviousPage extends PageViewEvent {}

class NextPage extends PageViewEvent {}

class SetPage extends PageViewEvent {
  final int currentPage;
  SetPage(this.currentPage);
}

class NotifyPageChange extends PageViewEvent {
  final int currentPage;
  NotifyPageChange(this.currentPage);
}

import 'package:meta/meta.dart';

@immutable
abstract class PageViewState {}

class CurrentPage extends PageViewState {
  final int pageIndex;
  CurrentPage(this.pageIndex);
}

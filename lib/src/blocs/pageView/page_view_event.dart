import 'package:meta/meta.dart';

@immutable
abstract class PageViewEvent {}

class PreviousPage extends PageViewEvent {}

class NextPage extends PageViewEvent {}

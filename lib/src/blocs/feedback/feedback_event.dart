part of 'feedback_bloc.dart';

@immutable
abstract class FeedbackEvent {}

class SubmitFeedback extends FeedbackEvent {
  final String feedback;
  SubmitFeedback(this.feedback);
}

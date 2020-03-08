part of 'feedback_bloc.dart';

@immutable
abstract class FeedbackEvent {}

class SubmitFeedback extends FeedbackEvent {
  SubmitFeedback(this.feedback);

  final String feedback;
}

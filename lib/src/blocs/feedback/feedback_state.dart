part of 'feedback_bloc.dart';

@immutable
abstract class FeedbackState {}

class FeedbackInitial extends FeedbackState {}

class FeedbackSending extends FeedbackState {}

class FeedbackSent extends FeedbackState {}

class FeedbackSendError extends FeedbackState {}

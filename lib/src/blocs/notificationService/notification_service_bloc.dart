import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class NotificationServiceBloc extends Bloc<NotificationServiceEvent, NotificationServiceState> {
  @override
  NotificationServiceState get initialState => InitialNotificationServiceState();

  @override
  Stream<NotificationServiceState> mapEventToState(
    NotificationServiceEvent event,
  ) async* {
    // TODO: Add Logic
  }
}

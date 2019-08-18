import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'bloc.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationState get initialState => LocalizationState(Locale('en'));
  @override
  Stream<LocalizationState> mapEventToState(LocalizationEvent event) async* {
    if (event is ChangeLocalization) {
      yield LocalizationState(event.locale);
    }
  }
}

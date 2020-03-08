import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'bloc.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  @override
  LocalizationState get initialState => LocalizationState(const Locale('en'));
  @override
  Stream<LocalizationState> mapEventToState(LocalizationEvent event) async* {
    if (event is ChangeLocalization) {
      yield LocalizationState(event.locale);
    }
  }
}

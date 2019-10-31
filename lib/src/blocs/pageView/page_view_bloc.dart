import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:flutter/material.dart';

class PageViewBloc extends Bloc<PageViewEvent, PageViewState> {
  PageController pageController;

  PageViewBloc({PageController pageController})
      : this.pageController = pageController ?? new PageController();
  @override
  PageViewState get initialState => InitialPageViewState();

  @override
  Stream<PageViewState> mapEventToState(
    PageViewEvent event,
  ) async* {
    if (event is NextPage) {
      pageController.nextPage(
          curve: ElasticInCurve(), duration: Duration(milliseconds: 30));
    }
    if (event is PreviousPage) {
      pageController.previousPage(
          curve: ElasticInCurve(), duration: Duration(milliseconds: 30));
    }
  }
}

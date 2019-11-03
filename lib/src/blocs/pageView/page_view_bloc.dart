import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:flutter/material.dart';

const int animationDurationInMilliseconds = 60;

class PageViewBloc extends Bloc<PageViewEvent, PageViewState> {
  int initialPage;

  PageController pageController;
  Map<String, int> pages;
  PageViewBloc({PageController pageController, this.pages, int initialPage}) {
    this.initialPage = initialPage ?? 0;
    this.pageController =
        (pageController ?? new PageController(initialPage: this.initialPage))
          ..addListener(() {
            if (this.pageController.page.toInt() == this.pageController.page) {
              this.add(NotifyPageChange(this.pageController.page.toInt()));
            }
          });
  }

  @override
  PageViewState get initialState => CurrentPage(0);

  @override
  Stream<PageViewState> mapEventToState(
    PageViewEvent event,
  ) async* {
    if (event is NextPage) {
      pageController.nextPage(
          curve: ElasticInCurve(),
          duration: Duration(milliseconds: animationDurationInMilliseconds));
    } else if (event is PreviousPage) {
      print(pageController.page);
      pageController.previousPage(
          curve: ElasticInCurve(),
          duration: Duration(milliseconds: animationDurationInMilliseconds));
    } else if (event is NotifyPageChange) {
      yield CurrentPage(pageController.page.toInt());
    } else if (event is SetPage) {
      print(event.page);
      pageController.animateToPage(event.page,
          curve: ElasticInCurve(),
          duration: Duration(milliseconds: animationDurationInMilliseconds));
    }
    yield CurrentPage(pageController.page.toInt());
  }
}

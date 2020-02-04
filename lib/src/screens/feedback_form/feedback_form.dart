import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_app/src/blocs/feedback/feedback_bloc.dart';
import 'package:flutter_base_app/src/services/localizations/localizations.dart';
import 'package:flutter_base_app/src/services/navigator.dart';

class FeedbackFormArgs {
  final ScaffoldState scaffoldReference;
  FeedbackFormArgs(this.scaffoldReference);
}

class FeedbackForm extends StatelessWidget {
  final TextEditingController textEditingController =
      new TextEditingController();
  final FeedbackFormArgs feedbackFormArgs;
  FeedbackForm(this.feedbackFormArgs);
  build(context) {
    final localizations = AppLocalizations.of(context);

    final feedbackBloc = FeedbackBloc();
    return BlocProvider(
      create: (_) => feedbackBloc,
      child: BlocListener<FeedbackBloc, FeedbackState>(
        listener: (context, feedbackState) {
          if (feedbackState is FeedbackSent) {
            if (rootNavigationService?.navigatorKey?.currentState?.canPop() ==
                    true &&
                feedbackFormArgs?.scaffoldReference != null) {
              feedbackFormArgs.scaffoldReference.showSnackBar(SnackBar(
                content: Text(localizations.thanksForYourFeedback),
              ));
              rootNavigationService.goBack();
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[900],
            elevation: 0,
            title: Text(AppLocalizations.of(context).leaveFeedback),
          ),
          body: LayoutBuilder(builder: (context, viewportDimensions) {
            return BlocBuilder<FeedbackBloc, FeedbackState>(
                bloc: feedbackBloc,
                builder: (context, feedbackState) {
                  if (feedbackState is FeedbackSending) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: viewportDimensions.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: TextField(
                                  minLines: null,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .body1
                                      .copyWith(fontSize: 18),
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)
                                        .feedbackHint,
                                    hintStyle: Theme.of(context)
                                        .primaryTextTheme
                                        .body1
                                        .copyWith(
                                            color: Colors.white38,
                                            fontStyle: FontStyle.italic),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                  controller: textEditingController,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      feedbackBloc.add(SubmitFeedback(
                                          textEditingController.value.text));
                                    },
                                    icon: Icon(Icons.send),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
        ),
      ),
    );
  }
}

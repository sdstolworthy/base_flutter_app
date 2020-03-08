import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_app/src/blocs/feedback/feedback_bloc.dart';
import 'package:flutter_base_app/src/services/localizations/localizations.dart';
import 'package:flutter_base_app/src/services/navigator.dart';

class FeedbackFormArgs {
  FeedbackFormArgs(this.scaffoldReference);

  final ScaffoldState scaffoldReference;
}

class FeedbackForm extends StatelessWidget {
  FeedbackForm(this.feedbackFormArgs);

  final FeedbackFormArgs feedbackFormArgs;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    final FeedbackBloc feedbackBloc = FeedbackBloc();
    return BlocProvider<FeedbackBloc>(
      create: (_) => feedbackBloc,
      child: BlocListener<FeedbackBloc, FeedbackState>(
        listener: (BuildContext context, FeedbackState feedbackState) {
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
          body: LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportDimensions) {
            return BlocBuilder<FeedbackBloc, FeedbackState>(
                bloc: feedbackBloc,
                builder: (BuildContext context, FeedbackState feedbackState) {
                  if (feedbackState is FeedbackSending) {
                    return const Center(
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
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: const UnderlineInputBorder(
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

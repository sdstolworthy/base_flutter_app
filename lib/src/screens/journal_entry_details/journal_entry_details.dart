import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/edit_journal_entry/bloc.dart';
import 'package:grateful/src/blocs/journal_entry_feed/bloc.dart';
import 'package:grateful/src/helpers/get_platform_store_links.dart';
import 'package:grateful/src/models/JournalEntry.dart';
import 'package:grateful/src/repositories/JournalEntries/JournalEntryRepository.dart';
import 'package:grateful/src/screens/journal_page_view/journal_page_view.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/background_gradient_provider.dart';
import 'package:grateful/src/widgets/photo_viewer.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class JournalEntryDetailArguments {
  JournalEntry journalEntry;

  JournalEntryDetailArguments({@required this.journalEntry});
}

class JournalEntryDetails extends StatefulWidget {
  final JournalEntry journalEntry;
  JournalEntryDetails(this.journalEntry);

  @override
  State<StatefulWidget> createState() {
    return _JournalEntryDetails(this.journalEntry);
  }
}

class _JournalEntryDetails extends State<JournalEntryDetails>
    with TickerProviderStateMixin {
  Animation<double> _animationController;
  Animation<Offset> _animation;

  String _getShareText(JournalEntry journalEntry) {
    return '${journalEntry.body}\n\nI show my gratitude with Grateful. Download it here:\n${getPlatformStoreLink()}';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_animation == null) {
      // _animationController = ModalRoute.of(context).animation;
      _animationController = ModalRoute.of(context).animation;
      setState(() {
        _animation =
            Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                .animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.fastOutSlowIn,
        ));
        // _animationController.forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // _animationController.dispose();
  }

  final JournalEntry journalEntry;
  _JournalEntryDetails(this.journalEntry);
  Widget _renderAppBar(context) {
    final EditJournalEntryBloc _journalEntryBloc =
        BlocProvider.of<EditJournalEntryBloc>(context);
    final theme = Theme.of(context);
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: FlatButton(
          child:
              Icon(Icons.arrow_back, color: theme.appBarTheme.iconTheme.color),
          onPressed: () {
            rootNavigationService.goBack();
          }),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            showDialog(
                context: context,
                builder: (c) {
                  return AlertDialog(
                    title: Text(
                      'Delete Journal Entry',
                      style: theme.accentTextTheme.body1,
                    ),
                    content: Text(
                        'Are you sure you want to delete this journal entry? This cannot be undone.',
                        style: theme.accentTextTheme.body1),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('No, do not delete',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                          onPressed: () {
                            _journalEntryBloc
                                .add(DeleteJournalEntry(journalEntry));
                            Navigator.of(context).pop();
                          },
                          child: Text('Yes, delete it',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[900])))
                    ],
                  );
                });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onPressed: () {
            rootNavigationService.navigateTo(FlutterAppRoutes.journalPageView,
                arguments: JournalPageArguments(entry: journalEntry));
          },
        ),
        IconButton(
          icon: Icon(Icons.share),
          color: Colors.white,
          onPressed: () {
            Share.share(_getShareText(journalEntry));
          },
        )
      ],
    );
  }

  build(context) {
    final EditJournalEntryBloc _journalEntryBloc = EditJournalEntryBloc(
        journalEntryRepository: JournalEntryRepository(),
        journalFeedBloc: BlocProvider.of<JournalFeedBloc>(context));
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (panUpdateDetails) {
          if (panUpdateDetails.delta.dx > 0 && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
        child: BlocProvider<EditJournalEntryBloc>(
            create: (_) => _journalEntryBloc,
            child: BlocListener<EditJournalEntryBloc, EditJournalEntryState>(
              listener: (context, state) {
                if (state is JournalEntryDeleted) {
                  rootNavigationService.goBack();
                }
              },
              bloc: _journalEntryBloc,
              child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, snapshot) {
                    return LayoutBuilder(
                        builder: (context, viewportConstraints) {
                      return BackgroundGradientProvider(
                        child: SafeArea(
                          bottom: false,
                          child: NestedScrollView(
                            headerSliverBuilder: (context, isScrolled) {
                              return [_renderAppBar(context)].toList();
                            },
                            body: ListView(
                              children: <Widget>[
                                _renderPhotoSlider(),
                                _renderContentSleigh(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: IntrinsicHeight(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Text(
                                                  DateFormat.yMMMMd().format(
                                                      journalEntry.date),
                                                  style: theme
                                                      .accentTextTheme.headline
                                                      .copyWith(
                                                          fontStyle: FontStyle
                                                              .italic)),
                                            ),
                                            Flexible(
                                                child: Text(journalEntry.body,
                                                    style: Theme.of(context)
                                                        .accentTextTheme
                                                        .body1)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    constraints: viewportConstraints),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  }),
            )),
      ),
    );
  }

  Widget _renderContentSleigh(
      {@required Widget child, @required BoxConstraints constraints}) {
    return FractionalTranslation(
        translation: _animation.value,
        child: Container(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 1,
                    blurRadius: 2.0,
                    offset: Offset(0, 1),
                  )
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.white),
            child: child));
  }

  Widget _renderPhotoSlider() {
    return Container(
      height: journalEntry.photographs != null &&
              journalEntry.photographs.length > 0
          ? 250
          : 0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
            child: Center(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  ...(journalEntry.photographs ?? [])
                      .map((p) => CachedNetworkImage(
                            imageUrl: p.imageUrl,
                            placeholder: (c, i) {
                              return Container(
                                width: 150,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            imageBuilder: (c, i) {
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (c) => PhotoViewer(
                                                  imageProvider: i,
                                                )));
                                  },
                                  child: Image(
                                    width: 150,
                                    height: 250,
                                    fit: BoxFit.cover,
                                    image: i,
                                  ),
                                ),
                              );
                            },
                          ))
                      .toList()
                ],
              )),
        )),
      ),
    );
  }
}

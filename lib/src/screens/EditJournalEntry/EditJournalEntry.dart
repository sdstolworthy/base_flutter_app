import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/editJournalEntry/bloc.dart';
import 'package:grateful/src/blocs/imageHandler/bloc.dart';
import 'package:grateful/src/blocs/pageView/page_view_bloc.dart';
import 'package:grateful/src/blocs/pageView/page_view_event.dart';
import 'package:grateful/src/models/JournalEntry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/models/Photograph.dart';
import 'package:grateful/src/repositories/cloudMessaging/cloudMessagingRepository.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/messaging.dart';
import 'package:grateful/src/widgets/BackgroundGradientProvider.dart';
import 'package:grateful/src/widgets/DateSelectorButton.dart';
import 'package:grateful/src/widgets/DeletableResource.dart';
import 'package:grateful/src/widgets/ImageUploader.dart';
import 'package:grateful/src/widgets/JournalEntryInput.dart';
import 'package:grateful/src/widgets/NoGlowConfiguration.dart';
import 'package:grateful/src/widgets/Shadower.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EditJournalEntryArgs {
  JournalEntry journalEntry;

  EditJournalEntryArgs({this.journalEntry});
}

class EditJournalEntry extends StatefulWidget {
  bool get wantKeepAlive => true;

  final JournalEntry item;
  EditJournalEntry({this.item});
  @override
  State<StatefulWidget> createState() {
    return _EditJournalEntryState(journalEntry: this.item);
  }
}

class _EditJournalEntryState extends State<EditJournalEntry>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  JournalEntry _journalEntry;
  bool isEdit;
  final EditJournalEntryBloc _editJournalEntryBloc = EditJournalEntryBloc();

  _EditJournalEntryState({JournalEntry journalEntry})
      : this._journalEntry = journalEntry ?? JournalEntry(),
        isEdit = journalEntry != null {
    _journalEntryController.value = TextEditingValue(text: '');
  }

  final TextEditingController _journalEntryController = TextEditingController();

  final ImageHandlerBloc _imageHandlerBloc = ImageHandlerBloc();

  initState() {
    super.initState();
    _journalEntryController.value =
        TextEditingValue(text: _journalEntry.body ?? '');
    try {
      _firebaseMessaging.configure(
          onMessage: (message) async {
            print(message);
          },
          onBackgroundMessage: backgroundMessageHandler,
          onLaunch: (m) async {
            print(m);
          },
          onResume: (m) async {
            print(m);
          });
    } catch (e) {
      print(
          'Failed to configure Firebase Cloud Messaging. Are you using the iOS simulator?');
    }
  }

  dispose() {
    _editJournalEntryBloc.close();
    super.dispose();
  }

  clearEditState() {
    setState(() {
      _journalEntry = JournalEntry();
      isEdit = false;
      _journalEntryController.value =
          TextEditingValue(text: _journalEntry.body ?? '');
      _imageHandlerBloc.add(SetPhotographs([]));
    });
  }

  build(c) {
    super.build(c);
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then(CloudMessagingRepository().setId);
    final AppLocalizations localizations = AppLocalizations.of(c);
    return BlocBuilder(
        bloc: _editJournalEntryBloc,
        builder: (BuildContext context, EditJournalEntryState state) {
          return Scaffold(
              body: NestedScrollView(
            headerSliverBuilder: (context, isScrolled) {
              return [
                SliverAppBar(
                  elevation: 0,
                  floating: true,
                  leading: Container(),
                  actions: <Widget>[
                    if (isEdit)
                      FlatButton(
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onPressed: clearEditState,
                      )
                  ],
                )
              ];
            },
            body: LayoutBuilder(builder: (context, viewportConstraints) {
              return ScrollConfiguration(
                behavior: NoGlowScroll(),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight),
                    child: IntrinsicHeight(
                      child: BackgroundGradientProvider(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        localizations.gratefulPrompt,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline,
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: DateSelectorButton(
                                          onPressed: handlePickDate,
                                          selectedDate: _journalEntry.date,
                                          locale: Localizations.localeOf(c),
                                        ),
                                      ),
                                      JournalInput(
                                        onChanged: (text) {
                                          setState(() {
                                            _journalEntry.body = text;
                                          });
                                        },
                                        controller: _journalEntryController,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: _editablePhotoSlider(context),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Icon(Icons.check,
                                          color: Colors.white, size: 36),
                                    ),
                                    color: Colors.transparent,
                                    onPressed: () {
                                      if (_journalEntry.body != null) {
                                        _editJournalEntryBloc.add(
                                            SaveJournalEntry(_journalEntry));
                                        this.clearEditState();
                                      }

                                      BlocProvider.of<PageViewBloc>(context)
                                          .add(SetPage(1));
                                    },
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ));
        });
  }

  void handlePickDate(context) async {
    DateTime newDate = await showDatePicker(
      context: context,
      initialDate: _journalEntry.date ?? DateTime.now(),
      firstDate: DateTime.parse('1900-01-01'),
      lastDate: DateTime.now(),
    );
    if (newDate != null) {
      setState(() {
        _journalEntry.date = newDate;
      });
    }
  }

  Widget _editablePhotoSlider(
    BuildContext context,
  ) {
    return BlocBuilder<ImageHandlerBloc, ImageHandlerState>(
        bloc: _imageHandlerBloc,
        builder: (context, state) {
          if (state is InitialImageHandlerState) {
            _imageHandlerBloc.add(SetPhotographs(_journalEntry.photographs));
          } else if (state is PhotographsLoaded) {
            final photographs = state.photographs;

            return Container(
              height: 150,
              child: ListView(
                padding: EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                children: [
                  ..._renderPhotoBlocks(photographs),
                  _renderAddPhotoButton(context)
                ],
              ),
            );
          }
          return Container();
        });
  }

  _renderPhotoBlocks(List<Photograph> photographs) {
    return photographs.map((photograph) {
      if (photograph is NetworkPhoto) {
        return DeletableResource(
          onRemove: () {
            _imageHandlerBloc.add(SetPhotographs(List.from(
                _journalEntry.photographs
                  ..removeWhere((p) => p.imageUrl == photograph.imageUrl))));
          },
          child: Container(
            height: 125,
            width: 125,
            child: CachedNetworkImage(
              imageUrl: photograph.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      } else if (photograph is FilePhoto) {
        return ImageUploader(
          child: Container(
            height: 125,
            width: 125,
            child: Image.file(
              photograph.file,
              fit: BoxFit.cover,
            ),
          ),
          file: photograph.file,
          onComplete: (String imageUrl) {
            final newPhoto = NetworkPhoto(imageUrl: imageUrl);
            _imageHandlerBloc.add(ReplaceFilePhotoWithNetworkPhoto(
                photograph: newPhoto, filePhotoGuid: photograph.guid));

            _journalEntry.photographs.add(newPhoto);
          },
        );
      }
      return Container();
    }).toList();
  }

  _renderAddPhotoButton(context) {
    final localizations = AppLocalizations.of(context);
    return SizedBox(
        height: 150,
        width: 150,
        child: ClipRRect(
            borderRadius: new BorderRadius.circular(20),
            child: Container(
              color: Colors.blue[700],
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    File file = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (file == null) {
                      return;
                    }
                    final FilePhoto photo =
                        new FilePhoto(file: file, guid: Uuid().v4());
                    _imageHandlerBloc.add(AddPhotograph(photo));
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, color: Colors.white),
                        Text(
                          localizations.addPhotos,
                          style: Theme.of(context).primaryTextTheme.body1,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}

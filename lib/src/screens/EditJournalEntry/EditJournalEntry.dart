import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/editJournalEntry/bloc.dart';
import 'package:grateful/src/blocs/imageHandler/bloc.dart';
import 'package:grateful/src/blocs/journalEntryFeed/item_bloc.dart';
import 'package:grateful/src/blocs/pageView/page_view_bloc.dart';
import 'package:grateful/src/blocs/pageView/page_view_event.dart';
import 'package:grateful/src/models/JournalEntry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/models/Photograph.dart';
import 'package:grateful/src/repositories/cloudMessaging/cloudMessagingRepository.dart';
import 'package:grateful/src/repositories/files/fileRepository.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/messaging.dart';
import 'package:grateful/src/widgets/BackgroundGradientProvider.dart';
import 'package:grateful/src/widgets/DateSelectorButton.dart';
import 'package:grateful/src/widgets/DeletableResource.dart';
import 'package:grateful/src/widgets/ImageUploader.dart';
import 'package:grateful/src/widgets/JournalEntryInput.dart';
import 'package:grateful/src/widgets/NoGlowConfiguration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
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

const double imageDimension = 125.0;

class _EditJournalEntryState extends State<EditJournalEntry>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  JournalEntry _journalEntry;
  bool isEdit;
  EditJournalEntryBloc _editJournalEntryBloc;

  _EditJournalEntryState({JournalEntry journalEntry})
      : this._journalEntry = journalEntry ?? JournalEntry(),
        isEdit = journalEntry != null {
    _journalEntryController.value = TextEditingValue(text: '');
  }

  final TextEditingController _journalEntryController = TextEditingController();

  final ImageHandlerBloc _imageHandlerBloc = ImageHandlerBloc();

  initState() {
    _editJournalEntryBloc = EditJournalEntryBloc(
        journalFeedBloc: BlocProvider.of<JournalFeedBloc>(context));
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
                  elevation: 100,
                  floating: false,
                  pinned: false,
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
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: BackgroundGradientProvider(
                child: LayoutBuilder(builder: (context, viewportConstraints) {
                  return ScrollConfiguration(
                    behavior: NoGlowScroll(showLeading: false),
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Column(children: [
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
                                        ]),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: BlocBuilder(
                                      bloc: _imageHandlerBloc,
                                      builder: (context, imageHandlerState) {
                                        if (imageHandlerState
                                            is InitialImageHandlerState) {
                                          _imageHandlerBloc.add(SetPhotographs(
                                              _journalEntry.photographs));
                                        } else if (imageHandlerState
                                            is PhotographsLoaded) {
                                          return Container(
                                            child: _editablePhotoSlider(
                                                context,
                                                _renderPhotoBlocks(
                                                    imageHandlerState
                                                        .photographs)),
                                          );
                                        }
                                        return Container();
                                      }),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    BlocBuilder(
                                      bloc: _imageHandlerBloc,
                                      builder: (c, data) {
                                        final imageCompletionStream =
                                            Observable.combineLatest(
                                                _imageHandlerBloc.photographs
                                                    .where((photo) =>
                                                        photo is FilePhoto)
                                                    .map((photo) =>
                                                        (photo as FilePhoto)
                                                            .uploadTask
                                                            .events)
                                                    .map<Stream<bool>>((events) =>
                                                        events.transform(
                                                            StreamTransformer.fromHandlers(
                                                                handleData:
                                                                    (data, sink) {
                                                          if (data.snapshot
                                                                      .bytesTransferred /
                                                                  data.snapshot
                                                                      .totalByteCount ==
                                                              1) {
                                                            sink.add(true);
                                                          } else {
                                                            sink.add(false);
                                                          }
                                                        }))), (data) {
                                          return data.every((d) => d);
                                        }).startWith(_imageHandlerBloc.photographs.where((ph) => ph is FilePhoto).length > 0 ? false : true);
                                        return StreamBuilder(
                                            stream: imageCompletionStream,
                                            builder: (context, streamSnapshot) {
                                              return streamSnapshot.data == true
                                                  ? IconButton(
                                                      padding:
                                                          EdgeInsets.all(50),
                                                      icon: Icon(Icons.check,
                                                          size: 40),
                                                      color: Colors.white,
                                                      onPressed: () {
                                                        if (_journalEntry
                                                                .body !=
                                                            null) {
                                                          _editJournalEntryBloc.add(
                                                              SaveJournalEntry(
                                                                  _journalEntry));
                                                          this.clearEditState();
                                                        }

                                                        BlocProvider.of<
                                                                    PageViewBloc>(
                                                                context)
                                                            .add(SetPage(1));
                                                      })
                                                  : IconButton(
                                                      padding:
                                                          EdgeInsets.all(50),
                                                      onPressed: () {
                                                        Scaffold.of(context)
                                                          ..removeCurrentSnackBar()
                                                          ..showSnackBar(
                                                              SnackBar(
                                                            content: Text(
                                                                'Please wait until all images have finished uploading.'),
                                                          ));
                                                      },
                                                      icon: Icon(
                                                        Icons.check,
                                                        color: Colors.white38,
                                                        size: 40,
                                                      ),
                                                    );
                                            });
                                      },
                                    )
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
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

  Widget _editablePhotoSlider(BuildContext context, List<Widget> children) {
    return Container(
      height: imageDimension,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [...children, _renderAddPhotoButton(context)],
          ),
        ),
      ),
    );
  }

  _renderPhotoBlocks(List<Photograph> photographs) {
    final photoWidgets = photographs.map((photograph) {
      if (photograph is NetworkPhoto) {
        return DeletableResource(
          onRemove: () {
            _imageHandlerBloc.add(SetPhotographs(List.from(
                _journalEntry.photographs
                  ..removeWhere((p) => p.imageUrl == photograph.imageUrl))));
          },
          child: Container(
            height: imageDimension,
            width: imageDimension,
            child: CachedNetworkImage(
              imageUrl: photograph.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      } else if (photograph is FilePhoto) {
        return ImageUploader(
          uploadTask: photograph.uploadTask,
          child: Container(
            height: imageDimension,
            width: imageDimension,
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

    return photoWidgets;
  }

  _renderAddPhotoButton(context) {
    final localizations = AppLocalizations.of(context);
    return SizedBox(
        height: imageDimension,
        width: imageDimension,
        child: ClipRRect(
            borderRadius: new BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.blue[700],
                    Colors.blue[700].withOpacity(0.0)
                  ])),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    File file = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (file == null) {
                      return;
                    }
                    final FilePhoto photo = new FilePhoto(
                        file: file,
                        guid: Uuid().v4(),
                        uploadTask: FileRepository().uploadFile(file));
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

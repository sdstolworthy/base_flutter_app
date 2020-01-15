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
    return _renderFullScreenGradientScrollView();
  }

  Widget _renderFullScreenGradientScrollView() {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(this.context).requestFocus(new FocusNode());
        },
        child: BackgroundGradientProvider(
          child: SafeArea(
            child: LayoutBuilder(builder: (context, layoutConstraints) {
              return ScrollConfiguration(
                behavior: NoGlowScroll(showLeading: true),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: layoutConstraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 80,
                          ),
                          Expanded(
                            child: _entryEditComponent(context),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              _renderAddPhotoButton(context),
                              _renderSaveCheck(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
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

  Widget _entryEditComponent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          AppLocalizations.of(context).gratefulPrompt,
          style: Theme.of(context).primaryTextTheme.headline,
          textAlign: TextAlign.left,
        ),
        DateSelectorButton(
          onPressed: handlePickDate,
          selectedDate: _journalEntry.date,
          locale: Localizations.localeOf(context),
        ),
        Divider(
          color: Colors.white,
        ),
        SizedBox(height: 10),
        JournalInput(
          onChanged: (text) {
            setState(() {
              _journalEntry.body = text;
            });
          },
          controller: _journalEntryController,
        ),
      ]),
    );
  }

  Widget _photoSliderProvider() {
    return BlocBuilder(
        bloc: _imageHandlerBloc,
        builder: (context, imageHandlerState) {
          if (imageHandlerState is InitialImageHandlerState) {
            _imageHandlerBloc.add(SetPhotographs(_journalEntry.photographs));
          } else if (imageHandlerState is PhotographsLoaded) {
            return Container(
              child: _editablePhotoSlider(
                  context, _renderPhotoBlocks(imageHandlerState.photographs)),
            );
          }
          return Container();
        });
  }

  Widget _editablePhotoSlider(BuildContext context, List<Widget> children) {
    return Container(
      height: imageDimension,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: children,
          ),
        ),
      ),
    );
  }

  _renderSaveCheck() {
    return BlocBuilder(
      bloc: _imageHandlerBloc,
      builder: (c, data) {
        final imageCompletionStream = Observable.combineLatest(
            _imageHandlerBloc.photographs
                .where((photo) => photo is FilePhoto)
                .map((photo) => (photo as FilePhoto).uploadTask.events)
                .map<Stream<bool>>((events) => events.transform(
                        StreamTransformer.fromHandlers(
                            handleData: (data, sink) {
                      if (data.snapshot.bytesTransferred /
                              data.snapshot.totalByteCount ==
                          1) {
                        sink.add(true);
                      } else {
                        sink.add(false);
                      }
                    }))), (data) {
          return data.every((d) => d);
        }).startWith(_imageHandlerBloc.photographs
                    .where((ph) => ph is FilePhoto)
                    .length >
                0
            ? false
            : true);
        return StreamBuilder(
            stream: imageCompletionStream,
            builder: (context, streamSnapshot) {
              return streamSnapshot.data == true
                  ? IconButton(
                      padding: EdgeInsets.all(50),
                      icon: Icon(Icons.check, size: 40),
                      color: Colors.white,
                      onPressed: () {
                        if (_journalEntry.body != null) {
                          _editJournalEntryBloc
                              .add(SaveJournalEntry(_journalEntry));
                          this.clearEditState();
                        }

                        BlocProvider.of<PageViewBloc>(context).add(SetPage(1));
                      })
                  : IconButton(
                      padding: EdgeInsets.all(50),
                      onPressed: () {
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(
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
    return FlatButton(
        onPressed: () async {
          File file = await ImagePicker.pickImage(
              imageQuality: 35, source: ImageSource.gallery);
          if (file == null) {
            return;
          }
          final FilePhoto photo = new FilePhoto(
              file: file,
              guid: Uuid().v4(),
              uploadTask: await FileRepository().uploadFile(file));
          _imageHandlerBloc.add(AddPhotograph(photo));
        },
        child: Column(
          children: <Widget>[
            Icon(Icons.add_a_photo),
            Text(
              localizations.addPhotos,
              style: Theme.of(context).primaryTextTheme.body1,
            ),
          ],
        ));
  }
}

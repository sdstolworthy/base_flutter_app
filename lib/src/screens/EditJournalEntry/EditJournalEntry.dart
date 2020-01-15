import 'dart:io';

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
import 'package:grateful/src/widgets/ImageUploader.dart';
import 'package:grateful/src/widgets/JournalEntryInput.dart';
import 'package:grateful/src/widgets/NoGlowConfiguration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EditJournalEntryArgs {
  EditJournalEntryArgs({this.journalEntry});

  JournalEntry journalEntry;
}

class EditJournalEntry extends StatefulWidget {
  EditJournalEntry({this.item});

  final JournalEntry item;

  @override
  State<StatefulWidget> createState() {
    return _EditJournalEntryState(journalEntry: this.item);
  }

  bool get wantKeepAlive => true;
}

const double imageDimension = 125.0;

class _EditJournalEntryState extends State<EditJournalEntry>
    with AutomaticKeepAliveClientMixin {
  _EditJournalEntryState({JournalEntry journalEntry})
      : this._journalEntry = journalEntry ?? JournalEntry(),
        isEdit = journalEntry != null {
    _journalEntryController.value = TextEditingValue(text: '');
  }

  bool isEdit;

  EditJournalEntryBloc _editJournalEntryBloc;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FileRepository fileRepository = FileRepository();
  List<ImageHandlerBloc> _imageHandlerBlocs = [];
  JournalEntry _journalEntry;
  final TextEditingController _journalEntryController = TextEditingController();

  bool get wantKeepAlive => true;

  initState() {
    setState(() {
      _journalEntry = this._journalEntry;
    });
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
    this._imageHandlerBlocs.map((bloc) => bloc?.close());
    super.dispose();
  }

  clearEditState() {
    setState(() {
      _journalEntry = JournalEntry();
      isEdit = false;
      _imageHandlerBlocs = [];
      _journalEntryController.value =
          TextEditingValue(text: _journalEntry.body ?? '');
    });
  }

  build(c) {
    super.build(c);
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then(CloudMessagingRepository().setId);
    return _renderFullScreenGradientScrollView(
      child: Builder(builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _entryEditComponent(context),
            ),
            _photoSliderProvider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _renderAddPhotoButton(context),
                _renderSaveCheck(context),
              ],
            )
          ],
        );
      }),
    );
  }

  Widget _renderFullScreenGradientScrollView({@required Widget child}) {
    return NestedScrollView(
      headerSliverBuilder: (context, isScrolled) {
        return [_renderSliverAppBar(this.context)];
      },
      body: Scaffold(
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
                      constraints: BoxConstraints(
                          minHeight: layoutConstraints.maxHeight),
                      child: IntrinsicHeight(
                        child: child,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePickDate(context) async {
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
          onPressed: _handlePickDate,
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

  Widget _renderSliverAppBar(context) {
    return SliverAppBar(
      expandedHeight: 0,
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
    );
  }

  Widget _photoSliderProvider() {
    return _editablePhotoSlider(context, _renderPhotoBlocks());
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

  _renderSaveCheck(BuildContext saveContext) {
    final isJournalEntryNull = this._journalEntry.body == null;
    return IconButton(
        padding: EdgeInsets.all(50),
        icon: Icon(Icons.check, size: 40),
        onPressed: isJournalEntryNull
            ? null
            : () {
                _handleSavePress(saveContext);
              });
  }

  _handleSavePress(BuildContext saveContext) {
    final photosAreFinishedUploading =
        _imageHandlerBlocs.fold<bool>(true, (prev, curr) {
      if (prev == false) {
        return false;
      }
      return curr.isUploaded;
    });
    if (!photosAreFinishedUploading) {
      return _handleSaveDisabledPress(saveContext);
    }
    if (_journalEntry.body != null) {
      _editJournalEntryBloc.add(SaveJournalEntry(_journalEntry.copyWith(
          photographs: _imageHandlerBlocs
              .where((bloc) => bloc.photograph is NetworkPhoto)
              .map<NetworkPhoto>((bloc) => bloc.photograph)
              .toList())));
      this.clearEditState();
    }

    BlocProvider.of<PageViewBloc>(context).add(SetPage(1));
  }

  _handleSaveDisabledPress(BuildContext context) {
    return () {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content:
              Text('Please wait until all images have finished uploading.'),
        ));
    };
  }

  _renderPhotoBlocks() {
    final photoWidgets = _imageHandlerBlocs.map((_bloc) {
      return BlocProvider(
          create: (_) => _bloc,
          child: ImageUploader(
            onRemove: (bloc) {
              setState(() {
                this._imageHandlerBlocs.remove(bloc);
              });
            },
          ));
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
          final FilePhoto photo = new FilePhoto(file: file, guid: Uuid().v4());
          setState(() {
            _imageHandlerBlocs.add(new ImageHandlerBloc(
                photograph: photo, fileRepository: fileRepository));
          });
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

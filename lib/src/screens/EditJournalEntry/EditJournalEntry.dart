import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/editJournalEntry/bloc.dart';
import 'package:grateful/src/blocs/imageHandler/bloc.dart';
import 'package:grateful/src/blocs/pageView/page_view_bloc.dart';
import 'package:grateful/src/blocs/pageView/page_view_event.dart';
import 'package:grateful/src/models/JournalEntry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/models/Photograph.dart';
import 'package:grateful/src/widgets/DateSelectorButton.dart';
import 'package:grateful/src/widgets/ImageUploader.dart';
import 'package:grateful/src/widgets/JournalEntryInput.dart';
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

  JournalEntry _journalEntry;
  bool isEdit;
  final EditItemBloc _editJournalEntryBloc = EditItemBloc();

  _EditJournalEntryState({JournalEntry journalEntry})
      : this._journalEntry = journalEntry ?? JournalEntry(),
        isEdit = journalEntry != null {
    _journalEntryController.value = TextEditingValue(text: '');
  }

  List<Photograph> _photographs = [];

  final TextEditingController _journalEntryController = TextEditingController();

  final ImageHandlerBloc _imageHandlerBloc = ImageHandlerBloc();

  initState() {
    super.initState();
    _journalEntryController.value =
        TextEditingValue(text: _journalEntry.body ?? '');
    _photographs = _journalEntry.photographs ?? [];
  }

  dispose() {
    _editJournalEntryBloc.close();
    super.dispose();
  }

  clearEditState() {
    setState(() {
      _journalEntry = JournalEntry();
      isEdit = false;
      _photographs = [];
      _journalEntryController.value =
          TextEditingValue(text: _journalEntry.body ?? '');
      _imageHandlerBloc.add(SetPhotographs([]));
    });
  }

  build(c) {
    super.build(c);
    return BlocBuilder(
        bloc: _editJournalEntryBloc,
        builder: (BuildContext context, EditJournalEntryState state) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                leading: Container(),
                actions: <Widget>[
                  if (isEdit)
                    FlatButton(
                      child: Icon(Icons.clear),
                      onPressed: clearEditState,
                    )
                ],
              ),
              drawer: Drawer(
                  child: Container(
                color: Theme.of(context).backgroundColor,
              )),
              body: Container(
                color: Theme.of(context).backgroundColor,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'What are you grateful for today?',
                            style:
                                TextStyle(color: Colors.white, fontSize: 24.0),
                            textAlign: TextAlign.center,
                          ),
                          DateSelectorButton(
                            onPressed: handlePickDate,
                            selectedDate: _journalEntry.date,
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            iconSize: 36.0,
                            icon: Icon(Icons.arrow_forward),
                            color: Colors.white,
                            onPressed: () {
                              if (_journalEntry.body != null) {
                                _editJournalEntryBloc
                                    .add(SaveJournalEntry(_journalEntry));
                              }

                              BlocProvider.of<PageViewBloc>(context)
                                  .add(NextPage());
                            },
                          ),
                          JournalInput(
                            onChanged: (text) {
                              setState(() {
                                _journalEntry.body = text;
                              });
                            },
                            controller: _journalEntryController,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 30.0),
                              child: BlocBuilder<ImageHandlerBloc,
                                      ImageHandlerState>(
                                  bloc: _imageHandlerBloc,
                                  builder: (context, imageHandlerState) {
                                    if (imageHandlerState
                                        is InitialImageHandlerState) {
                                      _imageHandlerBloc.add(SetPhotographs(
                                          _journalEntry.photographs ??
                                              <Photograph>[]));
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (imageHandlerState
                                        is PhotographsLoaded) {
                                      return Wrap(
                                          alignment: WrapAlignment.start,
                                          direction: Axis.horizontal,
                                          children: <Widget>[
                                            ...imageHandlerState.photographs
                                                .map<Widget>((i) {
                                              if (i is NetworkPhoto) {
                                                return CachedNetworkImage(
                                                  imageUrl: i.imageUrl,
                                                  height: 100,
                                                  width: 100,
                                                );
                                              } else if (i is FilePhoto) {
                                                return ImageUploader(
                                                  file: i.file,
                                                  onComplete:
                                                      (String imageUrl) {
                                                    final newPhoto =
                                                        NetworkPhoto(
                                                            imageUrl: imageUrl);
                                                    _imageHandlerBloc.add(
                                                        ReplaceFilePhotoWithNetworkPhoto(
                                                            photograph:
                                                                newPhoto,
                                                            filePhotoGuid:
                                                                i.guid));

                                                    _journalEntry.photographs
                                                        .add(newPhoto);
                                                  },
                                                );
                                              }
                                              return Container();
                                            }).toList(),
                                            FlatButton(
                                              onPressed: () async {
                                                File file =
                                                    await ImagePicker.pickImage(
                                                        source: ImageSource
                                                            .gallery);
                                                if (file == null) {
                                                  return;
                                                }
                                                final FilePhoto photo =
                                                    new FilePhoto(
                                                        file: file,
                                                        guid: Uuid().v4());
                                                _imageHandlerBloc
                                                    .add(AddPhotograph(photo));
                                              },
                                              child: Container(
                                                child: SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(Icons.add,
                                                            color:
                                                                Colors.white),
                                                        Text(
                                                          'Add Photos',
                                                          style: Theme.of(
                                                                  context)
                                                              .primaryTextTheme
                                                              .body1,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      style: BorderStyle.solid,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                              ),
                                            )
                                          ]);
                                    }
                                    return Container();
                                  }))
                        ]),
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
}

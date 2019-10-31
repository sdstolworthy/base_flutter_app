import 'dart:io';

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
  final JournalEntry item;
  EditJournalEntry({JournalEntry item}) : this.item = item ?? JournalEntry();
  @override
  State<StatefulWidget> createState() {
    return _EditJournalEntryState(journalEntry: this.item);
  }
}

class _EditJournalEntryState extends State<EditJournalEntry> {
  JournalEntry journalEntry;
  final EditItemBloc _editJournalEntryBloc = EditItemBloc();

  _EditJournalEntryState({JournalEntry journalEntry})
      : this.journalEntry = journalEntry ?? JournalEntry();

  List<Photograph> photographs = [];

  final ImageHandlerBloc _imageHandlerBloc = ImageHandlerBloc();

  initState() {
    super.initState();
    photographs = journalEntry.photographs ?? [];
  }

  dispose() {
    _editJournalEntryBloc.close();
    super.dispose();
  }

  build(_) {
    return BlocBuilder(
        bloc: _editJournalEntryBloc,
        builder: (BuildContext context, EditJournalEntryState state) {
          return Scaffold(
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
                            selectedDate: journalEntry.date,
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            iconSize: 36.0,
                            icon: Icon(Icons.arrow_forward),
                            color: Colors.white,
                            onPressed: () {
                              if (journalEntry.body != null) {
                                _editJournalEntryBloc
                                    .add(SaveJournalEntry(journalEntry));
                              }

                              BlocProvider.of<PageViewBloc>(context)
                                  .add(NextPage());
                            },
                          ),
                          JournalInput(
                              onChanged: (text) {
                                setState(() {
                                  journalEntry.body = text;
                                });
                              },
                              initialValue: journalEntry.body),
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
                                          journalEntry.photographs ??
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
                                                return Image.network(
                                                  i.imageUrl,
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

                                                    journalEntry.photographs
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
      initialDate: journalEntry.date ?? DateTime.now(),
      firstDate: DateTime.parse('1900-01-01'),
      lastDate: DateTime.now(),
    );
    if (newDate != null) {
      setState(() {
        journalEntry.date = newDate;
      });
    }
  }
}

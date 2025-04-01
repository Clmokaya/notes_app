import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:provider/provider.dart';

import '../models/note_database.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // text controller
  final textcontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //on app start up fetch existing notes
    readNotes();
  }

//create a note
  void CreateNote() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textcontroller,
              ),
              actions: [
                //create button
                MaterialButton(
                  onPressed: () {
                    //add to db
                    context.read<NoteDatabase>().addNote(textcontroller.text);
                    //clear controller
                    textcontroller.clear();
                    //pop dialog box
                    Navigator.pop(context);
                  },
                  child: const Text('Create'),
                )
              ],
            ));
  }

//read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

//update a note
  void UpdateNote(Note note) {
    //ore fill the current note text
    textcontroller.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text('Update Note'),
          content: TextField(
            controller: textcontroller,
          ),
          actions: [
            //update button
            MaterialButton(
              onPressed: () {
                //update to db
                context
                    .read<NoteDatabase>()
                    .updateNote(note.id, textcontroller.text);
                //clear controller
                textcontroller.clear();
                //pop dialog box
                Navigator.pop(context);
              },
              child: const Text('Update'),
            )
          ]),
    );
  }

//delete a note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    //note database
    final noteDatabase = context.watch<NoteDatabase>();
    //current notes
    List<Note> currentNotes = noteDatabase.currentNotes;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Notes"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: CreateNote,
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //heading
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text('Notes',
                style: GoogleFonts.dmSerifText(
                    fontSize: 48,
                    color: Theme.of(context).colorScheme.inversePrimary)),
          ),
          //list of notes
          Expanded(
            child: ListView.builder(
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  //get individual note
                  final note = currentNotes[index];

                  //return listtile ui
                  return ListTile(
                    title: Text(note.text),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //edit button
                        IconButton(
                            onPressed: () => UpdateNote(note),
                            icon: Icon(Icons.edit)),
                        //delete button
                        IconButton(
                            onPressed: () => deleteNote(note.id),
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

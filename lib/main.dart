import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/note_database.dart';
import 'pages/notes_page.dart';

void main() async {
//initialize note isar database
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();

  runApp(ChangeNotifierProvider(
    create: (context) => NoteDatabase(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NotesPage();
  }
}

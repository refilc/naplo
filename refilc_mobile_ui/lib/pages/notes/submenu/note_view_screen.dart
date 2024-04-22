import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:refilc/api/providers/self_note_provider.dart';
import 'package:refilc/models/self_note.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_mobile_ui/pages/notes/submenu/add_note_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class NoteViewScreen extends StatefulWidget {
  const NoteViewScreen({super.key, required this.note});

  final SelfNote note;

  @override
  NoteViewScreenState createState() => NoteViewScreenState();
}

class NoteViewScreenState extends State<NoteViewScreen> {
  late SelfNoteProvider selfNoteProvider;

  @override
  Widget build(BuildContext context) {
    selfNoteProvider = Provider.of<SelfNoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        title: Text(
          widget.note.title ?? '${widget.note.content.split(' ')[0]}...',
          style: TextStyle(
            color: AppColors.of(context).text,
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.1),
            child: GestureDetector(
              onTap: () {
                // handle tap
                Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                        builder: (context) =>
                            AddNoteScreen(initialNote: widget.note)));
              },
              child: Container(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      IconTheme(
                        data: IconThemeData(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: const Icon(
                          FeatherIcons.edit,
                          size: 20.0,
                        ),
                      ),
                      IconTheme(
                        data: IconThemeData(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black.withOpacity(.5)
                                  : Colors.white.withOpacity(.3),
                        ),
                        child: const Icon(
                          FeatherIcons.edit,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.1),
            child: GestureDetector(
              onTap: () async {
                // handle tap
                var notes = selfNoteProvider.notes;
                notes.removeWhere((e) => e.id == widget.note.id);
                await selfNoteProvider.store(notes);

                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: Container(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      IconTheme(
                        data: IconThemeData(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: const Icon(
                          FeatherIcons.trash2,
                          size: 20.0,
                        ),
                      ),
                      IconTheme(
                        data: IconThemeData(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black.withOpacity(.5)
                                  : Colors.white.withOpacity(.3),
                        ),
                        child: const Icon(
                          FeatherIcons.trash2,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
              Expanded(
                child: MarkdownBody(
                  data: widget.note.content,
                ),
              ),
              // Expanded(
              //   child: Text(
              //     widget.note.content,
              //     textAlign: TextAlign.justify,
              //     style: const TextStyle(fontSize: 18.0),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

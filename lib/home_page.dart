import 'package:db_exp_411/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  List<Map<String, dynamic>> notes = [];
  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.getInstance();
    getNotes();
  }

  void getNotes() async {
    notes = await dbHelper!.fetchAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: notes.isNotEmpty
          ? ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(notes[index][DBHelper.columnNoteTitle]),
                  subtitle: Text(notes[index][DBHelper.columnNoteDesc]),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            titleController.text =
                                notes[index][DBHelper.columnNoteTitle];
                            descController.text =
                                notes[index][DBHelper.columnNoteDesc];
                            showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              enableDrag: false,
                              builder: (_) {
                                return bottomSheetUI(
                                  isUpdate: true,
                                  id: notes[index][DBHelper.columnNoteId],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 30,
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Are you sure want to delete?',
                                        style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 11),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          OutlinedButton(
                                            onPressed: () async {
                                              bool check = await dbHelper!
                                                  .deleteNote(
                                                    id:
                                                        notes[index][DBHelper
                                                            .columnNoteId],
                                                  );

                                              if (check) {
                                                getNotes();
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Text(
                                              'Yes',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                color: Colors.red,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 11),
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                color: Colors.green,
                                                width: 2,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('No', style: TextStyle(color: Colors.green)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(child: Text('No Notes Yet!!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.text = "";
          descController.clear();
          showModalBottomSheet(
            context: context,
            isDismissible: false,
            enableDrag: false,
            builder: (_) {
              return bottomSheetUI();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget bottomSheetUI({bool isUpdate = false, int id = 0}) {
    return Container(
      padding: EdgeInsets.only(left: 11, right: 11, top: 11, bottom: 70),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${isUpdate ? "Update" : "Add"} Note",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Title",
              hintText: "Enter your title here..",
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: descController,
            minLines: 4,
            maxLines: 4,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
              labelText: "Desc",
              hintText: "Enter your desc here..",
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      descController.text.isNotEmpty) {
                    bool check = false;

                    if (isUpdate) {
                      check = await dbHelper!.updateNote(
                        updatedTitle: titleController.text,
                        updatedDesc: descController.text,
                        id: id,
                      );
                    } else {
                      check = await dbHelper!.addNote(
                        title: titleController.text,
                        desc: descController.text,
                      );
                    }
                    if (check) {
                      getNotes();
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text('Save'),
              ),
              SizedBox(width: 11),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

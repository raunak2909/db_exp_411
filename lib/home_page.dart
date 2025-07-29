import 'package:db_exp_411/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.getInstance();
    getNotes();
  }

  void getNotes() async{
    notes = await dbHelper!.fetchAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: notes.isNotEmpty ? ListView.builder(
          itemCount: notes.length,
          itemBuilder: (_, index){
        return ListTile(
          title: Text(notes[index]["n_title"]),
          subtitle: Text(notes[index]["n_desc"]),
        );
      }) : Center(
        child: Text('No Notes Yet!!'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        dbHelper!.addNote(title: "Life", desc: "Live Life King Size.");
        getNotes();
      }, child: Icon(Icons.add),),
    );
  }
}

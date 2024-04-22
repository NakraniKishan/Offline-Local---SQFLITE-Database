import 'package:flutter/material.dart';
import 'package:inappdatabase/screens/descriptionnote.dart';
import 'package:inappdatabase/services/NoteDbHelper.dart';

class NoteHomeUi extends StatefulWidget {
  @override
  State<NoteHomeUi> createState() => _NoteHomeUiState();
}

class _NoteHomeUiState extends State<NoteHomeUi> {
  // Insert Database

  insertdatabase(title, description) {
    NoteDbHelper.instance.insert({
      NoteDbHelper.coltitle: title,
      NoteDbHelper.coldescription: description,
      NoteDbHelper.coldate: DateTime.now().toString(),
      // NoteDbHelper.colid: snap.date[!index][NoteDbHelper.colid],
    });
  }

  updatedatabse(snap, index, title, description) {
    NoteDbHelper.instance.update({
      NoteDbHelper.coltitle: title,
      NoteDbHelper.coldescription: description,
      NoteDbHelper.coldate: DateTime.now().toString(),
      NoteDbHelper.colid: snap.data[!index][NoteDbHelper.colid],
    });
  }

  deletedatabse(snap, index) {
    NoteDbHelper.instance.delete(snap.data[!index][NoteDbHelper.colid]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Welcome"),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: FutureBuilder(
              future: NoteDbHelper.instance.queryAll(),
              builder:
                  (context, AsyncSnapshot<List<Map<String, dynamic>>> snap) {
                if (snap.hasData) {
                  return ListView.builder(
                      itemCount: snap.data!.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction){
                            deletedatabse(snap,index);
                            // Navigator.of(context).pop();
                          },
                          background: Container(
                            color: Colors.red,child: Icon(Icons.delete),
                          ),
                          child: Card(
                            child: ListTile(
                              onTap: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) { return descriptionnote(title : snap.data![index][NoteDbHelper.coltitle],description: snap.data![index][NoteDbHelper.coldescription]);})
                                );
                              },
                              leading: IconButton(
                                onPressed: () {

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        var title = '';
                                        var description = '';
                                        return AlertDialog(
                                          title: Text("Edit Note"),
                                          content: Column(
                                            children: [
                                              TextField(
                                                onChanged: (value) {
                                                  title = value;
                                                },
                                                decoration: InputDecoration(hintText: snap.data![index][NoteDbHelper.coltitle]),
                                              ),
                                              TextField(
                                                onChanged: (value) {
                                                  description = value;
                                                },
                                                decoration: InputDecoration(hintText: snap.data![index][NoteDbHelper.coldescription]),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Cancel")),
                                            TextButton(
                                                onPressed: () {
                                                  updatedatabse(snap, index,title, description);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Save")),
                                          ],
                                        );
                                      });

                                },
                                icon: Icon(Icons.edit),
                              ),
                              title:
                                  Text(snap.data![index][NoteDbHelper.coltitle]),
                              subtitle: Text(
                                  snap.data![index][NoteDbHelper.coldescription]),
                              trailing: Text(snap.data![index]
                                      [NoteDbHelper.coldate]
                                  .toString()
                                  .substring(0, 10)),
                            ),
                          ),
                        );
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  // play ram leela songs
                }
              },
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                var title = '';
                var description = '';
                return AlertDialog(
                  title: Text("Add Note"),
                  content: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          title = value;
                        },
                        decoration: InputDecoration(hintText: "Title"),
                      ),
                      TextField(
                        onChanged: (value) {
                          description = value;
                        },
                        decoration: InputDecoration(hintText: "Description"),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel")),
                    TextButton(
                        onPressed: () {
                          insertdatabase(title, description);
                          Navigator.of(context).pop();
                        },
                        child: Text("Save")),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

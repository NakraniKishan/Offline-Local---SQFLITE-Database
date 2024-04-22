import 'package:flutter/material.dart';
import 'package:inappdatabase/db_helper.dart';

class dashboard extends StatefulWidget {
  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;

  void _refereshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
    print(_allData);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refereshData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Future<void> _addData() async {
    await SQLHelper.createData(_titleController.text, _descController.text);
    _refereshData();
  }

  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(id, _titleController.text, _descController.text);
    _refereshData();
  }

  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red, content: Text("Data Deleted")));
    _refereshData();
  }

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descController.text = existingData['desc'];
    }

    showModalBottomSheet(
        elevation: 5,
        isScrollControlled: true,
        context: context,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 30,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Title",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Description",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await _addData();
                        }
                        if (id != null) {
                          await _updateData(id);
                        }
                        _titleController.text = "";
                        _descController.text = "";
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          id == null ? "Add Data" : "Update",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      )),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Offline / Local DB"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _allData.length,
              itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.all(15),
                    child: ListTile(
                      title: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          _allData[index]['title'],
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      subtitle: Text(
                        _allData[index]['desc'],
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showBottomSheet(_allData[index]['id']);
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              _deleteData(_allData[index]['id']);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: (() => showBottomSheet(null)),
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class descriptionnote extends StatefulWidget {
  var title;
  var description;

  descriptionnote({required this.title,required this.description});

  @override
  State<descriptionnote> createState() => _descriptionnoteState();
}

class _descriptionnoteState extends State<descriptionnote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Description"),
      ),

      body: Padding(
        padding:  EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(child: ListView.builder(itemBuilder: (context,index){
              return Card(
                child: ListTile(
                  title: Text(widget.title),
                  subtitle: Text(widget.description),
                ),

              );
            }))
          ],
        ),
      ),
    );
  }
}

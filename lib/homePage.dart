import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_database/boxes/boxes.dart';
import 'package:hive_database/model/notes_model.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController title_c = TextEditingController();
  TextEditingController description_c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showMyDialog();
          // var box = await Hive.openBox("Robi");
          // box.put("key", "value");
          // print(box.get("key"));
        },
        child: Icon(Icons.add),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (BuildContext context, value, Widget? child) {
          var data = value.values.toList().cast<NotesModel>();

          return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(data[index].title.toString()),
                    subtitle: Text(data[index].description.toString()),
                    leading: IconButton(
                        onPressed: () {
                          data[index].delete();
                        },
                        icon: Icon(Icons.delete)),
                    trailing: IconButton(
                        onPressed: () {
                          editMyDialog(data[index], data[index].title
                              .toString(), data[index].description.toString());
                        },
                        icon: Icon(Icons.edit)),
                  ),
                );
              });
        },
      ),
    );
  }

  Future<void> editMyDialog(NotesModel? nodesModel, String titleD,
      String desD) async {
    title_c.text = titleD;
    description_c.text = desD;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit Notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: title_c,
                    decoration: InputDecoration(
                        hintText: 'Enter title', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: description_c,
                    decoration: InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    nodesModel!.title=title_c.text.toString();
                    nodesModel!.description=description_c.text.toString();

                    nodesModel.save();
                    title_c.clear();
                    description_c.clear();

                    Navigator.pop(context);
                  },
                  child: Text("Edit"))
            ],
          );
        });
  }

  Future<void> showMyDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add Notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: title_c,
                    decoration: InputDecoration(
                        hintText: 'Enter title', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: description_c,
                    decoration: InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    final data = NotesModel(
                        title: title_c.text, description: description_c.text);
                    final box = Boxes.getData();
                    box.add(data);
                    data.save();
                    title_c.clear();
                    description_c.clear();
                    print(box);
                    Navigator.pop(context);
                  },
                  child: Text("Add"))
            ],
          );
        });
  }
}

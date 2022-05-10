// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:playamv/Models/tags.dart';
import 'package:playamv/utils/storage.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_tags/flutter_tags.dart';

class UploadWidget extends StatefulWidget {
  File file;
  String thumb;
  UploadWidget(this.file, this.thumb, {Key? key}) : super(key: key);

  @override
  State<UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  List<String> _list = [];

  late List _items;

  List<String> selectedTag = [];

  String title = "";

  String desc = "";
  @override
  void initState() {
    tags();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _items = _list.toList();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(
              File(this.widget.thumb),
              height: MediaQuery.of(context).size.height / 3,
            ).py24(),
            TextFormField(
              onChanged: ((value) {
                title = value;
              }),
              decoration:
                  InputDecoration(hintText: "Enter Title", labelText: "Title"),
            ),
            TextFormField(
              onChanged: (value) {
                desc = value;
              },
              decoration: InputDecoration(
                  hintText: "Enter Description", labelText: "Description"),
            ),
            ElevatedButton(
                    onPressed: () {
                      if (title.isNotBlank && title.isNotEmpty) {
                        if (desc.isNotBlank && desc.isNotEmpty) {
                          if (selectedTag.isNotEmpty) {
                            //Storage.update(widget.file, context);
                            Storage.upload(
                                widget.file, widget.thumb, selectedTag,title,desc,context);
                          } else {
                            _showToast(context, "Select Atleast One Tag");
                          }
                        } else {
                          _showToast(context, "Please Enter Description");
                        }
                      } else {
                        _showToast(context, "Please Enter Title");
                      }
                    },
                    child: "Upload".text.make())
                .py24(),
            _tags1.scrollHorizontal(),
            ValueListenableBuilder(
              //TODO 2nd: listen playerPointsToAdd
              valueListenable: Storage.x,
              builder: (context, value, widget) {
                //TODO here you can setState or whatever you need
                return double.parse(value.toString()) < 1.0
                    ? LinearProgressIndicator(
                        value: double.parse(value.toString()),
                      )
                    : Icon(Icons.done_outline);
              },
            ).py32(),
          ],
        ).pSymmetric(v: 16, h: 20),
      ),
    );
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg.toString()),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget get _tags1 {
    return this._list.isEmpty
        ? CircularProgressIndicator.adaptive()
        : Tags(
            //verticalDirection: VerticalDirection.up, textDirection: TextDirection.rtl,
            itemCount: _items.length,
            itemBuilder: (index) {
              final item = _items[index];

              return ItemTags(
                key: Key(index.toString()),
                index: index,
                title: item,
                pressEnabled: true,
                activeColor: Colors.blueGrey[600],
                splashColor: Colors.green,
                combine: ItemTagsCombine.withTextBefore,
                onPressed: (item) {
                  item.active
                      ? selectedTag.remove(item.title)
                      : selectedTag.add(item.title);
                },
              );
            },
          );
  }

  Future<void> tags() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("hashtags");
    var dataSnapshot = (await ref.once());
    Map<dynamic, dynamic> u =
        dataSnapshot.snapshot.value as Map<dynamic, dynamic>;
    this._list = Tag.fromJson(json.encode(u).toString()).tags;
    print(this._list);
    setState(() {});
  }
}

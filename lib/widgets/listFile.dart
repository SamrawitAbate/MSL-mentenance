// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:maintenance/services/database.dart';
import 'package:maintenance/widgets/loading.dart';

class ListFile extends StatefulWidget {
  const ListFile({Key? key, required this.dir}) : super(key: key);
  final String dir;

  @override
  State<ListFile> createState() => _ListFileState();
}

class _ListFileState extends State<ListFile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: listFiles(widget.dir),
        builder: (BuildContext context,
            AsyncSnapshot<firebase_storage.ListResult> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return ElevatedButton(
                      onLongPress: () => deleteFile(
                              snapshot.data!.items[index].name, widget.dir)
                          .then((value) => setState(() {})),
                      onPressed: () {},
                      child: Text(snapshot.data!.items[index].name));
                });
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Loading();
          }
          return Container();
        });
  }
}

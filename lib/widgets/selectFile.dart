// ignore_for_file: file_names

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/services/database.dart';

class ChangePhoto extends StatelessWidget {
  const ChangePhoto({
    Key? key,
    required this.url,
    required this.my,
  }) : super(key: key);

  final String url;
  final bool my;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundImage: NetworkImage(url),
        radius: 70.0,
        child: my
            ? Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black12,
                  ),
                  onPressed: () async {
                    final results = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: ['png', 'jpg']);
                    if (results == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No img selected')));
                      return;
                    }
                    final path = results.files.single.path;
                    uploadProfile(path!);
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text(''),
                ),
              )
            : Container());
  }
}

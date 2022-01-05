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
        backgroundImage: NetworkImage(
           url),
        radius: 70.0,
        child: my
            ? Align(
                alignment: Alignment
                    .bottomCenter,
                child:
                    ElevatedButton.icon(
                  style: ElevatedButton
                      .styleFrom(
                    primary:
                        Colors.black12,
                  ),
                  onPressed: () async {
                    final results = await FilePicker
                        .platform
                        .pickFiles(
                            allowMultiple:
                                false,
                            type: FileType
                                .custom,
                            allowedExtensions: [
                          'png',
                          'jpg'
                        ]);
                    if (results == null) {
                      ScaffoldMessenger
                              .of(context)
                          .showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('No img selected')));
                      return null;
                    }
                    final path = results
                        .files
                        .single
                        .path;
                    final fileName =
                        results.files
                            .single.name;
                    print(path);
                    print(fileName);
                    uploadProfile(path!)
                        .then((value) =>
                            print(
                                'Done ' *
                                    10));
                  },
                  icon: const Icon(Icons
                      .camera_alt_outlined),
                  label: const Text(''),
                ),
              )
            : Container());
  }
}

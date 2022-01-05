import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/services/database.dart';

class AddFile extends StatelessWidget {
  const AddFile({
    Key? key,
    required this.dir,
  }) : super(key: key);

  final String dir;

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.black12,
          ),
          onPressed: () async {
            final results = await FilePicker.platform.pickFiles(
                allowMultiple: false,
                type: FileType.custom,
                allowedExtensions: ['png', 'jpg','png']);
            if (results == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No File selected')));
              return;
            }
            final path = results.files.single.path;
            final fileName = results.files.single.name;
            print(path);
            print(fileName);
            uploadFile(path!,fileName,dir).then((value) => print('Done ' * 10));
          },
    
          child: const Text('Upload'),
        );
  }
}

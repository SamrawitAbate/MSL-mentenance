// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/services/database.dart';

class LicenseUpload extends StatefulWidget {
  const LicenseUpload({Key? key}) : super(key: key);

  @override
  State<LicenseUpload> createState() => _LicenseUploadState();
}

class _LicenseUploadState extends State<LicenseUpload> {
  String dayLeft = '';
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('license')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var t = value.data();
      Timestamp ts = t!['useTo'];
      if (ts.compareTo(Timestamp.now()) > 0) {
        String aa = '${ts.toDate().toLocal()}';
        setState(() {
          dayLeft = 'You can use the application\n up to ${aa.split(' ')[0]}';
        });
      } else {
        setState(() {
          dayLeft = 'Pay to use the application';
        });
      }
    }).onError((error, stackTrace) {
      setState(() {
        dayLeft = error.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            dayLeft,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25),
          ),
          const Text(
              'Deposit or Transfer Slip must be with \nyour namme and phone number'),
          const SelectableText('CBE account number is \n 1000012586248'),
          const ListTile(
            title: Text('Monthly'),
            subtitle: Text('60 Birr'),
          ),
          const ListTile(
            title: Text('Half year'),
            subtitle: Text('300 Birr'),
          ),
          const ListTile(
            title: Text('Yearly'),
            subtitle: Text('500 Birr'),
          ),
          const Divider(),
          ListTile(
            tileColor: Colors.green,
            title: const Text('Upload Deposit Slip here'),
            subtitle: const Text(''),
            onTap: () async {
              final results = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ['png', 'jpg']);
              if (results == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No file selected')));
                return;
              }
              final path = results.files.single.path;
              uploadDepositSlip(path!);
            },
          ),
        ],
      ),
    );
  }
}

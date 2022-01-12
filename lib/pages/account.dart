import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/services/database.dart';
import 'package:maintenance/services/uploadFile.dart';
import 'package:maintenance/widgets/listFile.dart';
import 'package:maintenance/widgets/loading.dart';
import 'package:maintenance/widgets/selectFile.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  String fullName = '',
      email = '',
      sex = '',
      address = '',
      dateOfBirth = '',
      password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('account')
              .doc(uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error = ${snapshot.error}');

            if (snapshot.hasData) {
              var data = snapshot.data!;
              return Center(
                child: Form(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                      ),
                      const SizedBox(height: 20),
                      const Text('Account'),
                      Center(
                          child: ChangePhoto(url: data['photoUrl'], my: true)),
                      TextFormField(
                        initialValue: data['fullName'] ?? '',
                        onChanged: (v) {
                          setState(() {
                            fullName = v;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                        ),
                      ),
                      TextFormField(
                        initialValue: data['email'] ?? '',
                        onChanged: (v) {
                          setState(() {
                            email = v;
                          });
                        },
                        decoration: const InputDecoration(labelText: 'email'),
                      ),
                      Row(
                        children: [
                          const Text('phone number'),
                          Text(data['phoneNumber']),
                        ],
                      ),
                      TextFormField(
                        initialValue: data['address'] ?? '',
                        decoration: const InputDecoration(labelText: 'Address'),
                        onChanged: (v) {
                          setState(() {
                            address = v;
                          });
                        },
                      ),
                      addList('Certificate', 'certificate'),
                      addList('Education Background', 'educationBackground'),
                      addList('Reference Material', 'referenceMaterial'),
                      ElevatedButton(
                          onPressed: () {
                            userSetup(
                                fullName, email, address, dateOfBirth, sex);
                          },
                          child: const Text('update'))
                    ],
                  ),
                )),
              );
            }

            return const Loading();
          }),
    );
  }

  Column addList(String lable, String value) {
    return Column(
      children: [
        Text(lable),
        AddFile(dir: value),
        ListFile(dir: value),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/pages/account.dart';
import 'package:maintenance/pages/login.dart';
import 'package:maintenance/pages/mainPage.dart';
import 'package:maintenance/widgets/loading.dart';

class Autenticate extends StatelessWidget {
  const Autenticate({Key? key}) : super(key: key);

  Future<bool> active() async {
    final value = await FirebaseFirestore.instance
        .collection('maintenanceDetail')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return value.data()!["active"];
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return FutureBuilder<bool>(
          future: active(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasError) {
              return  Scaffold(body: Center(child: Text('Error ...${snapshot.error}')));
            }
            if (snapshot.hasData) {
              return snapshot.data! ? const MainPage() : const AccountPage();
            }
            return const Loading();
          });
    }
    return const Login();
  }
}

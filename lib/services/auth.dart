import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/pages/account.dart';
import 'package:maintenance/pages/disablePage.dart';
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

   Future<bool> disable() async {
    final value = await FirebaseFirestore.instance
        .collection('maintenanceDetail')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return value.data()!["disable"];
  }
 
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return FutureBuilder<bool>(
        future: disable(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
           if (snapshot.hasError) {
              return Scaffold(
                  body: Center(child: Text('Error ...${snapshot.error}')));
            }
            if (snapshot.hasData) {
              return snapshot.data! ? const DisablePage() : 
           FutureBuilder<bool>(
              future: active(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot2) {
                if (snapshot2.hasError) {
                  return  Scaffold(body: Center(child: Text('Error ...${snapshot2.error}')));
                }
                if (snapshot2.hasData) {
                  return snapshot2.data! ? const MainPage() : const AccountPage();
                }
                return const Loading();
              });
            }
            return const Loading();
        }
      );
    }
    return const Login();
  }
}

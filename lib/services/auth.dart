import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/pages/account.dart';
import 'package:maintenance/pages/disablePage.dart';
import 'package:maintenance/pages/licenseUpload.dart';
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
           
           
            if (snapshot.hasData) {
              return snapshot.data!
                  ? const DisablePage()
                  : FutureBuilder<bool>(
                      future: active(),
                      builder: (BuildContext context,
                          AsyncSnapshot<bool> snapshot2) {
                      
                        if (snapshot2.hasData) {
                          if (snapshot2.data!) {
                              return FutureBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              future: FirebaseFirestore.instance
                                  .collection('license')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshotLic) {
                                if (snapshotLic.hasData) {
                                  Timestamp a = snapshotLic.data['useTo'];
                                  DateTime useTo = a.toDate();
                                  if (useTo.isBefore(DateTime.now())) {
                                    return const LicenseUpload();
                                  } else {
                                    return const MainPage();
                                  }
                                }
                            
                                return const Loading();
                              },
                            );
                          } else {
                            return const AccountPage();
                          }
                        }
                        return const Loading();
                      });
            }
            return const Loading();
          });
    }
    return const Login();
  }
}

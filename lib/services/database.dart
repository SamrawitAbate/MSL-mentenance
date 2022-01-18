import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;
FirebaseAuth auth = FirebaseAuth.instance;
String uid = auth.currentUser!.uid;

Future<void> uploadProfile(String filepath) async {
  CollectionReference users = FirebaseFirestore.instance.collection('account');
  File file = File(filepath);
  try {
    await storage.ref('img/$uid').putFile(file);
    String url = await storage.ref('img/$uid').getDownloadURL();

    users.doc(uid).update({'photoUrl': url});
  } catch (e) {
    debugPrint(e.toString());
    throw Exception(e);
  }
}

Future<bool> userSetup(
    {required bool otp,
    String? fullName,
    String? email,
    String? address,
    Timestamp? dateOfBirth,
    String? sex,
    String? skill}) async {
  CollectionReference users = FirebaseFirestore.instance.collection('account');
  CollectionReference mentenance =
      FirebaseFirestore.instance.collection('maintenanceDetail');

  final snapShot = await FirebaseFirestore.instance
      .collection('account')
      .doc(uid) // varuId in your case
      .get();

  CollectionReference rate = FirebaseFirestore.instance.collection('rate');

  if (otp) {
    if (!snapShot.exists) {
      try {
        mentenance.doc(uid).set({
          'active': false,
          'disable': false,
          'skill': '',
          'registeredDate': Timestamp.now()
        });
        rate.doc(uid).set({'value': 0, 'count': 0, 'rate': 0});
        users.doc(uid).set({
          'fullName': '',
          'phoneNumber': FirebaseAuth.instance.currentUser!.phoneNumber,
          'address': '',
          'photoUrl':
              'https://firebasestorage.googleapis.com/v0/b/maintenance-service-locator.appspot.com/o/img%2Favatar.png?alt=media&token=b5bd012f-d7eb-445a-a9ce-fe192b21cfeb',
          'email': '',
          'dateOfBirth': Timestamp.fromDate(DateTime(1000, 10, 10)),
          'sex': ''
        }).then((value) {
          return true;
        }).onError((error, stackTrace) {
          debugPrint(error.toString());
          return false;
        });
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    }
  } else {
    if (dateOfBirth != Timestamp.fromDate(DateTime(1000, 10, 10))) {
      users.doc(uid).update({'dateOfBirth': dateOfBirth});
    }
    if (sex != '') {
      users.doc(uid).update({'sex': sex});
    }
    if (skill != '') {
      mentenance.doc(uid).update({'slill': skill});
    }
    if (fullName != '') {
      users.doc(uid).update({'fullName': fullName});
    }
    if (address != '') {
      users.doc(uid).update({'address': address});
    }
    if (email != '') {
      users.doc(uid).update({'email': email});
    }
    return true;
  }
  return false;
}

Future<void> addLocation2(GeoPoint myLocation) async {
  CollectionReference maintenanceLocations =
      FirebaseFirestore.instance.collection('maintenanceLocations');

  DocumentSnapshot<Map<String, dynamic>> a =
      await FirebaseFirestore.instance.collection('account').doc(uid).get();
  maintenanceLocations.doc(uid).set({
    // maintenanceLocations.add({
    'location': myLocation,
    'skill': '',
    'name': a['fullName'],
    'lastLocation': Timestamp.now(),
    'distance': 0
  }).then((_) {
    debugPrint('added $myLocation successfully');
  });
}

Stream<QuerySnapshot> select(String status) {
  Stream<QuerySnapshot> activity = FirebaseFirestore.instance
      .collection('activity')
      .where('skill_id', isEqualTo: uid)
      .where('status', isEqualTo: status)
      .snapshots();
  return activity;
}

Future<void> giveComment(String message, String to) async {
  CollectionReference comment =
      FirebaseFirestore.instance.collection('comment');
  comment.add({
    'from': uid,
    'to': to,
    'message': message,
    'time': Timestamp.now()
  }).then((_) {
    debugPrint('comment added successfully');
  });
}

Future<void> giveComplain(String message, String to) async {
  CollectionReference complain =
      FirebaseFirestore.instance.collection('complain');
  complain.add({
    'from': uid,
    'to': to,
    'message': message,
    'time': Timestamp.now(),
    'who': 'User'
  }).then((_) {
    debugPrint('comment added successfully');
  });
}

Future<void> setRating(double v, String to) async {
  CollectionReference rate = FirebaseFirestore.instance.collection('rate');
  double? value;
  int? count;
  rate.doc(uid).get().then((va) {
    value = va['value'] + v;
    count = va['count'] + 1;
  });
  rate.doc(to).update(
      {'value': value, 'count': count, 'rate': (value! / count!)}).then((_) {
    debugPrint('rate added successfully');
  });
}

Future<void> changeStatus(String id, String status) async {
  CollectionReference rate = FirebaseFirestore.instance.collection('activity');

  rate.doc(id).update({
    'status': status,
  }).then((_) {
    debugPrint('status changed successfully');
  });
}

Future<void> uploadFile(String filepath, String filename, String dir) async {
  File file = File(filepath);
  try {
    await storage.ref('$dir/$uid/$filename').putFile(file);
  } catch (e) {
    debugPrint(e.toString());
    throw Exception(e);
  }
}

Future<void> deleteFile(String filename, String dir) async {
  try {
    await storage.ref('$dir/$uid/$filename').delete();
  } catch (e) {
    debugPrint(e.toString());
    throw Exception(e);
  }
}

Future<firebase_storage.ListResult> listFiles(String dir) async {
  firebase_storage.ListResult result = await storage.ref('$dir/$uid').listAll();
  result.items.forEach((firebase_storage.Reference ref) {
    print('Found $ref');
  });
  return result;
}

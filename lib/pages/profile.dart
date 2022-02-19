import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/pages/account.dart';
import 'package:maintenance/widgets/listFile.dart';
import 'package:maintenance/widgets/loading.dart';
import 'package:maintenance/widgets/ratingBarView.dart';
import 'package:maintenance/widgets/selectFile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {required this.my, required this.uid, required this.user, Key? key})
      : super(key: key);
  final bool my, user;
  final String uid;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Stream<QuerySnapshot>? comment;

  @override
  void initState() {
    super.initState();
    comment = FirebaseFirestore.instance
        .collection('comment')
        .where('reciver_uid', isEqualTo: widget.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: widget.my ? null : AppBar(),
          body: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('account')
                  .doc(widget.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return Center(
                      child: Row(
                    children: [
                      const Icon(Icons.error),
                      Text(snapshot.error.toString(), maxLines: 3)
                    ],
                  ));
                }
                if (snapshot.hasData) {
                  var data = snapshot.data!;
                  Timestamp t = data['dateOfBirth'] as Timestamp;
                  bool empty = t == Timestamp.fromDate(DateTime(1000, 10, 10))
                      ? true
                      : false;
                  DateTime ts = t.toDate();
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10.0,
                                ),
                                ChangePhoto(
                                    url: data['photoUrl'], my: widget.my),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  data['fullName'],
                                  style: const TextStyle(
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                RatingBarCustom(
                                  to: widget.uid,
                                  other: false,
                                ),
                              ],
                            ),
                            const Divider(),
                            newMethod(
                                'Phone Number:', data['phoneNumber'] ?? ''),
                            newMethod('Email:', data['email']),
                            newMethod('Address:', data['address']),
                            newMethod('Gender:', data['sex']),
                            newMethod('Birthday:',
                                empty ? '' : "${ts.toLocal()}".split(' ')[0]),
                            widget.user
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Divider(),
                                        addList('Certificate', 'certificate'),
                                        const Divider(),
                                        addList('Education Background',
                                            'educationBackground'),
                                        const Divider(),
                                        addList('Reference Material',
                                            'referenceMaterial'),
                                      ],
                                    ),
                                  ),
                            const Divider(),
                            const Text(
                              "Comments:",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 28.0),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: comment,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    debugPrint(snapshot.error.toString());
                                    return Center(
                                        child: Row(
                                      children: [
                                        const Icon(Icons.error),
                                        Text(snapshot.error.toString(),
                                            maxLines: 3)
                                      ],
                                    ));
                                  }
                                  if (snapshot.hasData) {
                                    final List<DocumentSnapshot> documents =
                                        snapshot.data!.docs;
                                    if (documents.isEmpty) {
                                      return const Center(
                                        child: Text('No Comment..'),
                                      );
                                    }
                                    return ListView.builder(
                                        itemBuilder: (_, index) {
                                      return ListTile(
                                        title: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            documents[index]['name'],
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        subtitle: Text(
                                          documents[index]['message'],
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      );
                                    });
                                  }
                                  return const Loading();
                                }),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                      widget.my
                          ? Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AccountPage())),
                              ),
                            )
                          : const SizedBox()
                    ],
                  );
                }
                return const Loading();
              })),
    );
  }

  Wrap newMethod(String a, String b) {
    return Wrap(
      children: [
        _titleBuild(a),
        a == 'Phone Number:'
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  b,
                  style: const TextStyle(
                      fontStyle: FontStyle.normal, fontSize: 20.0),
                ))
            : _titleBuild(b),
      ],
    );
  }

  Column addList(String lable, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          lable,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        ListFile(dir: value),
      ],
    );
  }

  Padding _titleBuild(String title) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          title,
          style: const TextStyle(fontStyle: FontStyle.normal, fontSize: 20.0),
        ));
  }
}

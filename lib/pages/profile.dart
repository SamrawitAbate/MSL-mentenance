import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/pages/account.dart';
import 'package:maintenance/widgets/loading.dart';
import 'package:maintenance/widgets/ratingBarView.dart';
import 'package:maintenance/widgets/selectFile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.my, required this.uid, Key? key})
      : super(key: key);
  final bool my;
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
                  .collection('Users')
                  .doc(widget.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) return Text('Error = ${snapshot.error}');

                if (snapshot.hasData) {
                  var data = snapshot.data!;
                  Timestamp ts = data['dateOfBirth'] as Timestamp;
                  bool empty = ts == Timestamp.fromDate(DateTime(1000, 10, 10))
                      ? true
                      : false;
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Colors.black87,
                                  Colors.black12,
                                ])),
                            child: Stack(
                              children: [
                               SizedBox(
                                  width: double.infinity,
                                  height: 250.0,
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          ChangePhoto(url:  data['photoUrl'], my: widget.my),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            data['fullName'],
                                            style: const TextStyle(
                                              fontSize: 22.0,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          RatingBarCustom(to: widget.uid)
                                        ],
                                      ),
                                    ),
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
                                          onPressed: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AccountPage())),
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            )),
                        SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                newMethod(
                                    'Phone Number:', data['phoneNumber'] ?? ''),
                                newMethod('Email:', data['email']),
                                newMethod('Address:', data['address']),
                                newMethod('Gender:', data['sex']),
                                newMethod('Birthday:',
                                    empty ? '' : ts.toDate().toString())
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
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
                              SizedBox(
                                  height: 300,
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: comment,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                        }
                                        if (!snapshot.hasData) {
                                          return const Loading();
                                        }
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                documents[index]['name'],
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w700),
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
                                      }))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  );
                }
                return const Loading();
              })),
    );
  }

  Row newMethod(String a, String b) {
    return Row(
      children: [
        _titleBuild(a),
        _titleBuild(b),
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

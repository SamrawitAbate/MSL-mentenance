import 'package:flutter/material.dart';

class TestD extends StatefulWidget {
const  TestD({Key? key}) : super(key: key);

  @override
  _TestDState createState() => _TestDState();
}

class _TestDState extends State<TestD> {
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         const SizedBox(
            height: 200,
          ),
          Text(date.toString()),
          OutlinedButton(
            onPressed: () async {
              await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now())
                  .then((value) {
                if (value != null && value != date) {
                  setState(() {
                    date = value;
                  });
                }
              });
            },
            child: const Text(
              'Select date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:maintenance/services/database.dart';

popUp(
  BuildContext context,
  String lable, {
  required String id,
}) {
  String value;
  bool onPressed = false;
  TextEditingController valueController = TextEditingController();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: valueController,
                    decoration: InputDecoration(labelText: lable),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text("Send"),
                    onPressed: () {
                     if(lable=='Complain'){
                       giveComplain(valueController.text, id);
                     }
                     if(lable=='Comment'){
                       giveComment(valueController.text, id);
                     }
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      });
  
  return;
}

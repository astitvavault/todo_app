import 'package:flutter/material.dart';
import 'my_button.dart';

class DialogBox extends StatefulWidget {
  final controller;

  final void Function(bool isHighPriority, String timerText) onSave;
  VoidCallback onCancel;

  DialogBox({super.key, required this.controller, required this.onSave, required this.onCancel});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  bool isHighPriority = false;
  TextEditingController timerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey,
      content: Container(
        height: 250,
        width: 300,
        child: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            SizedBox(height: 10,),
            TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter New Task"
              ),
            ),
            SizedBox(height: 10,),
            CheckboxListTile(
                value: isHighPriority,
                title: Text("High Priority",
                style: TextStyle(color: Colors.white),),

                onChanged: (value) {
                  setState(() {
                    isHighPriority = value!;
                  });
                }),
            if(isHighPriority)
              TextField(
                controller:  timerController,
                decoration: InputDecoration(labelText: "Timer (minutes)",
                labelStyle:  TextStyle(color: Colors.white)
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
              ),

            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyButton(text: "Save", onPressed: () {
                  widget.onSave(isHighPriority, timerController.text.trim());
                }),
                SizedBox(width: 50,),
                MyButton(text: "Cancel", onPressed: widget.onCancel),
              ],

            )
          ],),
        ),
      ),
    );
  }
}

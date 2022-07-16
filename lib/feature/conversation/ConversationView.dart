import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mypubnub/helper/PubnubHelper.dart';

class ConversationView extends StatefulWidget {
  const ConversationView({Key key}) : super(key: key);

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  PubnubHelper pubnubHelper = Get.put(PubnubHelper());
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pubnubHelper.configure();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<PubnubHelper>(
      builder: (controller) {
        return Container(
            child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (ctx, idx) {
                  var data = controller.messages[idx];

                  return ListTile(
                    title: Text(data.toString()),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 0, right: 32),
              child: Row(
                children: <Widget>[
                  // Button send image
                  Material(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => {print("press")},
                      ),
                    ),
                    color: Colors.white,
                  ),
                  // Edit text
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.circular(8)),
                      child: TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        onFieldSubmitted: (value) {
                          // onSendMessage(textEditingController.text, 0);

                          controller.sendMessage(value);
                          editingController.text = "";
                        },
                        style: TextStyle(color: Colors.black54, fontSize: 15.0),
                        controller: editingController,
                        decoration: InputDecoration.collapsed(
                          hintText: "type here",
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                        // focusNode: focusNode,
                      ),
                    ),
                  ),
                ],
              ),
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey[200], width: 0.5)),
                  color: Colors.white),
            )
          ],
        ));
      },
    ));
  }
}

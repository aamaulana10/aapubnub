import 'package:flutter/material.dart';
import 'package:mypubnub/feature/conversation/ConversationView.dart';
import 'package:mypubnub/helper/PubnubHelper.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await PubnubHelper().configure();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConversationView(),
    );
  }
}


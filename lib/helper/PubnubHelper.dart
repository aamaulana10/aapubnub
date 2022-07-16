import 'dart:async';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pubnub/networking.dart';
import 'package:pubnub/pubnub.dart';

class PubnubHelper extends GetxController {
  PubNub pubnub;
  Subscription subscription;
  Subscription messageSub;

  static Timer _heartbeatTimer;

  List messages = [];

  var myChannel = "my_channel";

  configure() async {
    try {
      pubnub = PubNub(
          networking: NetworkingModule(retryPolicy: RetryPolicy.exponential()),
          defaultKeyset: Keyset(
              subscribeKey: "sub-c-ac64cebb-5321-4dc7-abac-705c745dcbc6",
              publishKey: "pub-c-6030a0fe-2583-4692-9c7f-de06bd9f7d74",
              userId: UserId("aamaulana10")
          ));

      subscription = pubnub.subscribe(channels: {myChannel}, withPresence: true);

      var message1 = await pubnub.batch.fetchMessages({myChannel},
        count: 100,
        includeMessageActions: true,
        includeMeta: true,
      );

      message1.channels.forEach((key, value) {

        print("key ${key}");
        value.forEach((element) {

          print(element.message);
          messages.add(element.message.toString());
        });
      });

      subscription.messages.listen((event) {
        print("new listen");
        if(event.channel == "my_channel") {

          print(event.content);
          messages.add(event.content.toString());

          update();
        }

      });

    } catch (e) {
      print(e.toString());
    }

    subscription.resume();

    startHeartbeats();

    update();
  }

  sendMessage(String newMessage) async{
    print(newMessage);
    try {
      var result = await pubnub.publish(myChannel, newMessage);

      print(result.description);
    }catch(e) {

      print("send message");
      print(e.toString());
    }
  }

  startHeartbeats() {
    if (_heartbeatTimer == null)
      _heartbeatTimer = Timer.periodic(Duration(seconds: 10), _heartbeatCall);
  }

  dispose() async {
    stopHeartbeats();
    await pubnub.announceLeave(channels: {myChannel});
    if (!subscription.isCancelled) await subscription.cancel();
  }

  stopHeartbeats() {
    if (_heartbeatTimer != null && _heartbeatTimer.isActive) {
      _heartbeatTimer.cancel();
      _heartbeatTimer = null;
    }
  }

  Future<void> _heartbeatCall(Timer timer) async {
    print("heart beat call");
    await pubnub.announceHeartbeat(channels: {myChannel});
  }

  void announceLeave() async =>
      await pubnub.announceLeave(channels: {myChannel});

  void resume() => subscription.resume();
}

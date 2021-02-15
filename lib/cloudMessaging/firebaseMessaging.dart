import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as localNotify;
import 'package:http/http.dart' as http;
// import 'package:trustGroup_app/chatPage.dart';
// import 'package:trustGroup_app/cloudMessaging/message.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:toast/toast.dart';

import '../FragmentNavigation.dart';
import 'message.dart';
import 'messaging.dart';
// import 'navigatorService.dart';

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  String token;

  // NavigationService navigationService = new NavigationService();
  final TextEditingController titleController =
      TextEditingController(text: 'Title');
  final TextEditingController bodyController =
      TextEditingController(text: 'Body123');


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];
  localNotify.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      localNotify.FlutterLocalNotificationsPlugin();
  final String serverToken =
      'AAAAdGCnXb0:APA91bH3NxBGCLtotEOYByKD7jNSNxs6oNd0BpLrlHla6hOV4_1aLvIOBZnkEXUln2zG4robwhBgUbCrZdHnpgXMOUgbSqQMTy1yIWFMP8so7HUudDrQjIyKjdqSoaGci1gOxQKfAwk8';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
// localNotify.NotificationAppLaunchDetails flutterLocalNotificationsPlugin;
  List<String> tokens = [
    "ePWJwkPAe8c:APA91bH_K-90Rm_HfntK3P3m6BzoVXwpE1FPDUC65lKesvw13HvSNY4ClUqRmCDbcIHAy10lN97cLg6Xt-MZ6dKkaU6AoIiszN7JcGKo5GKVPufl0d2BwAhSxBGCY3Yp5jVQUvxHhAdr"
    //"edKfRBp4W2E:APA91bHtZlC0eWfJqxacSJNOFZCw3Tus__pe6HoWXJlizU5deQ0DlbZ2GkP7mFsWlJcBYE-Xtgls9z5XWUCP7CdwJF-ZcFqc-rMQlonJHms4HmSmEX6d-PrC6b1_EGpUQ9l5xsObDBTo"
  ];
  @override
  void initState() {
    super.initState();

    // _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    _firebaseMessaging.getToken().then((value) {
      setState(() {
        token = value;
      });
      print("token: $token");
    });

    // _firebaseMessaging.subscribeToTopic('all');

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("kkkonMessage: $message");
        final notification = message['notification'];
        final data = message['data'];
        print("uuu1${data['id']}///${notification['title']}");

        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });
      //  print("uuu1${data['id']}///${notification['title']}");
        await _showNotification();
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("kkkonLaunch: $message");
        final notification = message['notification'];
        final data = message['data'];
        print("uuu2${data['id']}///${notification['title']}");
       // final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });
        // await _showNotification();
        //////////////////////////////////////
        // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> new FragmentPriceMe()));
      },
      onResume: (Map<String, dynamic> message) async {
        print("kkonResume: $message");
        final notification = message['notification'];
        final data = message['data'];
        print("uuu3${data['id']}///${notification['title']}");
        setState(() {
          messages.add(Message(
            title: '${message['title']}',
            body: '${message['body']}',
          ));
        });
        await _showNotification();
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    localNotificationInitialize();
  }

  // Future selectNotification(String payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: gggg' + payload);
  //      Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => FragmentPriceMe()),);
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: bodyController,
              decoration: InputDecoration(labelText: 'Body'),
            ),
            RaisedButton(
              onPressed: sendAndRetrieveMessage,
              child: Text('Send notification to all'),
            ),
          ]..addAll(messages.map(buildMessage).toList()),
        ),
      );

  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );

  // Future sendNotification() async {
  //   final response = await Messaging.sendToAll(
  //     title: titleController.text,
  //     body: bodyController.text,
  //     // fcmToken: fcmToken,
  //   );
  //
  //   if (response.statusCode != 200) {
  //     Toast.show(
  //         '[${response.statusCode}] Error message: ${response.body}', context,
  //         duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
  //   }
  // }

  // void sendTokenToServer(String fcmToken) {
  //   print('Token: $fcmToken');
  //   // send key to your server to allow server to use
  //   // this token to send push notifications
  // }

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );
    // _firebaseMessaging.subscribeToTopic("all");
    for (int i = 0; i < tokens.length; i++) {
      await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': bodyController.text,
              'title': titleController.text
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': tokens[i],
          },
        ),
      );
    }

    //   await http.post(
    //     'https://fcm.googleapis.com/fcm/notification',
    //     headers: <String, String>{
    //       'Content-Type': 'application/json',
    //       'Authorization': 'key=$serverToken',
    //       "project_id":
    //           "eR5NEalZ2rs:APA91bHLcivHpNX7ktKkXt8zJTEM0_ls6EhMpSTEnvhiONFs3zNIRVUNNVja1t98HD9tiOKhSEv5MNJ0J9tdGHfcVHroJ7l2T9eS_W-k8ZkXWQ0RRMa8eePW1AdZfuJaeGfVFtvdyjhC"
    //     },
    //     body: jsonEncode(
    //       <String, dynamic>{
    //         'notification': <String, dynamic>{
    //           'body': bodyController.text,
    //           'title': titleController.text
    //         },
    //         "operation": "create",
    //  "notification_key_name": "appUser-Chris",
    //         // 'priority': 'high',
    //         // 'data': <String, dynamic>{
    //         //   'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    //         //   'id': '1',
    //         //   'status': 'done'
    //         // },
    //         "registration_ids": [token]
    //         // 'to': token,
    //       },
    //     ),
    //   );
    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onLaunch:  (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });
        await _showNotification();
        // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> new Splash()));
      },
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
        await _showNotification();
      },
    );

    return completer.future;
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
            //  Navigator.of(context, rootNavigator: true).pop();
              // await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SecondScreen(payload),
              //   ),
              // );
            },
          )
        ],
      ),
    );
  }

  void localNotificationInitialize() async {
    localNotify.FlutterLocalNotificationsPlugin
        flutterLocalNotificationsPlugin =
        localNotify.FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        localNotify.AndroidInitializationSettings(
            'icon1'); // <- default icon name is @mipmap/ic_launcher
    var initializationSettingsIOS = localNotify.IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = localNotify.InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FragmentPriceMe()),);
      }
      // selectNotificationSubject.add(payload);
    });
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics =
        localNotify.AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: localNotify.Importance.Max,
            priority: localNotify.Priority.High,
            ticker: 'ticker');
    var iOSPlatformChannelSpecifics = localNotify.IOSNotificationDetails();
    var platformChannelSpecifics = localNotify.NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    setState(() {
      messages
          .add(Message(title: titleController.text, body: bodyController.text));
    });

    await flutterLocalNotificationsPlugin.show(
        0, titleController.text, bodyController.text, platformChannelSpecifics,
        payload: 'x');
  }

//   sendNotificationDaily() async{
//     var time = localNotify.Time(10, 0, 0);
// var androidPlatformChannelSpecifics =
//     localNotify.AndroidNotificationDetails('repeatDailyAtTime channel id',
//         'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
// var iOSPlatformChannelSpecifics =
//     localNotify.IOSNotificationDetails();
// var platformChannelSpecifics = localNotify.NotificationDetails(
//     androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
// await flutterLocalNotificationsPlugin.showDailyAtTime(
//     0,
//     'show daily title',
//     'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
//     time,
//     platformChannelSpecifics);
//   }
}

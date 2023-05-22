import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendNotificationScreen extends StatefulWidget {
  const SendNotificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SendNotificationScreen> createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  late final TextEditingController title;
  late final TextEditingController body;

  @override
  void initState() {
    title = TextEditingController();
    body = TextEditingController();
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Notification to device'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  key: UniqueKey(),
                  keyboardType: TextInputType.text,
                  controller: title,
                  decoration: InputDecoration(
                    labelText: 'Enter Notification Title',
                    hintText: 'Your title',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  key: UniqueKey(),
                  keyboardType: TextInputType.text,
                  controller: body,
                  decoration: InputDecoration(
                    labelText: 'Enter Notification body',
                    hintText: 'Your body',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  maxLines: 3,
                ),
              ),
  
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          String titleText = title.text.trim();
                          String bodyText = body.text.trim();

                          if(titleText != "" && bodyText != "") {
                            sendPushMessage(
                              'dhrQv2p-SfmO7sj66DOsCQ:APA91bFW3gkg2BfBjkbVm-q0E9lRw6CsoSnHTx8rVCeoN4Utdya7wksq_ArQ-PP2G77I-bnC3wgxPc8eBWOhOkaUpuw6jn5E5DwBjT2dfyh3IxpwsduI3zE4VWu8QZ6HOFZsChA7lg09',
                              titleText, 
                              bodyText);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                elevation: 3,
                                content: Text("Successfully send", textAlign: TextAlign.center),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                elevation: 3,
                                content: Text("Title cannot null", textAlign: TextAlign.center),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        child: const Text('Send Notifications'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAYcwjaWU:APA91bFBASGDeIqecWFcujKgkzxUzrwVPTfax7OGEfnvBu66oEtlWgZlVFU3TiwHRLMyIYxYlObj6Oj95BcXChK2eM2Pp3zyMEuMP6Y8c3N_SpefJGYBdTj9eayl4Wbd0_jTOjGlYJL1'
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic> {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            "notification" : <String, dynamic> {
              "title" : title,
              "body" : body,
              "android channel id" : "hello",
            },
            "to": token,
          }
        ),
      );
    } catch (e) {
      if(kDebugMode) {
        print("Error push notification");
      }
    }
  }
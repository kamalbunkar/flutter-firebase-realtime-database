import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_firebase_noti/realtime_db.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


/*
Name:firenoti
Key ID:S5DW64R383


*/
/* ---------firebase notification start
/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel channel =  AndroidNotificationChannel(
'high_importance_channel', // id
'High Importance Notifications', // title
'This channel is used for important notifications.', // description
importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

GlobalKey<NavigatorState> navikey = GlobalKey<NavigatorState>();

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  AndroidInitializationSettings initAndroid = AndroidInitializationSettings("noti_icon");
  IOSInitializationSettings iosSetting = IOSInitializationSettings();
  InitializationSettings initializationSettings = InitializationSettings(android: initAndroid, iOS: iosSetting);

  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async{
          print(" firebase noti click paload "+ payload.toString());
          Navigator.push( navikey.currentState!.context, MaterialPageRoute(builder: (context ){ return product(prodid: payload.toString()); }));

      });
  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp( MaterialApp(  navigatorKey: navikey, home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  initFirebasePush() async{

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print( " firebase msg received closed add "+message.data.toString());
       // redirect user to product
       // message.data["prodid"];
        Navigator.push(context, MaterialPageRoute(builder: (context ){ return product(prodid: message.data["prodid"]); }));
        /*  Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true));
      */
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      String? title = message.notification!.title.toString();
      print(" getData : " + title );
      if (notification != null && android != null) {

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'noti_icon',
                color: Colors.red
              ),
            ),
          payload: message.data.toString()
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // redirect
     //  message.data["prodid"]
        /* Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));
    */
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFirebasePush();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text(" Home page"),
        ),
      ),
    );
  }
}

-------firebase notification close---------
*/
//------firebase realtime database example




Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  runApp(MaterialApp(
    home: realtime_db(),
  ) );
}
























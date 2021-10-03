import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class realtime_db extends StatefulWidget {
  @override
  _realtime_dbState createState() => _realtime_dbState();
}

class _realtime_dbState extends State<realtime_db> {
  late DatabaseReference _dbref;
  String databasejson = "";
  int countvalue =0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dbref = FirebaseDatabase.instance.reference();
    
    _dbref.child("myCountKey").child("key_counter").onValue.listen((event) {

      print("counter update "+ event.snapshot.value.toString());
      setState(() {
        countvalue = event.snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text( countvalue.toString()+ " database - " + databasejson),
              ),
              TextButton(
                  onPressed: () {
                    _createDB();
                  },
                  child: Text(" create DB")),
              TextButton(onPressed: () {
                _realdb_once();
              }, child: Text(" read value")),
              TextButton(onPressed: () {
                _readdb_onechild();
              }, child: Text(" read once child")),
              TextButton(onPressed: () {
                _updatevalue();
              }, child: Text(" update value")),
              TextButton(onPressed: () {
                _updatevalue_count();
              }, child: Text(" update counter value by 1")),
           //   _updatevalue_count()
              TextButton(onPressed: () {
                _delete();
              }, child: Text(" delete value")),
            ],
          ),
        ),
      ),
    );
  }

  _createDB() {
    _dbref.child("profile").set(" kamal profile");
    _dbref.child("jobprofile").set({'website': "www.blueappsoftware.com", "website2": "www.dripcoding.com"});
  }

  _realdb_once() {

    _dbref.once().then((DataSnapshot dataSnapshot){
      print(" read once - "+ dataSnapshot.value.toString() );
      setState(() {
        databasejson = dataSnapshot.value.toString();
      });
    });
  }

  _readdb_onechild(){
    _dbref.child("jobprofile").child("website2").once().then((DataSnapshot dataSnapshot){
      print(" read once - "+ dataSnapshot.value.toString() );
      setState(() {
        databasejson = dataSnapshot.value.toString();
      });
    });
  }

  _updatevalue(){
    _dbref.child("jobprofile").update( { "website2": "www.dripcoding.com2"});
  }

  _updatevalue_count(){
    _dbref.child("myCountKey").update({ "key_counter" : countvalue +1});
  }

  _delete(){
    _dbref.child("profile").remove();
  }
  
  
}

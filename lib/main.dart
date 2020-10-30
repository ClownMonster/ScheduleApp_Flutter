import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

import 'package:flutter/services.dart';

import 'dart:io';
import 'date_picker.dart';
import 'time_picker.dart';

void main()=> runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home:Home()
)

);




class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final myController = TextEditingController();
  String schedule = '';
  List<String> schedules = List();
  List<String> dates = List();
  List<String> times=List();
  String date_selected='';
  String time='';
  GlobalKey _scaffold=GlobalKey();
  bool loading=false;
  String format= new DateFormat('dd-mm-yyyy').format(DateTime.now().subtract(Duration(days: 1)));
  DateFormat inputFormat=DateFormat("dd-mm-yyyy");



  void _saveList(schedules, dates,times) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("key", schedules);
    prefs.setStringList('dates', dates);
    prefs.setStringList('times', times);
    print("Data Saved");
  }



  void _getList() async {

    print('restore');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {


    if (prefs.getStringList("key") != null) {
      schedules = prefs.getStringList("key");
    }
    if (prefs.getStringList('dates') != null) {
      dates = prefs.getStringList('dates');
    }
    if(prefs.getStringList('times')!=null){
          times=prefs.getStringList('times');

        }
    delete();
    _saveList(schedules, dates, times);

    });
  }

  void delete(){
  for (int i=0; i<dates.length;){
    if(inputFormat.parse(dates[i]).isBefore(inputFormat.parse(format))){
       dates.removeAt(i);
       times.removeAt(i);
       schedules.removeAt(i);
    }
    else{
      i++;
    }
  }
  }

  void setState(fn){
    super.setState(fn);
  }

  @override
  void initState() {
    _getList();
    setState(() { });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print(loading);
    return Scaffold(
      key:_scaffold,
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        title: Text(
          "Your Schedules",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey[800],

        leading: GestureDetector(
          child: Icon(
            Icons.menu,
          ),
        ),


        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: Icon(
                  Icons.calendar_today
              ),
            ),
          ),
          Icon(
              Icons.settings
          ),
        ],
      ),


      body: ListView.builder(
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            return new Card(
                color: Colors.grey[500],
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(schedules[index],
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white
                            ),

                          ),
                          Row(
                              children:<Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  size: 10.0,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 5.0),
                                Text(dates[index],
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.white
                                  ),
                                ),
                                SizedBox(width:10.0),
                                Icon(
                                  Icons.schedule,
                                  color: Colors.black,
                                  size: 10.0,
                                ),
                                Text(
                                  times[index],
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.white
                                  ),
                                )
                              ]
                          ),
                        ]
                    )
                )
            );
          }),


      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          setState(() {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.black12,
                    title: Text(
                      'Enter Schedule',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                      ),
                    ),
                    content: new Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                                color: Colors.white
                            ),
                            cursorColor: Colors.white,
                            controller: myController,
                            autofocus: true,
                            decoration: InputDecoration(),
                            onChanged: (value) {
                              schedule = value;
                            },
                          ),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child:Text('cancel'),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                          child: Text('ok'),
                          onPressed: ()async {
                            if (schedule != '') {
                              Navigator.of(context).pop();
                              myController.clear();

                              await date_picker.selectdate(context);
                              date_selected=date_picker.formatted_date;

                              await time_picker.selecttime(_scaffold.currentContext);
                              time=time_picker.time_selected;

                            }

                            else {
                              Navigator.of(context).pop();
                            }
                            setState(() {
                              schedules.add(schedule);
                              dates.add(date_selected);
                              times.add(time);
                               _saveList(schedules, dates,times);
                            });
                          }

                      )

                    ],
                  );
                }
            );
          });
        },
        child: Icon(
            Icons.add
        ),
        backgroundColor: Colors.grey[800],
      ),

    );
  }
}

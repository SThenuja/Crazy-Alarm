/**
 * this is a home page of the application which has tap view
 */
import 'package:crazyalarm/UI/stopWatch.dart';
import 'package:crazyalarm/UI/timer.dart';
import 'package:crazyalarm/models/alarm.dart';
import 'package:crazyalarm/widgets/alarm_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'add_alarm.dart';

///https://flutterawesome.com/
class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  TabController _tabContlr;

  @override
  void initState() {
    super.initState();
    ///initialize the tab controller
    _tabContlr = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabContlr.addListener(_handleTabIndexes);
  }

  ///dispose the tab controller indexes
   @override
  void dispose() {
     _tabContlr.removeListener(_handleTabIndexes);
     _tabContlr.dispose();
    super.dispose();
  }

  ///handle the tab indexes
  void _handleTabIndexes() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            bottom: TabBar(
              controller: _tabContlr,
              indicatorColor: Theme.of(context).accentColor,
              indicatorWeight: 3.0,
              tabs: [
                //Tab(icon: Icon(Icons.access_time), text: 'Clock',),
                Tab(icon: Icon(Icons.alarm), text: 'Alarm'),
                Tab(icon: Icon(Icons.hourglass_empty), text: 'Timer'),
                Tab(icon: Icon(Icons.timer), text: 'Stopwatch'),
              ],
            ),
          ),
          body: Container(
            color: Theme.of(context).primaryColor,
            child: TabBarView(
              controller: _tabContlr,
              children: [
                Container(
                  child : MyAlarm()
                ),
                Container(
                    child : StopWatchPage()
                ),
                Container(
                    child : AppHome()
                ),
              ],
            ),
          ),
          floatingActionButton: _addAlarmButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
      );
  }

  Widget _addAlarmButton() {
    TimeOfDay timeOfDay = TimeOfDay.now();
    Alarm alarm;
    return _tabContlr.index == 0
      ?FloatingActionButton(
        onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddAlarm(timeOfDay.format(context),alarm,"2")),);
        },
        backgroundColor: Color(0xff65D1BA),
        child: Icon(
          Icons.add,
          size: 30.0,
        ),
      )
      :null;
  }
}
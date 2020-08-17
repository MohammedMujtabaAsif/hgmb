import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  final int pendingCount;
  const SchedulePage({this.pendingCount});
  @override
  State createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      body: Center(
        child: Text("Under Construction"),
      ),
    );
  }
}

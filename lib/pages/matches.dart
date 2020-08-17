import 'package:flutter/material.dart';
import 'package:hgmb/pages/matched.dart';
import 'package:hgmb/pages/pendingIncoming.dart';
import 'package:hgmb/pages/pendingOutgoing.dart';
import 'package:hgmb/utils/notificationIcon.dart';

class MatchesPage extends StatefulWidget {
  final bool pendingRequestNotificationExists;
  final bool pendingMatchNotificationExists;
  const MatchesPage(
      {this.pendingRequestNotificationExists,
      this.pendingMatchNotificationExists});
  @override
  State createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage>
    with SingleTickerProviderStateMixin
{
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      top: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          flexibleSpace: new Padding(
            padding: EdgeInsets.only(top: 0),
            child: TabBar(
              controller: _tabController,
              tabs: [
                new Tab(
                  text: "Matched",
                  icon: widget.pendingMatchNotificationExists
                      ? NotificationIcon(
                          notificationExists:
                              widget.pendingMatchNotificationExists,
                          iconData: Icons.group,
                        )
                      : Icon(Icons.group),
                ),
                new Tab(
                  text: "Received",
                  icon: widget.pendingRequestNotificationExists
                      ? NotificationIcon(
                          notificationExists:
                              widget.pendingRequestNotificationExists,
                          iconData: Icons.call_received,
                        )
                      : Icon(Icons.call_received),
                ),
                new Tab(
                  text: "Sent",
                  icon: const Icon(Icons.call_made),
                ),
              ],
            ),
          ),
        ),
        body: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            MatchedPage(
              scaffoldKey: scaffoldKey,
            ),
            PendingIncomingPage(
              scaffoldKey: scaffoldKey,
            ),
            PendingOutgoingPage(
              scaffoldKey: scaffoldKey,
            ),
          ],
        ),
      ),
    );
  }
}

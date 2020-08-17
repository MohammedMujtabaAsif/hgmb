import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hgmb/pages/explore.dart';
import 'package:hgmb/pages/matches.dart';
import 'package:hgmb/pages/schedule.dart';
import 'package:hgmb/pages/userProfilePrivate.dart';
import 'package:hgmb/utils/databaseHelper.dart';
import 'package:hgmb/utils/notificationIcon.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LandingPageState();
  }
}

class LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = new ScrollController();
  DatabaseHelper db = new DatabaseHelper();

  String appBarTitle = "Explore";
  int pageIndex = 1;
  int pendingCount = 0;
  int matchCount = 0;
  bool pendingRequestNotificationExists = false;
  bool pendingMatchNotificationExists = false;
  Timer timer5;
  Timer timer30;

  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: true,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            elevation: 0,
            backgroundColor: Colors.blue,
            title: Text(
              appBarTitle,
            ),
          ),
          resizeToAvoidBottomInset: true,
          resizeToAvoidBottomPadding: true,
          body: IndexedStack(
            index: pageIndex,
            children: <Widget>[
              UserProfilePrivatePage(
                scaffoldKey: _scaffoldKey,
              ),
              ExplorePage(
                scrollController: _scrollController,
              ),
              MatchesPage(
                  pendingMatchNotificationExists:
                      pendingMatchNotificationExists,
                  pendingRequestNotificationExists:
                      pendingRequestNotificationExists),
              SchedulePage()
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
            currentIndex: pageIndex,
            items: [
              BottomNavigationBarItem(
                title: Text("Profile"),
                icon: Icon(Icons.account_circle),
              ),
              BottomNavigationBarItem(
                title: Text("Explore"),
                icon: Icon(Icons.search),
              ),
              BottomNavigationBarItem(
                title: Text("Matches"),
                icon: pendingRequestNotificationExists ||
                        pendingMatchNotificationExists
                    ? NotificationIcon(
                        notificationExists: pendingRequestNotificationExists ||
                            pendingMatchNotificationExists,
                        iconData: Icons.group_add,
                      )
                    : Icon(Icons.group),
              ),
              BottomNavigationBarItem(
                title: Text("Schedule"),
                icon: Icon(Icons.schedule),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    if (this.mounted) {
      super.initState();

      // Create a 5 second timer that checks for new matches and incoming requests
      timer5 = new Timer.periodic(
        Duration(seconds: 5),
        (Timer t) => setState(
          () {
            _getMatchRequests();
            _getMatched();
          },
        ),
      );

      // Create a 30 second timer that checks the user is still verified
      timer30 = new Timer.periodic(
        Duration(seconds: 30),
        (Timer t) => setState(
          () {
            _verify();
          },
        ),
      );
    }
  }

  // check the user is still verified
  _verify() async {
    if (this.mounted) {
      bool approved = await db.verify();

      // if they are not verified, kick them to the middleware page
      if (!approved) {
        {
          setState(() {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/middleware', (route) => false);
          });
        }
      }
    }
  }

  _getMatchRequests() async {
    var res = await db.getData('incomingRequests');
    var body = json.decode(res.body);

    if (body['success']) {
      if (body['data'].length > pendingCount) {
        pendingRequestNotificationExists = true;
      }
      pendingCount = body['data'].length;
    } else {
      pendingRequestNotificationExists = false;
      pendingCount = 0;
    }
  }

  _getLastMatchedPage() async {
    int matchPageNum = 1;

    var res = await db.getData('acceptedRequests');
    var body = json.decode(res.body);
    if (body['success']) {
      matchPageNum = body['data']['last_page'];
    }

    return matchPageNum;
  }

  _getMatched() async {
    int lastPageNum = await _getLastMatchedPage();
    var res =
        await db.getData('acceptedRequests/?page=' + lastPageNum.toString());
    var body = json.decode(res.body);

    if (body['success']) {
      if (body['data']['total'] > matchCount) {
        pendingMatchNotificationExists = true;
      }
      matchCount = body['data']['total'];
    } else {
      pendingMatchNotificationExists = false;
      matchCount = 0;
    }
  }

  void _onItemTapped(int index) {
    // check the user left the matches page
    if (pageIndex == 2) {
      // disable the notifications
      pendingRequestNotificationExists = false;
      pendingMatchNotificationExists = false;
    }
    switch (index) {
      case 0:
        appBarTitle = "Profile";
        break;
      case 1:
        appBarTitle = "Explore";
        if (pageIndex == 1) {
          _scrollController.animateTo(0.0,
              curve: Curves.decelerate,
              duration: const Duration(milliseconds: 500));
        }
        break;
      case 2:
        appBarTitle = "Matches";
        break;
      case 3:
        appBarTitle = "Schedule";
        break;
      default:
    }
    setState(() {
      pageIndex = index;
    });
  }

  @override
  void dispose() {
    timer5.cancel();
    timer30.cancel();
    super.dispose();
  }
}

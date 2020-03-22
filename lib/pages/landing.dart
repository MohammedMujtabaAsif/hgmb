import 'package:flutter/material.dart';
import 'package:hgmb/pages/explore.dart';
import 'package:hgmb/pages/matches.dart';
import 'package:hgmb/pages/userProfilePrivate.dart';
// import 'package:hgmb/pages/userProfilePublic.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LandingPageState();
  }
}

class LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: true,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            flexibleSpace: new TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: Icon(Icons.account_box)),
                Tab(icon: Icon(Icons.map)),
                Tab(icon: Icon(Icons.contacts)),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              UserProfilePrivatePage(),
              ExplorePage(),
              MatchesPage(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hgmb/pages/matched.dart';
import 'package:hgmb/pages/pending.dart';

class MatchesPage extends StatefulWidget {
  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> with TickerProviderStateMixin
// ,AutomaticKeepAliveClientMixin<MatchesPage>
{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
  }

  // @override
  // bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        // elevation: 1.0,
        // backgroundColor: Colors.red,
        flexibleSpace: new TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.group)),
            Tab(icon: Icon(Icons.person_add)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MatchedPage(),
          PendingPage(),
        ],
      ),
    );
  }
}

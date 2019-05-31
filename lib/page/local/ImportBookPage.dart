import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'LocalPathPage.dart';
import 'SmartImportPage.dart';

class ImportBookPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImportBookPage();
  }
}

class _ImportBookPage extends State<ImportBookPage> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text(
          "添加本地",
          style: TextStyle(
              color: Color(0xde000000),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          indicatorColor: Color(0xffD81B60),
          indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
          labelColor: Color(0xffD81B60),
          unselectedLabelColor: Colors.black87,

          tabs: [
            Tab(
              text: "本地目录",
            ),
            Tab(
              text: "智能导入",
            )
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: [
          LocalPathPage(),
          SmartImportPage(),
        ],
        controller: _tabController,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_book/page/AllBookChildPage.dart';
import 'package:flutter_book/page/FoundChildPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    PageController _pageController =
        PageController(initialPage: 0, keepPage: true, viewportFraction: 1.0);
    TabController _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
//      setState(() {
//        debugPrint(_tabController.index.toString());
////        _pageController.jumpTo(MediaQuery
////            .of(context)
////            .size
////            .width * _tabController.index);
//      });
    });
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.only(right: 16),
          width: double.infinity,
          height: 30,
          decoration: BoxDecoration(
              color: Color(0xffdedede),
              borderRadius: new BorderRadius.all(new Radius.circular(2))),
          child: Container(
            margin: EdgeInsets.only(left: 11),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "搜索书名、作者",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ),
        ),
        bottom: TabBar(
          indicatorColor: Color(0xffD81B60),
          indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.black87,
          tabs: [
            Tab(
              text: "所有书籍",
//              child: AllBookChildPage(),
            ),
            Tab(
              text: "发现",
//              child: FoundChildPage(),
            )
          ],
          controller: _tabController,
        ),
      ),
      body: PageView(
        children: [
          AllBookChildPage(),
          FoundChildPage(),
        ],
        controller: _pageController,
        onPageChanged: (index) {
          _tabController.animateTo(index);
        },
      ),
      drawer: Drawer(
        child: ListView(),
      ),
    );
  }
}

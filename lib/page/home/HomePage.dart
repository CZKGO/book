import 'package:flutter/material.dart';
import 'package:flutter_book/page/local/ImportBookPage.dart';
import 'package:flutter_book/widget/WidthDrawer.dart';
import 'package:flutter_book/widget/my_popup_menu.dart';
import 'package:flutter_book/page/home/AllBookChildPage.dart';
import 'package:flutter_book/page/home/FoundChildPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: Container(
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
        actions: <Widget>[
          MyPopupMenuButton(
            offset: Offset(0, 52),
            padding: EdgeInsets.all(0.0),
            kMenuScreenPadding: 0.0,
            menuPdding: EdgeInsets.all(0),
            itemBuilder: (BuildContext context) =>
                <MyPopupMenuEntry<_PopupMenu>>[
                  MyPopupMenuItem(
                    value: _PopupMenu.addLocal,
                    child:
                        _ActionBarListText(leading: Icons.add, title: "添加本地"),
                  ),
                  MyPopupMenuItem(
                      child: _ActionBarListText(
                          leading: Icons.link, title: "添加网址")),
                  MyPopupMenuItem(
                      child: _ActionBarListText(
                          leading: Icons.file_download, title: "一键缓存")),
                  MyPopupMenuItem(
                      child: _ActionBarListText(
                          leading: Icons.list, title: "网格视图")),
                  MyPopupMenuItem(
                      child: _ActionBarListText(
                          leading: Icons.track_changes, title: "切换图标")),
                  MyPopupMenuItem(
                      child: _ActionBarListText(
                          leading: Icons.delete_outline, title: "清除缓存")),
                  MyPopupMenuItem(
                      child: _ActionBarListText(
                          leading: Icons.delete_forever, title: "清空书架")),
                ],
            onSelected: _PopupMenuItemSelected,
          ),
        ],
        bottom: TabBar(
          indicatorColor: Color(0xffD81B60),
          indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.black87,
          tabs: [
            Tab(
              text: "所有书籍",
            ),
            Tab(
              text: "发现",
            )
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: [
          AllBookChildPage(),
          FoundChildPage(),
        ],
        controller: _tabController,
      ),
      drawer: WidthDrawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: Image.asset(
                "images/image_yue_du.webp",
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
            _DrawListText(
              leading: Icons.menu,
              title: "书源管理",
            ),
            _DrawListText(
              leading: Icons.find_replace,
              title: "替换净化",
            ),
            _DrawListText(
              leading: Icons.file_download,
              title: "下载任务",
            ),
            _Divider(),
            _DrawListText(
              leading: Icons.palette,
              title: "主题",
            ),
            _Divider(),
            _DrawListText(
              leading: Icons.settings,
              title: "设置",
            ),
            _DrawListText(
              leading: Icons.email,
              title: "关于",
            ),
            _DrawListText(
              leading: Icons.card_giftcard,
              title: "捐赠",
            ),
            _Divider(),
            _DrawListText(
              leading: Icons.settings_backup_restore,
              title: "备份",
            ),
            _DrawListText(
              leading: Icons.restore,
              title: "恢复",
            ),
          ],
        ),
      ),
    );
  }

  Widget _DrawListText({IconData leading, String title}) {
    return ListTile(
      leading: Icon(
        leading,
        size: 24,
        color: Color(0xff595757),
      ),
      title: Text(
        title,
        style: TextStyle(color: Color(0xde000000)),
      ),
      onTap: () {},
    );
  }

  Widget _ActionBarListText({IconData leading, String title}) {
    return Baseline(
        baseline: 48 / 2 + 24 / 2,
        baselineType: TextBaseline.ideographic,
        child: ListTile(
          contentPadding: EdgeInsets.only(
            left: 8,
          ),
          leading: Icon(
            leading,
            size: 24,
            color: Color(0xff595757),
          ),
          title: Text(
            title,
            style: TextStyle(color: Color(0xde000000)),
          ),
        ));
  }

  Widget _Divider() {
    return Divider(
      height: 4,
      color: Color(0xff595757),
    );
  }

  void _PopupMenuItemSelected(_PopupMenu value) {
    switch (value) {
      case _PopupMenu.addLocal:
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new ImportBookPage()),
        );
        break;
    }
    return;
  }
}

enum _PopupMenu { addLocal }

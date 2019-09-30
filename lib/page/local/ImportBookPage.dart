import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book/data/book.dart';
import 'package:flutter_book/data/sql_help.dart';
import 'package:flutter_book/util/file_helper.dart';
import 'package:flutter_book/util/formt_web_txt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LocalPathPage.dart';
import 'SmartImportPage.dart';

class ImportBookPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImportBookPage();
  }
}

class _ImportBookPage extends State<ImportBookPage>
    with TickerProviderStateMixin {
  LocalPathPage localPathPage;
  SmartImportPage smartImportPage;
  TabController _tabController;

  var isSelectAll = false;

  @override
  void initState() {
    super.initState();
    localPathPage = LocalPathPage(this);
    smartImportPage = SmartImportPage(this);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
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
          localPathPage,
          smartImportPage,
        ],
        controller: _tabController,
      ),
      bottomNavigationBar: Material(
        elevation: 16,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              Checkbox(
                value: isSelectAll,
                activeColor: Color(0xffD81B60),
                onChanged: (bool check) {
                  selectAll(check, _tabController);
                },
              ),
              InkWell(
                child: Ink(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Text(isSelectAll ? "取消" : "全选"),
                ),
                onTap: () {
                  selectAll(!isSelectAll, _tabController);
                },
              ),
              Expanded(
                child: Text(""),
                flex: 1,
              ),
              MaterialButton(
                height: 32,
                splashColor: Colors.grey,
                highlightColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  side: BorderSide(width: 1, color: Colors.black),
                ),
                child: Text("加入书架"),
                onPressed: () {
                  addToBookCase(_tabController.index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addToBookCase(int index) async {
    List<String> paths;
    if (index == 0) {
      paths = localPathPage.getSelectFilePath();
    } else {
      paths = smartImportPage.getSelectFilePath();
    }
    for (String path in paths) {
      String fileName = path.substring(File(path).parent.path.length);
      int lastDotIndex = fileName.lastIndexOf(".");
      if (lastDotIndex > 0) fileName = fileName.substring(0, lastDotIndex);
      int authorIndex = fileName.indexOf("作者");
      String author = "";
      int smhStart = fileName.indexOf("《");
      int smhEnd = fileName.indexOf("》");
      if (smhStart != -1 && smhEnd != -1) {
        fileName = fileName.substring(smhStart + 1, smhEnd);
      }
      if (authorIndex != -1) {
        author = FormatWebText.getAuthor(fileName.substring(authorIndex));
        fileName = fileName.substring(0, authorIndex).trim();
      } else{
        fileName = fileName.substring(1).trim();
      }
      Book book = Book(
        hasUpdate: true,
        finalDate: DateTime
            .now()
            .millisecondsSinceEpoch,
        currentChapter: 0,
        currentChapterPage: 0,
        group: 3,
        type: 0,
        allowUpdate: false,
        author: author,
        name: fileName,
        finalRefreshDate: getFileLastModifiedTime(File(path)).millisecondsSinceEpoch,
        customCoverPath: "",
        noteUrl: path,
        origin: "本地",
      );
      SqlHelp().insertOrReplace(book);
    }
  }

  void selectAll(bool check, TabController _tabController) {
    if (_tabController.index == 0) {
      localPathPage.selectAll(check);
    } else {
      smartImportPage.selectAll(check);
    }

    setState(() {
      isSelectAll = check;
    });
  }

  void listener() {
    selectAll(false, _tabController);
  }

  void select(bool select) {
    setState(() {
      isSelectAll = select;
    });
  }
}

class MyFiles {
  List<FileSystemEntity> files;
  List<bool> checks;

  MyFiles(List<FileSystemEntity> allTextFiles) {
    files = allTextFiles;
    checks = List(allTextFiles.length);
  }

  num get length => files.length;

  void checkItem(int i, bool check) {
    checks[i] = check;
  }

  FileSystemEntity getFile(int index) {
    return files[index];
  }

  bool isCheck(int index) {
    return checks[index];
  }
}

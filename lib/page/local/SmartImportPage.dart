import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SmartImportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SmartImportPage();
  }
}

class _SmartImportPage extends State<SmartImportPage>
    with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true; //是否保存状态

  List<FileSystemEntity> files = [];
  List<bool> isFileChecds = [];

  @override
  void initState() {
    super.initState();
    debugPrint(files.length.toString());
    if (files.length == 0) _initPathList();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
        color: Colors.white,
        child: ListView.separated(
          itemCount: files.length != 0 ? files.length : 0,
          physics: ClampingScrollPhysics(),
          controller: ScrollController(),
          itemBuilder: (BuildContext context, int index) {
            return _buildListViewItem(index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              height: 0.0,
              color: Colors.grey,
            );
          },
        ));
  }

  void _initPathList() async {
    Directory appDocDir = await getExternalStorageDirectory();
    List<FileSystemEntity> allTextFiles = await _getAllTxt(appDocDir);
    allTextFiles.sort((FileSystemEntity fileA, FileSystemEntity fileB) {
      return Comparable.compare(fileA.path, fileB.path);
    });
    setState(() {
      files = allTextFiles;
      isFileChecds = new List(files.length);
    });
  }

  Future<List<FileSystemEntity>> _getAllTxt(Directory directoty) async {
    List<FileSystemEntity> list = [];
    var tempFiles = directoty.listSync();
    for (int i = 0; i < tempFiles.length; i++) {
      var tempFile = tempFiles[i];
      if (tempFile.path
              .substring(tempFile.parent.path.length + 1)
              .substring(0, 1) !=
          '.') {
        if (!FileSystemEntity.isFileSync(tempFile.path)) {
          list.addAll(await _getAllTxt(Directory(tempFile.path)));
        } else if (tempFile.path.endsWith(".txt")) {
          list.add(tempFile);
        }
      }
    }
    return list;
  }

  Widget _buildListViewItem(int index) {
    FileSystemEntity file = files[index];
    bool fileChecd = isFileChecds[index];
    return ListTile(
      leading: Checkbox(
        materialTapTargetSize: MaterialTapTargetSize.padded,
        tristate: false,
        value: fileChecd == null ? false : fileChecd,
        activeColor: Color(0xffD81B60),
        onChanged: (bool checd) {
          setState(() {
            isFileChecds[index] = checd;
          });
        },
      ),
      title: Text(file.path.substring(file.parent.path.length + 1)),
      subtitle: Text(
        '${getFileLastModifiedTime(file)}  ${getFileSize(file)}',
        style: TextStyle(fontSize: 12.0),
      ),
      onTap: () {
        setState(() {
          isFileChecds[index] = (fileChecd == null ? true : !fileChecd);
        });
      },
    );
  }

  // 计算文件夹内 文件、文件夹的数量，以 . 开头的除外
  removePointBegin(Directory path) {
    var dir = Directory(path.path).listSync();
    int num = dir.length;

    for (int i = 0; i < dir.length; i++) {
      if (dir[i]
              .path
              .substring(dir[i].parent.path.length + 1)
              .substring(0, 1) ==
          '.') num--;
    }
    return num;
  }

  getFileSize(FileSystemEntity file) {
    int fileSize = File(file.resolveSymbolicLinksSync()).lengthSync();
    if (fileSize < 1024) {
      // b
      return '${fileSize.toStringAsFixed(2)}B';
    } else if (1024 <= fileSize && fileSize < 1048576) {
      // kb
      return '${(fileSize / 1024).toStringAsFixed(2)}KB';
    } else if (1048576 <= fileSize && fileSize < 1073741824) {
      // mb
      return '${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB';
    }
  }

  getFileLastModifiedTime(FileSystemEntity file) {
    DateTime dateTime =
        File(file.resolveSymbolicLinksSync()).lastModifiedSync();

    String time =
        '${dateTime.year}-${dateTime.month < 10 ? 0 : ''}${dateTime.month}-${dateTime.day < 10 ? 0 : ''}${dateTime.day} ${dateTime.hour < 10 ? 0 : ''}${dateTime.hour}:${dateTime.minute < 10 ? 0 : ''}${dateTime.minute}';
    return time;
  }
}

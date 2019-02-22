// Step 7 (Final): Change the app's theme

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(backgroundColor: Colors.white),
      home: new Scaffold(appBar: new AppBar(),
        body: new ,),
    );
  }
}

///搜索结果内容显示面板
class MaterialSearchResult<T> extends StatelessWidget {
  const MaterialSearchResult({
    Key key,
    this.value,
    this.text,
    this.icon,
    this.onTap
  }) : super(key: key);

  final String value;
  final VoidCallback onTap;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {

    return new InkWell(
      onTap: this.onTap,
      child: new Container(
        height: 64.0,
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
        child: new Row(
          children: <Widget>[
            new Container(width: 30.0, margin: EdgeInsets.only(right: 10), child: new Icon(icon)) ?? null,
            new Expanded(child: new Text(value, style: Theme.of(context).textTheme.subhead)),
            new Text(text, style: Theme.of(context).textTheme.subhead)
          ],
        ),
      ),
    );
  }
}

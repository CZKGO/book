import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book/data/book.dart';
import 'package:flutter_book/data/sql_help.dart';

class AllBookChildPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AllBookChildPage();
  }
}

class _AllBookChildPage extends State<AllBookChildPage>
    with SingleTickerProviderStateMixin {
  List<Book> books = [];

  @override
  void initState() {
    initAllBoos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.white,
        child: ListView.separated(
          itemCount: books.length,
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

  Future initAllBoos() async {
    List<Map> maps = await SqlHelp().queryAll(Book());
    for (var map in maps) {
      Book book = Book();
      book.fromMap(map);
      books.add(book);
    }
    setState(() {});
  }

  Widget _buildListViewItem(int index) {
    Book book = books[index];
    return Ink(
      padding: EdgeInsets.all(10),
      child: InkWell(
        child: Row(
          children: <Widget>[
            Image.asset(
              "images/img_cover_default.jpg",
              width: 56,
              height: 80,
              fit: BoxFit.cover,
            ),
            Ink(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    book.name,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.perm_identity,
                        size: 14,
                        color: Color(0xb2000000),
                      ),
                      Text(
                        book.author,
                        style:
                            TextStyle(color: Color(0xb2000000), fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Color(0xb2000000),
                      ),
                      Text(
                        book.author,
                        style:
                            TextStyle(color: Color(0xb2000000), fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.remove_red_eye,
                        size: 14,
                        color: Color(0xb2000000),
                      ),
                      Text(
                        book.author,
                        style:
                            TextStyle(color: Color(0xb2000000), fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: (){

        },
      ),
    );
  }
}
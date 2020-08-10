import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          body: Center(
            child: SliverAppBarSnap(),
          ),
        ));
  }
}

class SliverAppBarSnap extends StatefulWidget {
  @override
  _SliverAppBarSnapState createState() => _SliverAppBarSnapState();
}

class _SliverAppBarSnapState extends State<SliverAppBarSnap> {
  final _controller = ScrollController();

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;
  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;
  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.4),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.forward),
        backgroundColor: Colors.blue,
        onPressed: () {
          setState(() {
            isEmpty = !isEmpty;
          });
        },
      ),
      body: NotificationListener<ScrollEndNotification>(
          onNotification: (_) {
            _snapAppbar();
            return false;
          },
          child: CustomScrollView(
            semanticChildCount: 5,
            physics: AlwaysScrollableScrollPhysics(),
            controller: _controller,
            slivers: [
              SliverAppBar(
                pinned: true,
                stretch: true,
                flexibleSpace: Header(
                  maxHeight: maxHeight,
                  minHeight: minHeight,
                ),
                expandedHeight: maxHeight - MediaQuery.of(context).padding.top,
              ),
              if (!isEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildCard();
                    },
                    childCount: 10,
                  ),
                )
              else
                SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                        child: Text(
                      'A Lista está vazia',
                      style: TextStyle(color: Colors.white),
                    ))),
            ],
          )),
    );
  }

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      final double snapOffset =
          _controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;
      Future.microtask(() => _controller.animateTo(snapOffset,
          duration: Duration(milliseconds: 2000), curve: Curves.easeIn));
    }
  }
}

_buildCard() {
  return Container(
    padding: EdgeInsets.only(top: 10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.blue,
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: ListTile(
              leading: CircleAvatar(
                radius: 80,
                child: Text(
                  'NC',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              title: Text(
                'Nome do Cliente',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'subtitulo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {},
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 25,
                        )),
                    FlatButton(
                        onPressed: () {},
                        child: const Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 25,
                        )),
                    FlatButton(
                        onPressed: () {},
                        child: const Icon(
                          Icons.list,
                          color: Colors.white,
                          size: 25,
                        )),
                    FlatButton(
                        onPressed: () {},
                        child: const Icon(
                          Icons.add_box,
                          color: Colors.white,
                          size: 25,
                        )),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

class Header extends StatelessWidget {
  final double maxHeight;
  final double minHeight;

  const Header({Key key, this.maxHeight, this.minHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final expandRatio = _calculateExpandRatio(constraints);
        final Animation<double> animation = AlwaysStoppedAnimation(expandRatio);

        return Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(),
            _buildGradient(animation),
            _buildTitle(animation),
          ],
        );
      },
    );
  }

  _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio =
        (constraints.maxHeight - minHeight) / (maxHeight - minHeight);
    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.0) expandRatio = 0.0;
    return expandRatio;
  }
}

_buildGradient(Animation<double> animation) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.transparent,
          ColorTween(begin: Colors.black87, end: Colors.black38)
              .evaluate(animation)
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  );
}

_buildTitle(Animation<double> animation) {
  return Align(
    alignment:
        AlignmentTween(begin: Alignment.bottomCenter, end: Alignment.bottomLeft)
            .evaluate(animation),
    child: Container(
      margin: EdgeInsets.only(bottom: 12, left: 12),
      child: Text(
        "CLIENTES",
        style: TextStyle(
          fontSize: Tween<double>(begin: 18, end: 36).evaluate(animation),
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

_buildImage() {
  return Image.network(
    "https://scontent.fnvt5-1.fna.fbcdn.net/v/t1.0-9/50565980_2059386000824694_5306289243595735040_o.jpg?_nc_cat=111&_nc_sid=6e5ad9&_nc_eui2=AeGJVMk-HBrG49lZRpMgtZBUF3_rbmg0HBQXf-tuaDQcFN8ofYwcDUz23oTpBYq8m-dQFf_ZbbIKJm7hrBg6Q9rW&_nc_ohc=FMq3ykRZuScAX9x5B3j&_nc_ht=scontent.fnvt5-1.fna&oh=79aa03b237fe72aea95b8e5de0329c47&oe=5F52825D",
    fit: BoxFit.cover,
  );
}

import 'package:drbob/main_drawer.dart';
import 'package:drbob/nav_drawer.dart';
import 'package:drbob/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class MyScaffold extends StatefulWidget {
  const MyScaffold({
    @required this.child,
    this.title,
    this.leading,
    this.fab,
    this.implyLeading = false,
    this.actions = const <Widget>[],
  }) : assert(child != null);

  final Widget child;
  final Widget fab;
  final Widget title;
  final bool implyLeading;
  final Widget leading;
  final List<Widget> actions;

  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> with TickerProviderStateMixin {
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();
  bool _isNavOpen = false;
  bool _isMenuOpen = false;
  AnimationController _navAnimationController;
  AnimationController _menuAnimationController;

  @override
  void initState() {
    super.initState();
    _navAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    _menuAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navAnimationController.dispose();
    _menuAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: InnerDrawer(
          key: _innerDrawerKey,
          rightChild: NavDrawer(),
          leftChild: MainDrawer(),
          tapScaffoldEnabled: true,
          borderRadius: 32,
          offset: const IDOffset.only(left: .18, bottom: .25, right: .18),
          backgroundColor: mainBgColor(context),
          innerDrawerCallback: (bool val, InnerDrawerDirection direction) =>
              setState(() {
            if (direction == InnerDrawerDirection.start) {
              _isNavOpen = val;
              _isNavOpen
                  ? _navAnimationController.forward()
                  : _navAnimationController.reverse();
            } else {
              _isMenuOpen = val;
              _isMenuOpen
                  ? _menuAnimationController.forward()
                  : _menuAnimationController.reverse();
            }
          }),
          scaffold: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? <Color>[
                        Colors.deepPurple[800],
                        Colors.indigo[800],
                        Colors.blue[800],
                      ]
                    : <Color>[
                        Colors.red,
                        Colors.orange,
                        Colors.yellow,
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: Theme.of(context).brightness == Brightness.dark
                    ? const <double>[
                        .0,
                        .5,
                        1.0,
                      ]
                    : const <double>[
                        .0,
                        .5,
                        1.0,
                      ],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Directionality(
                textDirection: Directionality.of(context),
                child: widget.child,
              ),
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: widget.implyLeading,
                leading: widget.leading ??
                    IconButton(
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.menu_arrow,
                        progress: _navAnimationController,
                        color: Theme.of(context).textTheme.body1.color,
                      ),
                      onPressed: () => _innerDrawerKey.currentState.toggle(
                        direction: InnerDrawerDirection.start,
                      ),
                    ),
                actions: <Widget>[
                  ...widget.actions,
                  IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.view_list,
                      progress: _menuAnimationController,
                      color: Theme.of(context).textTheme.body1.color,
                    ),
                    onPressed: () => _innerDrawerKey.currentState.toggle(
                      direction: InnerDrawerDirection.end,
                    ),
                  ),
                ],
                title: widget.title,
              ),
              drawerScrimColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(.75)
                  : Colors.black.withOpacity(.25),
              floatingActionButton: widget.fab,
            ),
          ),
        ),
      ),
    );
  }
}

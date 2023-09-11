import 'package:drbob/main_drawer.dart';
import 'package:drbob/nav_drawer.dart';
import 'package:flutter/material.dart';

class MyScaffold extends StatefulWidget {
  const MyScaffold({
    super.key,
    required this.child,
    this.title,
    this.leading,
    this.fab,
    this.implyLeading = false,
    this.actions = const <Widget>[],
  });

  final Widget child;
  final Widget? fab;
  final Widget? title;
  final Widget? leading;
  final bool implyLeading;
  final List<Widget> actions;

  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> with TickerProviderStateMixin {
  late AnimationController _navAnimationController;
  late AnimationController _menuAnimationController;

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
      child: Scaffold(
        endDrawer: const NavDrawer(),
        drawer: const MainDrawer(),
        floatingActionButton: widget.fab,
        drawerScrimColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withOpacity(.75)
            : Colors.black.withOpacity(.25),
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: widget.implyLeading,
          leading: Builder(builder: (context) {
            return widget.leading ??
                IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_arrow,
                    progress: _navAnimationController,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
          }),
          actions: <Widget>[
            ...widget.actions,
            Builder(builder: (context) {
              return IconButton(
                icon: AnimatedIcon(
                  icon: AnimatedIcons.view_list,
                  progress: _menuAnimationController,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            }),
          ],
          title: widget.title,
        ),
        body: widget.child,
      ),
    );
  }
}

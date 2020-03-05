import 'package:drbob/main_drawer.dart';
import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  final Widget child;
  final Widget fab;
  final Widget title;
  final bool implyLeading;
  final Widget leading;
  final List<Widget> actions;

  MyScaffold(
      {@required this.child,
      this.title,
      this.fab,
      this.implyLeading = false,
      this.actions,
      this.leading})
      : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: Directionality(
            textDirection: Directionality.of(context),
            child: child,
          ),
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: implyLeading,
            leading: leading,
            actions: actions,
            title: title,
          ),
          endDrawer: MainDrawer(),
          floatingActionButton: fab,
        ),
      ),
    );
  }
}

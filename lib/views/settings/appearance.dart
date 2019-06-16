// import 'package:drbob/blocs/Bloc.dart';
// import 'package:drbob/utils/localization.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AppearanceView extends StatefulWidget {
//   @override
//   AppearanceViewState createState() => AppearanceViewState();
// }

// class AppearanceViewState extends State<AppearanceView> {
//   @override
//   Widget build(BuildContext context) {
//     var theme = Provider.of<Bloc>(context).getTheme;
//     var brightness = theme.brightness;
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         title: Text(trans(context, "appearance_view_title")),
//         centerTitle: true,
//       ),
//       body: Container(
//         padding: EdgeInsets.all(40),
//         child: Column(
//           children: <Widget>[
//             buildItem(
//               buildPrimaryColorItem(context, theme),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Card buildItem(Widget item) => Card(
//         child: item,
//         elevation: 20,
//       );

//   Widget buildPrimaryColorItem(BuildContext context, ThemeData theme) {
//     return DropdownButton(
//       isExpanded: true,
//       underline: Container(),
//       icon: ClipOval(),
//       hint: ListTile(
//         leading: Icon(Icons.color_lens),
//         title: Text(
//           trans(context, "theme_primary_color"),
//         ),
//         trailing: Container(
//           height: 30,
//           width: 30,
//           color: Theme.of(context).primaryColor,
//         ),
//       ),
//       items: Colors.primaries
//           .map(
//             (f) => DropdownMenuItem(
//                   child: Container(
//                     width: double.infinity,
//                     height: double.infinity,
//                     decoration: BoxDecoration(
//                       color: f,
//                     ),
//                     child: f.value == Theme.of(context).primaryColor.value
//                         ? Container(
//                             child: Center(
//                               child: Text(
//                                 "XXX",
//                                 style: TextStyle(
//                                     backgroundColor: Colors.white,
//                                     color: Colors.black),
//                               ),
//                             ),
//                           )
//                         : Container(),
//                   ),
//                   key: Key(f.value.toString()),
//                   value: f.value,
//                 ),
//           )
//           .toList()
//             ..addAll(
//               [
//                 DropdownMenuItem(
//                   child: Container(
//                     color: Colors.black,
//                     child: Colors.black.value ==
//                             Theme.of(context).primaryColor.value
//                         ? Container(
//                             child: Center(
//                               child: Text(
//                                 "XXX",
//                                 style: TextStyle(
//                                     backgroundColor: Colors.white,
//                                     color: Colors.black),
//                               ),
//                             ),
//                           )
//                         : Container(),
//                   ),
//                   key: Key(Colors.black.value.toString()),
//                   value: Colors.black.value,
//                 ),
//                 DropdownMenuItem(
//                   child: Container(
//                     color: Colors.white,
//                     child: Colors.white.value ==
//                             Theme.of(context).primaryColor.value
//                         ? Container(
//                             child: Center(
//                               child: Text(
//                                 "XXX",
//                                 style: TextStyle(
//                                     backgroundColor: Colors.white,
//                                     color: Colors.black),
//                               ),
//                             ),
//                           )
//                         : Container(),
//                   ),
//                   key: Key(
//                     Colors.white.value.toString(),
//                   ),
//                   value: Colors.white.value,
//                 ),
//               ],
//             ),
//       onChanged: (int val) {
//         setState(
//           () {
//             Provider.of<Bloc>(context).changeTheme(
//               theme.copyWith(
//                 primaryColor: Color(val),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

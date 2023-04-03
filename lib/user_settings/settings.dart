import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: SafeArea(
          child: Row(
            children: <Widget>[
              Column(
                children: [
                  Container(
                    alignment: Alignment(1, 1),
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://images.pexels.com/photos/236047/pexels-photo-236047.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 0),
                    width: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 15, left: 15, right: 15),
                      child: Text(
                        textAlign: TextAlign.center,
                        'John Doe',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
              // Column(
              //   children: [
              //     Expanded(
              //       child: ListView(
              //         shrinkWrap: true,
              //         children: <Widget>[
              //           Card(
              //             child: ListTile(
              //               leading: Icon(
              //                 Icons.edit,
              //                 color: Theme.of(context).colorScheme.secondary,
              //                 size: 28,
              //               ),
              //               title: Text('Profile',
              //                   style: TextStyle(
              //                       color: Colors.black, fontSize: 17)),
              //               trailing: Icon(Icons.keyboard_arrow_right,
              //                   color: Theme.of(context).colorScheme.secondary),
              //             ),
              //           ),
              //           Card(
              //             child: ListTile(
              //               leading: Icon(
              //                 Icons.vpn_key,
              //                 color: Theme.of(context).colorScheme.secondary,
              //                 size: 28,
              //               ),
              //               title: Text('Change Password',
              //                   style: TextStyle(
              //                       color: Colors.black, fontSize: 17)),
              //               trailing: Icon(Icons.keyboard_arrow_right,
              //                   color: Theme.of(context).colorScheme.secondary),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ));
  }
}

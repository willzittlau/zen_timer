import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'stopwatch.dart';
import 'AppState.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AppStateNotifier(),
        child: Consumer<AppStateNotifier>(
            builder: (context, AppStateNotifier appState, child) {
          return new MaterialApp(
              debugShowCheckedModeBanner: false,
              showPerformanceOverlay: false,
              title: 'Zen Timer',
              theme: new ThemeData(
                primaryColor: Colors.grey[200],
                brightness: Brightness.light,
              ),
              darkTheme: ThemeData(
                  brightness: Brightness.dark, primarySwatch: Colors.grey),
              themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home: Builder(
                  builder: (context) => Scaffold(
                        extendBodyBehindAppBar: true,
                        appBar: appState.hideScreen
                            ? null
                            : AppBar(
                                title: new Text("Zen Timer"),
                                leading: IconButton(
                                  icon: Icon(
                                      (appState.isClock
                                          ? Icons.update
                                          : Icons.schedule),
                                      color: (appState.isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                                ),
                                actions: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                        (appState.isDarkMode
                                            ? Icons.nights_stay
                                            : Icons.wb_sunny),
                                        color: (appState.isDarkMode
                                            ? Colors.white
                                            : Colors.black)),
                                  ),
                                  Switch(
                                    value: appState.isDarkMode,
                                    activeColor: (appState.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                    inactiveThumbColor: (appState.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                    inactiveTrackColor: Colors.grey[400],
                                    activeTrackColor: Colors.grey[600],
                                    onChanged: (boolVal) {
                                      Provider.of<AppStateNotifier>(context,
                                              listen: false)
                                          .updateTheme(boolVal);
                                    },
                                  ),
                                ],
                              ),
                        body: Stack(children: <Widget>[
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () async {
                                Provider.of<AppStateNotifier>(context,
                                        listen: false)
                                    .updateScreen();
                                await Provider.of<AppStateNotifier>(context,
                                        listen: false)
                                    .getScreen();
                                Wakelock.toggle(enable: appState.hideScreen);
                              },
                              onDoubleTap: () async {
                                Provider.of<AppStateNotifier>(context,
                                        listen: false)
                                    .updateClock();
                              },
                            ),
                          ),
                          Container(child: new TimerPage())
                        ]),
                      )));
        }));
  }
}

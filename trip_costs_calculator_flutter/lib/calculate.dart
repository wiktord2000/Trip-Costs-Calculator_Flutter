import 'package:flutter/material.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key, required this.passengers});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final List<int> passengers;

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  final ScrollController _homeController = ScrollController();

  Widget _listViewBody() {
    return ListView.separated(
        controller: _homeController,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Text(
              '$index. Item ${widget.passengers[index]}',
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
              thickness: 1,
            ),
        itemCount: widget.passengers.length);
  }

  // Widget _card() {
  //   return Widget();
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return SingleChildScrollView(child: _listViewBody());
  }
}

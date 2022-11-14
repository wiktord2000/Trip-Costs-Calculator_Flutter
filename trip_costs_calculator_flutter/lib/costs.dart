import 'package:flutter/material.dart';

class CostsPage extends StatefulWidget {
  const CostsPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  State<CostsPage> createState() => _CostsPageState();
}

class _CostsPageState extends State<CostsPage> {
  void _onAddPassenger() {
    setState(() {});
  }

  final ScrollController _homeController = ScrollController();

  static const TextStyle labelsStyling =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static const InputDecoration smallInputDec = InputDecoration(
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(4.0, 4.0, 12.0, 4.0),
      border: OutlineInputBorder(),
      hintText: '0');

  Widget _passengerCard(String passengerName, int mealage) {
    return Container(
      child: Text(passengerName),
    );
  }

  Widget _inputWithLabel(String labelText, String inputText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(
          flex: 2,
          child: Text(
            labelText,
            style: labelsStyling,
          ),
        ),
        Flexible(
            flex: 1,
            child: Row(
              children: [
                const Flexible(
                    child: SizedBox(
                  height: 30.0,
                  width: 50.0,
                  child: TextField(
                      textAlign: TextAlign.right, decoration: smallInputDec),
                )),
                Text('   $inputText'),
              ],
            ))
      ]),
    );
  }

  Widget _controlsBody() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 50.0),
      color: const Color.fromARGB(255, 232, 234, 237),
      child: Column(
        children: [
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  "Pasażerowie",
                  style: labelsStyling,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              children: [
                const Flexible(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Imie'),
                  ),
                ),
                const Flexible(
                  flex: 1,
                  child: TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                        suffixIconConstraints:
                            BoxConstraints(minWidth: 0, minHeight: 0),
                        suffixIcon: Text(" km"),
                        border: InputBorder.none,
                        hintText: '0'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Dodaj pasażera',
                  onPressed: _onAddPassenger,
                ),
              ],
            ),
          ),
          Column(
            children: const [
              Text(
                "Inputi",
                style: labelsStyling,
              ),
              Text(
                "Inputi",
                style: labelsStyling,
              ),
              Text(
                "Inputi",
                style: labelsStyling,
              ),
            ],
          ),
          _inputWithLabel("Cena paliwa:", "zł"),
          _inputWithLabel("Spalanie:", "l/100km"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Koszty dodatkowe",
                  style: labelsStyling,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return _controlsBody();
  }
}

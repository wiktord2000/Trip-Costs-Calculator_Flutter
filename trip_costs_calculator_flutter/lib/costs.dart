import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CostsPage extends StatefulWidget {
  const CostsPage({super.key, this.updateFuelCost, this.updateCombustion});

  // ignore: prefer_typing_uninitialized_variables
  final updateFuelCost;
  // ignore: prefer_typing_uninitialized_variables
  final updateCombustion;

  @override
  State<CostsPage> createState() => _CostsPageState();
}

class _CostsPageState extends State<CostsPage> {
  // --------------------------- Functions & Variables
  String passengerData = '';
  int error = 0;

  void _onAddPassenger(String name, String mealage) {
    if (name != "" && double.parse(mealage) > 0) {
      setState(() {
        passengerData = '$name $mealage';
      });
    } else {
      setState(() {
        error = error + 1;
      });
    }
  }

  void _onFuelCostChange(String value) {
    widget.updateFuelCost(double.parse(value));
  }

  void _onCombustionChange(String value) {
    widget.updateCombustion(double.parse(value));
  }

  // --------------------------- Styling
  static TextStyle labelsStyling =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static const InputDecoration smallInputDec = InputDecoration(
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(4.0, 4.0, 12.0, 4.0),
      border: OutlineInputBorder());

  static BoxShadow basicCardShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.1),
    spreadRadius: 1,
    blurRadius: 4,
    offset: const Offset(0, 0), // changes position of shadow
  );

  // --------------------------- Widgets
  Widget _complexInput(String placeholder, String suffix,
      void Function(String fstValue, String sndValue) onAddClick) {
    final fstInputController = TextEditingController();
    final sndInputController = TextEditingController();

    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [basicCardShadow],
      ),
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: TextField(
              controller: fstInputController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: placeholder),
            ),
          ),
          Flexible(
            flex: 1,
            child: TextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              controller: sndInputController..text = "0",
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                suffixIconConstraints:
                    const BoxConstraints(minWidth: 0, minHeight: 0),
                suffixIcon: Text(suffix),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              onAddClick(fstInputController.text, sndInputController.text);
            },
          ),
        ],
      ),
    );
  }

  Widget _universalCard(
      String name, int value, String suffix, Function onDeleteClick) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [basicCardShadow],
        ),
        width: double.infinity,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name),
            Row(
              children: [
                Text('$value $suffix'),
                IconButton(
                  color: Colors.black,
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    onDeleteClick();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _simpleLabel(String text) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            text,
            style: labelsStyling,
          ),
        ),
      ],
    );
  }

  Widget _inputWithLabel(String labelText, String inputText,
      Function(String value) onValueChange) {
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
                Flexible(
                    child: SizedBox(
                  height: 30.0,
                  width: 50.0,
                  child: TextFormField(
                      initialValue: "0.0",
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      onChanged: (value) {
                        onValueChange(value);
                      },
                      textAlign: TextAlign.right,
                      decoration: smallInputDec),
                )),
                Text('   $inputText'),
              ],
            ))
      ]),
    );
  }

  // --------------------------- Content

  Widget _controlsBody() {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 114.0,
      ),
      padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 50.0),
      color: const Color.fromARGB(255, 232, 234, 237),
      child: Column(
        children: [
          _simpleLabel("Pasażerowie"),
          _complexInput("Nazwa pasażera", " km", _onAddPassenger),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                    child: _universalCard("User", index, "km", () {}));
              },
              itemCount: 5,
            ),
          ),
          _inputWithLabel("Cena paliwa:", "zł", _onFuelCostChange),
          _inputWithLabel("Spalanie:", "l/100km", _onCombustionChange),
          _simpleLabel("Koszty dodatkowe"),
          _complexInput("Nazwa kosztu dodatkowego", " zł", _onAddPassenger),
          Text('This is passanger data: $passengerData'),
          Text('Number of errors: $error'),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Center(child: _universalCard("User", index, "zł", () {}));
            },
            itemCount: 5,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _controlsBody());
  }
}

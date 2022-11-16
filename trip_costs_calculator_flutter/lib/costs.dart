import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';

class CostsPage extends StatefulWidget {
  const CostsPage(
      {super.key,
      required this.updateFuelPrice,
      required this.updateCombustion,
      required this.fuelPrice,
      required this.combustion,
      required this.passengers,
      required this.addPassenger,
      required this.deletePassenger,
      required this.addAdditionalCost,
      required this.deleteAdditionalCost,
      required this.additionalCosts});

  // ignore: prefer_typing_uninitialized_variables
  final updateFuelPrice;
  // ignore: prefer_typing_uninitialized_variables
  final updateCombustion;
  // ignore: prefer_typing_uninitialized_variables
  final List<Passenger> passengers;
  // ignore: prefer_typing_uninitialized_variables
  final addPassenger;
  // ignore: prefer_typing_uninitialized_variables
  final deletePassenger;
  // ignore: prefer_typing_uninitialized_variables
  final addAdditionalCost;
  // ignore: prefer_typing_uninitialized_variables
  final deleteAdditionalCost;
  // ignore: prefer_typing_uninitialized_variables
  final fuelPrice;
  // ignore: prefer_typing_uninitialized_variables
  final combustion;
  // ignore: prefer_typing_uninitialized_variables
  final List<AdditionalCost> additionalCosts;

  @override
  State<CostsPage> createState() => _CostsPageState();
}

class _CostsPageState extends State<CostsPage> {
  // --------------------------- Functions & Variables

  // Passenger add & delete
  void _onAddPassenger(String name, String mealage) {
    if (name != "" && int.parse(mealage) > 0) {
      setState(() {
        widget.addPassenger(Passenger(name: name, mealage: int.parse(mealage)));
      });
    }
  }

  void _onDeletePassenger(String id) {
    setState(() {
      widget.deletePassenger(id);
    });
  }

  // AdditionalCost add & delete
  void _onAddAdditionalCost(String name, String price) {
    if (name != "" && double.parse(price) > 0) {
      setState(() {
        widget.addAdditionalCost(
            AdditionalCost(name: name, price: double.parse(price)));
      });
    }
  }

  void _onDeleteAdditionalCost(String id) {
    setState(() {
      widget.deleteAdditionalCost(id);
    });
  }

  void _onFuelCostChange(String value) {
    widget.updateFuelPrice(double.parse(value));
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
      Function(String fstValue, String sndValue) onAddClick) {
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

  Widget _universalCard(String id, String name, double value, bool isPassenger,
      Function(String id) onDeleteClick) {
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
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                Text(
                    '${isPassenger ? value.toInt() : value} ${isPassenger ? "km" : "zł"}'),
                IconButton(
                  color: Colors.black,
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    onDeleteClick(id);
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
      Function(String value) onValueChange, String initialValue) {
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    child: SizedBox(
                  height: 30.0,
                  width: 50.0,
                  child: TextFormField(
                      initialValue: initialValue,
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
                    child: _universalCard(
                        widget.passengers[index].id,
                        widget.passengers[index].name,
                        widget.passengers[index].mealage.toDouble(),
                        true,
                        _onDeletePassenger));
              },
              itemCount: widget.passengers.length,
            ),
          ),
          _inputWithLabel("Cena paliwa:", "zł", _onFuelCostChange,
              widget.fuelPrice.toString()),
          _inputWithLabel("Spalanie:", "l/100km", _onCombustionChange,
              widget.combustion.toString()),
          _simpleLabel("Koszty dodatkowe"),
          _complexInput(
              "Nazwa kosztu dodatkowego", " zł", _onAddAdditionalCost),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                  child: _universalCard(
                      widget.additionalCosts[index].id,
                      widget.additionalCosts[index].name,
                      widget.additionalCosts[index].price,
                      false,
                      _onDeleteAdditionalCost));
            },
            itemCount: widget.additionalCosts.length,
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

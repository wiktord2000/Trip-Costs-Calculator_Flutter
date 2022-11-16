import 'dart:ffi';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:trip_costs_calculator_flutter/main.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({
    super.key,
    required this.passengers,
    required this.passengersFuelCosts,
    required this.additionalCostsSumPerPassenger,
    required this.additionalCostsPerPassenger,
    required this.additionalCostsSum,
    required this.fuelCost,
  });

  final List<Passenger> passengers;
  final List<double> passengersFuelCosts;
  final List<AdditionalCost> additionalCostsPerPassenger;
  final double additionalCostsSumPerPassenger;
  final double additionalCostsSum;
  final double fuelCost;

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  // Styling
  static BoxShadow basicCardShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.4),
    spreadRadius: 8,
    blurRadius: 16,
    offset: const Offset(0, 0), // changes position of shadow
  );

  static const Color mainBlue = Color.fromRGBO(0, 107, 150, 1.0);
  static const Color labelGrey = Color.fromRGBO(242, 242, 242, 1.0);

  static const TextStyle passengerName =
      TextStyle(color: mainBlue, fontSize: 24, fontWeight: FontWeight.w500);

  static const TextStyle mealageCount = TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0.6),
      fontSize: 20,
      fontWeight: FontWeight.w500);

  static const TextStyle sectionLabelText = TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0.45), fontWeight: FontWeight.w600);

  // Widgets
  Widget _sectionLabel(String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: labelGrey,
        borderRadius: BorderRadius.circular(1000.0),
      ),
      child: Text(
        label,
        style: sectionLabelText,
      ),
    );
  }

  Widget _sumLabel(double padding, String text, double sum, bool primary) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.fromLTRB(16.0, padding, 26.0, padding),
      width: double.infinity,
      decoration: BoxDecoration(
        color: primary ? mainBlue : labelGrey,
        borderRadius: BorderRadius.circular(1000.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: primary
                ? const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)
                : TextStyle(
                    color: Colors.black.withOpacity(0.45),
                    fontWeight: FontWeight.w600),
          ),
          Text("${sum.toStringAsFixed(2)} zł",
              style: primary
                  ? const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)
                  : TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w700))
        ],
      ),
    );
  }

  Widget _costLabel(String name, double price) {
    return Container(
        margin: const EdgeInsets.fromLTRB(26.0, 6.0, 26.0, 12.0),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(name), Text("${price.toStringAsFixed(2)} zł")],
            ),
            const DottedLine(
              dashColor: Colors.grey,
            )
          ],
        ));
  }

  Widget _card(String name, int mealage, double additionalCostsSum,
      double fuelCost, List<AdditionalCost> additionalCosts) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [basicCardShadow],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(name, style: passengerName),
                  Text(
                    '$mealage km',
                    style: mealageCount,
                  )
                ],
              ),
            ),
            _sectionLabel("Koszty paliwa"),
            _costLabel("Paliwo", fuelCost),
            if (additionalCosts.isNotEmpty) _sectionLabel("Koszty dodatkowe"),
            ListView.builder(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                      child: _costLabel(additionalCosts[index].name,
                          additionalCosts[index].price));
                },
                itemCount: additionalCosts.length),
            _sumLabel(8.0, "SUMA", additionalCostsSum + fuelCost, true),
          ],
        ));
  }

  Widget _summaryContainer(double fuelCost, double additionalCostsSum) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6.0),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 4.0, color: mainBlue),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(horizontal: 28.0),
            child: const Text("Podsumowanie",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              children: [
                _sumLabel(8.0, "Koszty paliwa", fuelCost, false),
                _sumLabel(8.0, "Koszty dodatkowe", additionalCostsSum, false),
                _sumLabel(10.0, "SUMA", fuelCost + additionalCostsSum, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listViewBody() {
    return Container(
      color: Colors.grey[400],
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 114.0,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6.0, 12.0, 6.0, 12.0),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                      child: _card(
                          widget.passengers[index].name,
                          widget.passengers[index].mealage,
                          widget.additionalCostsSumPerPassenger,
                          widget.passengersFuelCosts[index],
                          widget.additionalCostsPerPassenger));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Padding(padding: EdgeInsets.only(bottom: 12.0)),
                itemCount: widget.passengersFuelCosts.length),
          ),
          _summaryContainer(widget.fuelCost, widget.additionalCostsSum),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _listViewBody());
  }
}

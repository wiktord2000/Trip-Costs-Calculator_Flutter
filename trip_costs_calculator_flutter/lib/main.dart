import 'dart:math';

import 'package:flutter/material.dart';
import 'costs.dart';
import 'calculate.dart';

void main() {
  runApp(const MyApp());
}

class Passenger {
  String id = "P_${Random().nextDouble()}";
  String name;
  double mealage = 0.0;

  Passenger({required this.name, required this.mealage});
}

class AdditionalCost {
  String id = "AC_${Random().nextDouble()}";
  String name;
  double price = 0.0;

  AdditionalCost({required this.name, required this.price});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Trip Costs Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title}); // Uwaga: Wywaliłem const, żebby passangers działało

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Page change functionality
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Passengers list
  final List<Passenger> passangers = [
    Passenger(name: "Wiktor", mealage: 120),
    Passenger(name: "Szymon", mealage: 80),
    Passenger(name: "Adrian", mealage: 60)
  ];
  void _addPassenger(Passenger passenger) {
    setState(() {
      passangers.add(passenger);
    });
  }

  void _deletePassenger(String id) {
    setState(() {
      passangers.removeWhere((element) => element.id == id);
    });
  }

  // Additional Costs list
  final List<AdditionalCost> additionalCosts = [
    AdditionalCost(name: "Autostrada", price: 150.0),
    AdditionalCost(name: "Postój", price: 80.0),
    AdditionalCost(name: "Stłuczka", price: 660.0)
  ];
  void _addAdditionalCost(AdditionalCost additionalCost) {
    setState(() {
      additionalCosts.add(additionalCost);
    });
  }

  void _deleteAdditionalCost(String id) {
    setState(() {
      additionalCosts.removeWhere((element) => element.id == id);
    });
  }

  // Fuel cost
  double _fuelPrice = 0.0;
  void _updateFuelPrice(double price) {
    setState(() {
      _fuelPrice = price;
    });
  }

  // Combustion
  double _combustion = 0.0;
  void _updateCombustion(double combustion) {
    setState(() {
      _combustion = combustion;
    });
  }

  static const List<int> passengers = <int>[5, 7, 4, 8, 5];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(child: Text(widget.title)),
      ),
      body: <Widget>[
        CostsPage(
            passengers: passangers,
            addPassenger: _addPassenger,
            deletePassenger: _deletePassenger,
            additionalCosts: additionalCosts,
            addAdditionalCost: _addAdditionalCost,
            deleteAdditionalCost: _deleteAdditionalCost,
            updateFuelPrice: _updateFuelPrice,
            updateCombustion: _updateCombustion), // CostsPage
        const CalculatePage(passengers: passengers) // CalculatePage
      ].elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Koszty',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Podziel',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

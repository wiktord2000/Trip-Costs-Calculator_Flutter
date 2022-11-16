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
  int mealage = 0;

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
      required this.title}); // Uwaga: Wywaliłem const, żebby passengers działało

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Additional Costs list
  List<AdditionalCost> additionalCosts = [
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

  // Passengers list
  List<Passenger> passengers = [
    Passenger(name: "Wiktor", mealage: 120),
    Passenger(name: "Szymon", mealage: 80),
    Passenger(name: "Adrian", mealage: 60)
  ];
  void _addPassenger(Passenger passenger) {
    setState(() {
      passengers.add(passenger);
    });
  }

  void _deletePassenger(String id) {
    setState(() {
      passengers.removeWhere((element) => element.id == id);
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

  // Page change functionality
  int _selectedIndex = 0;
  // To compute when view change
  List<AdditionalCost> additionalCostsPerPassenger = [];
  double additionalCostsSumPerPassenger = 0.0;
  List<double> passengersFuelCosts = [];
  double additionalCostsSum = 0.0;
  double fuelCost = 0.0;

  void _onItemTapped(int index) {
    setState(() {
      // Target page index
      _selectedIndex = index;
    });

    // Compute fuel cost per passenger
    List<Passenger> sortedPassengers = List.from(passengers);
    sortedPassengers.sort((a, b) => a.mealage - b.mealage);

    int lastMealage = 0;
    double lastFuelCost = 0.0;
    passengersFuelCosts = List.filled(sortedPassengers.length, 0.0);

    while (sortedPassengers.isNotEmpty) {
      Passenger currPass = sortedPassengers[0];
      int index = passengers.indexWhere((element) => element.id == currPass.id);

      double nextIntervalPrice =
          (currPass.mealage - lastMealage) * (_fuelPrice * _combustion / 100);
      double currFuelCost =
          lastFuelCost + nextIntervalPrice / sortedPassengers.length;

      lastMealage = currPass.mealage;
      lastFuelCost = currFuelCost;

      passengersFuelCosts[index] = currFuelCost;
      sortedPassengers.removeAt(0);
    }

    // Compute fuel cost
    fuelCost = 0.0;
    for (var element in passengersFuelCosts) {
      fuelCost += element;
    }

    // Additional cost per passenger
    additionalCostsPerPassenger = additionalCosts
        .map((e) =>
            AdditionalCost(name: e.name, price: e.price / passengers.length))
        .toList();

    // Sum of additional costs
    additionalCostsSum = 0.0;
    for (var element in additionalCosts) {
      additionalCostsSum += element.price;
    }
    // Sum of additional costs per passenger
    additionalCostsSumPerPassenger = 0.0;
    for (var element in additionalCostsPerPassenger) {
      additionalCostsSumPerPassenger += element.price;
    }
  }

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
          passengers: passengers,
          addPassenger: _addPassenger,
          deletePassenger: _deletePassenger,
          additionalCosts: additionalCosts,
          addAdditionalCost: _addAdditionalCost,
          deleteAdditionalCost: _deleteAdditionalCost,
          updateFuelPrice: _updateFuelPrice,
          updateCombustion: _updateCombustion,
          combustion: _combustion,
          fuelPrice: _fuelPrice,
        ), // CostsPage
        CalculatePage(
          additionalCostsPerPassenger: additionalCostsPerPassenger,
          passengers: passengers,
          passengersFuelCosts: passengersFuelCosts,
          additionalCostsSumPerPassenger: additionalCostsSumPerPassenger,
          additionalCostsSum: additionalCostsSum,
          fuelCost: fuelCost,
        ) // CalculatePage
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

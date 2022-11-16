import 'package:flutter/material.dart';
import 'costs.dart';
import 'calculate.dart';

void main() {
  runApp(const MyApp());
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

  // Fuel cost
  double _fuelCost = 0.0;
  void _updateFuelCost(double price) {
    setState(() {
      _fuelCost = price;
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
        title: Center(child: Text('Fuel: $_fuelCost , Comb: $_combustion')),
      ),
      body: <Widget>[
        CostsPage(
            updateFuelCost: _updateFuelCost,
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

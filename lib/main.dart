import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const MyHomePage(title: 'Business Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<UserFormState> _formKey = GlobalKey<UserFormState>();

  void calculateProfit() {
    final profit = _formKey.currentState!.calc();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Profit'),
        content: Text('Your Profit is: \$${profit.toStringAsFixed(2)}'),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Business Calculator",
          style: TextStyle(
              color: Color(0xff0d0d0d),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          UserForm(key: _formKey),
          Spacer(),  // This pushes the button towards the end.
          // Or use SizedBox for a fixed height like: SizedBox(height: 50),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15, horizontal: 30)), // Padding for the button
              minimumSize: MaterialStateProperty.all(Size(200, 60)), // Minimum size for the button
            ),
            onPressed: calculateProfit,
            child: Text('Calculate Profit!'),
          ),
          SizedBox(height: 30), // Additional space after the button.
        ],
      ),
    );
  }
}

class UserForm extends StatefulWidget {
  UserForm({Key? key}) : super(key: key);

  @override
  UserFormState createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  final laborCostController = TextEditingController();
  final rentCostController = TextEditingController();
  final resourcesCostController = TextEditingController();
  final totalRevenueController = TextEditingController();

  double calc() {
    double labor = double.parse(laborCostController.text.isNotEmpty ? laborCostController.text : "0");
    double rent = double.parse(rentCostController.text.isNotEmpty ? rentCostController.text : "0");
    double resources = double.parse(resourcesCostController.text.isNotEmpty ? resourcesCostController.text : "0");
    double total = double.parse(totalRevenueController.text.isNotEmpty ? totalRevenueController.text : "0");

    return total - (labor + rent + resources);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildTextFormField(
            'Enter Labor Cost:', laborCostController),
        buildTextFormField(
            'Enter Rent Cost:', rentCostController),
        buildTextFormField(
            'Enter Resources Cost:', resourcesCostController),
        buildTextFormField('Total Revenue:', totalRevenueController),
      ],
    );
  }

  Widget buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        ],
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}

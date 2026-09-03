import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  double _firstOperand = 0;
  String _operator = '';
  bool _shouldResetDisplay = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _firstOperand = 0;
        _operator = '';
        _shouldResetDisplay = false;
      } else if (value == '+' || value == '-' || value == '*' || value == '/') {
        _firstOperand = double.tryParse(_display) ?? 0;
        _operator = value;
        _shouldResetDisplay = true;
      } else if (value == '=') {
        if (_operator.isNotEmpty) {
          final secondOperand = double.tryParse(_display) ?? 0;
          double result = 0;

          switch (_operator) {
            case '+':
              result = _firstOperand + secondOperand;
              break;
            case '-':
              result = _firstOperand - secondOperand;
              break;
            case '*':
              result = _firstOperand * secondOperand;
              break;
            case '/':
              result = secondOperand != 0 ? _firstOperand / secondOperand : 0;
              break;
          }

          _display = result % 1 == 0 ? result.toInt().toString() : result.toStringAsFixed(2);
          _operator = '';
          _shouldResetDisplay = true;
        }
      } else {
        if (_display == '0' || _shouldResetDisplay) {
          _display = value;
          _shouldResetDisplay = false;
        } else {
          _display += value;
        }
      }
    });
  }

  Widget _buildButton(String text, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[200],
            foregroundColor: color != null ? Colors.white : Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 22),
            textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          onPressed: () => _onButtonPressed(text),
          child: Text(text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Kalkulator'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _display,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('/', color: Colors.orange),
                ]),
                Row(children: [
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('*', color: Colors.orange),
                ]),
                Row(children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('-', color: Colors.orange),
                ]),
                Row(children: [
                  _buildButton('C', color: Colors.redAccent),
                  _buildButton('0'),
                  _buildButton('=', color: Colors.green),
                  _buildButton('+', color: Colors.orange),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

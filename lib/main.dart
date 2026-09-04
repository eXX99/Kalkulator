import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
  String _equation = '';
  double _firstOperand = 0;
  String _operator = '';
  bool _shouldResetDisplay = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _startBackgroundMusic();
  }

  void _startBackgroundMusic() async {
  await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  await _audioPlayer.setVolume(0.5);
  await _audioPlayer.play(AssetSource('nurek.mp3')); 
  // audioplayers SAM wstawi 'assets/' przed 'nurek.mp3'
  }


  void _toggleMusic() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _equation = '';
        _firstOperand = 0;
        _operator = '';
        _shouldResetDisplay = false;
      } else if (value == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
      } else if (value == '.') {
        if (!_display.contains('.')) _display += '.';
      } else if (value == '+' || value == '-' || value == '×' || value == '÷') {
        _firstOperand = double.tryParse(_display) ?? 0;
        _operator = value;
        _equation = '$_display $value';
        _shouldResetDisplay = true;
      } else if (value == '=') {
        if (_operator.isNotEmpty) {
          final secondOperand = double.tryParse(_display) ?? 0;
          double result = 0;
          switch (_operator) {
            case '+': result = _firstOperand + secondOperand; break;
            case '-': result = _firstOperand - secondOperand; break;
            case '×': result = _firstOperand * secondOperand; break;
            case '÷': result = secondOperand != 0 ? _firstOperand / secondOperand : 0; break;
          }
          _equation = '$_firstOperand $_operator $secondOperand =';
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

  Widget _buildGlassButton(String text, {Color? customColor, int flex = 1}) {
    final isAccent = customColor != null;
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Material(
              color: customColor ?? Colors.white.withOpacity(0.12),
              child: InkWell(
                onTap: () => _onButtonPressed(text),
                splashColor: Colors.white24,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isAccent ? Colors.transparent : Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/ciulik.jpeg',
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Kalkulator',
                        style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.volume_up : Icons.volume_off,
                          color: _isPlaying ? Colors.tealAccent : Colors.white54,
                        ),
                        onPressed: _toggleMusic,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.18)),
                          ),
                          alignment: Alignment.bottomRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(_equation, style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.7))),
                              const SizedBox(height: 6),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _display,
                                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              _buildGlassButton('C', customColor: Colors.redAccent.withOpacity(0.4)),
                              _buildGlassButton('⌫'),
                              _buildGlassButton('.'),
                              _buildGlassButton('÷', customColor: Colors.amber.withOpacity(0.5)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildGlassButton('7'),
                              _buildGlassButton('8'),
                              _buildGlassButton('9'),
                              _buildGlassButton('×', customColor: Colors.amber.withOpacity(0.5)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildGlassButton('4'),
                              _buildGlassButton('5'),
                              _buildGlassButton('6'),
                              _buildGlassButton('-', customColor: Colors.amber.withOpacity(0.5)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildGlassButton('1'),
                              _buildGlassButton('2'),
                              _buildGlassButton('3'),
                              _buildGlassButton('+', customColor: Colors.amber.withOpacity(0.5)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildGlassButton('0', flex: 2),
                              _buildGlassButton('=', customColor: Colors.tealAccent.withOpacity(0.5), flex: 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

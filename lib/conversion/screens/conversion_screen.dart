
import 'package:flutter/material.dart';
import 'package:project/conversion/models/conversion_type.dart';
import 'package:project/conversion/utils/converter.dart';

class ConversionScreen extends StatefulWidget {
  final ConversionType type;
  final String? initialValue;

  const ConversionScreen({
    super.key,
    required this.type,
    this.initialValue,
  });

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  late List<String> units;
  late String fromUnit;
  late String toUnit;
  late String inputText;
  String outputText = '';

  @override
  void initState() {
    super.initState();
    inputText = widget.initialValue ?? '0';
    _setupUnits();
    fromUnit = units[0];
    toUnit = units[1];
    _convert();
  }

  void _setupUnits() {
    switch (widget.type) {
      case ConversionType.temperature:
        units = ['°C', '°F', 'K'];
        break;
      case ConversionType.length:
        units = ['km', 'm', 'cm', 'mm', 'mil', 'kaki', 'inci'];
        break;
      case ConversionType.weight:
        units = ['kg', 'g', 'lbs', 'ons'];
        break;
      case ConversionType.time:
        units = ['jam', 'menit', 'detik', 'ms'];
    }
  }

  void _convert() {
    if (inputText.isEmpty) {
      outputText = '0';
      return;
    }

    try {
      final value = double.parse(inputText);
      double result;
      switch (widget.type) {
        case ConversionType.temperature:
          result = Converter.convertTemperature(value, fromUnit, toUnit);
          break;
        case ConversionType.length:
          result = Converter.convertLength(value, fromUnit, toUnit);
          break;
        case ConversionType.weight:
          result = Converter.convertWeight(value, fromUnit, toUnit);
          break;
        case ConversionType.time:
          result = Converter.convertTime(value, fromUnit, toUnit);
      }

      // Format hasil
      outputText = result.toStringAsFixed(result == result.toInt() ? 0 : 4);
    } catch (e) {
      outputText = 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konversi ${widget.type.label}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input
            TextField(
              decoration: InputDecoration(
                labelText: 'Nilai',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                inputText = value;
                _convert();
              },
              controller: TextEditingController(text: inputText),
            ),
            const SizedBox(height: 20),

            // From
            DropdownButtonFormField<String>(
              value: fromUnit,
              items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    fromUnit = value;
                    _convert();
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Dari'),
            ),
            const SizedBox(height: 16),

            // To
            DropdownButtonFormField<String>(
              value: toUnit,
              items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    toUnit = value;
                    _convert();
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Ke'),
            ),
            const SizedBox(height: 30),

            // Hasil
            Text(
              'Hasil: $outputText',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
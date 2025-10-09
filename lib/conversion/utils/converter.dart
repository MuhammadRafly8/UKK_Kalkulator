
class Converter {
  // 🔥 Suhu: Celsius ↔ Fahrenheit ↔ Kelvin
  static double convertTemperature(double value, String from, String to) {
    // Konversi ke Celsius dulu
    double celsius;
    if (from == '°C') {
      celsius = value;
    } else if (from == '°F') {
      celsius = (value - 32) * 5 / 9;
    } else if (from == 'K') {
      celsius = value - 273.15;
    } else {
      return value;
    }

    // Konversi dari Celsius ke target
    if (to == '°C') return celsius;
    if (to == '°F') return celsius * 9 / 5 + 32;
    if (to == 'K') return celsius + 273.15;
    return value;
  }

  // 📏 Panjang: km, m, cm, mm, mil, kaki, inci
  static double convertLength(double value, String from, String to) {
    final meters = _lengthToMeters(value, from);
    return _metersToLength(meters, to);
  }

  static double _lengthToMeters(double value, String unit) {
    switch (unit) {
      case 'km': return value * 1000;
      case 'm': return value;
      case 'cm': return value / 100;
      case 'mm': return value / 1000;
      case 'mil': return value * 1609.34;
      case 'kaki': return value * 0.3048;
      case 'inci': return value * 0.0254;
      default: return value;
    }
  }

  static double _metersToLength(double meters, String unit) {
    switch (unit) {
      case 'km': return meters / 1000;
      case 'm': return meters;
      case 'cm': return meters * 100;
      case 'mm': return meters * 1000;
      case 'mil': return meters / 1609.34;
      case 'kaki': return meters / 0.3048;
      case 'inci': return meters / 0.0254;
      default: return meters;
    }
  }

  // ⚖️ Berat: kg, g, lbs, ons
  static double convertWeight(double value, String from, String to) {
    final grams = _weightToGrams(value, from);
    return _gramsToWeight(grams, to);
  }

  static double _weightToGrams(double value, String unit) {
    switch (unit) {
      case 'kg': return value * 1000;
      case 'g': return value;
      case 'lbs': return value * 453.592;
      case 'ons': return value * 100;
      default: return value;
    }
  }

  static double _gramsToWeight(double grams, String unit) {
    switch (unit) {
      case 'kg': return grams / 1000;
      case 'g': return grams;
      case 'lbs': return grams / 453.592;
      case 'ons': return grams / 100;
      default: return grams;
    }
  }

  // ⏱️ Waktu: jam, menit, detik, milidetik
  static double convertTime(double value, String from, String to) {
    final seconds = _timeToSeconds(value, from);
    return _secondsToTime(seconds, to);
  }

  static double _timeToSeconds(double value, String unit) {
    switch (unit) {
      case 'jam': return value * 3600;
      case 'menit': return value * 60;
      case 'detik': return value;
      case 'ms': return value / 1000;
      default: return value;
    }
  }

  static double _secondsToTime(double seconds, String unit) {
    switch (unit) {
      case 'jam': return seconds / 3600;
      case 'menit': return seconds / 60;
      case 'detik': return seconds;
      case 'ms': return seconds * 1000;
      default: return seconds;
    }
  }
}
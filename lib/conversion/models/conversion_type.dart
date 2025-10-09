
enum ConversionType {
  temperature('Suhu'),
  length('Panjang'),
  weight('Berat'),
  time('Waktu');

  final String label;
  const ConversionType(this.label);
}
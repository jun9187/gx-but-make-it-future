String formatCurrency(num value) {
  final whole = value.toStringAsFixed(0);
  final chars = whole.split('').reversed.toList();
  final buffer = StringBuffer();

  for (var i = 0; i < chars.length; i++) {
    if (i > 0 && i % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(chars[i]);
  }

  return 'RM ${buffer.toString().split('').reversed.join()}';
}

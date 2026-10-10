/// Pone en mayúscula la primera letra ("cielo despejado" -> "Cielo despejado").
String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

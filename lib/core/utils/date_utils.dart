/// Utilidades de fecha y hora en español (sin paquetes externos).
const _weekdays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
const _months = [
  'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
  'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
];

/// Convierte un instante UNIX (segundos, UTC) a la hora local de la ciudad,
/// sumando el desplazamiento `timezone` (segundos) que entrega la API.
DateTime cityTime(int unixSeconds, int timezoneOffsetSeconds) {
  return DateTime.fromMillisecondsSinceEpoch(
    (unixSeconds + timezoneOffsetSeconds) * 1000,
    isUtc: true,
  );
}

String shortWeekday(DateTime d) => _weekdays[d.weekday - 1];

String shortMonth(DateTime d) => _months[d.month - 1];

/// "Lun, 23 de Sep de 2025"
String formatLongDate(DateTime d) =>
    '${shortWeekday(d)}, ${d.day} de ${shortMonth(d)} de ${d.year}';

/// "23 Sep"
String formatShortDate(DateTime d) => '${d.day} ${shortMonth(d)}';

/// "5:50 AM"
String formatTime12h(DateTime d) {
  final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final minutes = d.minute.toString().padLeft(2, '0');
  final suffix = d.hour < 12 ? 'AM' : 'PM';
  return '$hour12:$minutes $suffix';
}
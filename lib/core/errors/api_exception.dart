/// Excepción propia de la capa de datos. Lleva un mensaje listo
/// para mostrarse al usuario en la pantalla de error.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
/// Devuelve un texto apto para el usuario a partir de cualquier error.
String messageFrom(Object error) =>
    error is ApiException ? error.message : 'Ocurrió un error inesperado.';
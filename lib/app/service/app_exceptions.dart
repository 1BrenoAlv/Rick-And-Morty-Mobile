/// Exceção base para erros do app.
sealed class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Sem conexão com a internet (SocketException, timeout, etc.)
class NoInternetException extends AppException {
  const NoInternetException([
    super.message = 'Sem conexão com a internet. Verifique sua rede.',
  ]);
}

/// Timeout na requisição (demorou demais para responder).
class RequestTimeoutException extends AppException {
  const RequestTimeoutException([
    super.message = 'A requisição demorou demais. Tente novamente.',
  ]);
}

/// API retornou 404 — nenhum resultado encontrado para os filtros.
class NotFoundException extends AppException {
  const NotFoundException([
    super.message = 'Nenhum personagem encontrado.',
  ]) : super(statusCode: 404);
}

/// API retornou 429 — muitas requisições (rate limit).
class TooManyRequestsException extends AppException {
  const TooManyRequestsException([
    super.message = 'Muitas requisições. Aguarde um momento.',
  ]) : super(statusCode: 429);
}

/// API retornou erro 5xx — servidor indisponível.
class ServerException extends AppException {
  const ServerException([
    super.message = 'Serviço temporariamente indisponível. Tente mais tarde.',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

/// Erro genérico / inesperado.
class UnknownApiException extends AppException {
  const UnknownApiException([
    super.message = 'Ocorreu um erro inesperado. Tente novamente.',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

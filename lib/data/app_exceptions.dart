class AppExceptions implements Exception {
  final String _message;
  final String _prefix;

  AppExceptions(this._message, this._prefix);

  @override
  String toString() {
    final String seperator = _prefix.isEmpty ? '' : ': ';
    return _prefix + seperator + _message;
  }
}

class InternetException extends AppExceptions {
  InternetException(String message) : super(message, 'No Internet');
}

class RequestTimedOutException extends AppExceptions {
  RequestTimedOutException(String message)
      : super(message, 'Request Timed Out');
}

class ServerException extends AppExceptions {
  ServerException(String message) : super(message, 'Internal Server Error');
}

class BadRequestException extends AppExceptions {
  BadRequestException(String message) : super(message, '');
}

class NotFoundException extends AppExceptions {
  NotFoundException(String message) : super(message, 'Not Found');
}

class UnauthorizedException extends AppExceptions {
  UnauthorizedException(String message) : super(message, 'Unauthorized');
}

class GeneralException extends AppExceptions {
  GeneralException(String message)
      : super(message, 'Error while communicating with server');
}

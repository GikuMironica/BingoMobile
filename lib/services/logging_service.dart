import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class LoggingService {
  final Logger _logger;

  LoggingService() : _logger = Logger();

  Logger get logger => _logger;
}

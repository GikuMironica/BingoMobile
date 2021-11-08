import 'package:logger/logger.dart' as LoggerLib;

class LoggingService {
  static LoggingService _loggingService;
  List<Logger> _loggerList;

  factory LoggingService(){
    return _loggingService ??= LoggingService._();
  }

  LoggingService._(){
    _loggerList = [];
  }

  Logger getLogger(Type T){
    for(var logger in _loggerList){
      if(logger.className == (T.runtimeType).toString()){
        return logger;
      }
    }
    var logger = Logger((T.runtimeType).toString());
    _loggerList.add(logger);
    return logger;
  }
}

class Logger extends LoggerLib.Logger {
  final String className;

  Logger(this.className) : super(printer: LoggerLib.SimplePrinter(printTime: true));
}
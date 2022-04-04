class RequestResult {
  dynamic data;
  bool isSuccessful;
  String? errorMessage;

  RequestResult({this.data, required this.isSuccessful, this.errorMessage});
}

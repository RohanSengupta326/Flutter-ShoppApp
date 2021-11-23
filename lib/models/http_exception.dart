class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
    /* return super.toString(); */
    // as this function is built in every class and returns this , so here i changed that with override
  }
}

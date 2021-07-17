//WE can creae our own custom errors in flutter
//WE can directly use the Exception class to create an exception but it is recommended by flutter to implement a custom one like this
class HttPExceptions implements Exception{
  final String message;
  HttPExceptions(this.message);

  @override
    String toString() {
      // TODO: implement toString
      return message;//Configuring this class so that it always returns a String(error message) when called
      // return super.toString();
    }
}
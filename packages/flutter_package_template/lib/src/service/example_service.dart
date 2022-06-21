import 'package:get/get_connect/connect.dart';

class ExampleService extends GetConnect {
  // Get request
  Future<Response> getUser(int id) => get('http://youapi/users/$id');
  // Post request

  GetSocket userMessages() {
    return socket('https://yourapi/users/socket');
  }
}
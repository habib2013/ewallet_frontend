import 'package:dio/dio.dart';
import 'package:wallet_app/models/transaction_history_source.dart';


class WalletRepository {
  static String userUrl = 'http://192.168.137.1:8000';
  static String bleytUrl = 'https://api.bleyt.com/v1';
  final _merchantToken = 'sk_sandbox_VbYQ9ZixkTqhZaz1zRcX7yNsyfSUJMI9hI6uPO8nt6KiX4EF';

  final Dio _dio = Dio();

   var getCustomerTransactions = '$bleytUrl/wallet/transactions';

  Future<TransactionResponse> getTransactions(String userId) async {
    // https://api.bleyt.com/v1/wallet/transactions?customerId=95b4348e-18d3-4b04-9636-9e9a8c220397&page=1&type=ALL
    var params = {
      "customerId" : userId,
      "PAGE": 1,
      "TYPE": 'ALL',


    };

    try{
      _dio.options.headers['content-Type'] = 'application/json';
       _dio.options.headers['Authorization'] = 'Bearer ${_merchantToken}';
      Response response = await _dio.get(getCustomerTransactions,queryParameters: params);
      // print(response.data);
      return TransactionResponse.fromJson(response.data);

    }
    catch(error){
    return TransactionResponse.withError(error);
    }
  }

}
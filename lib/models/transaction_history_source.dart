// import 'package:news_api_project/model/article.dart';

import 'package:wallet_app/models/transaction_history.dart';

class TransactionResponse {
  final List<TransactionHistoryModel> transactions;
  final String error;


  TransactionResponse(this.transactions,this.error);
  TransactionResponse.fromJson(Map<String,dynamic> json)
      : transactions = (json["transactions"] as List).map((i) => new TransactionHistoryModel.fromJson(i)).toList(),
        error = "";

  TransactionResponse.withError(String errorValue)
      : transactions = List(),
        error = errorValue;

}
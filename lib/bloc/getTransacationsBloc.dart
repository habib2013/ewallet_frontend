
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wallet_app/models/transaction_history_source.dart';
import 'package:wallet_app/repository/repository.dart';

class GetTransactionsBloc{
final WalletRepository _walletRepository = WalletRepository();

final BehaviorSubject<TransactionResponse> _subject =
        BehaviorSubject<TransactionResponse>();

getTransactions(String userId) async{
  TransactionResponse response = await _walletRepository.getTransactions(userId);
  _subject.sink.add(response);
  print(response);
}

dispose(){
  _subject.close();
}

BehaviorSubject<TransactionResponse> get subject => _subject;

}

final getTransactionsBloc = GetTransactionsBloc();
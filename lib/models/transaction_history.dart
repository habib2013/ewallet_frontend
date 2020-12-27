class TransactionHistoryModel {

  final String id;
  final String userId;
  final String category;

  final String currency;
  final String metadata;
  final int balance_after;
  final String source;
  final String destination;
  final dynamic Transactiontype;
  final String createdAt;
  final String updatedAt;

  final int amount;
  final int balance_before;
  final String reference;
  final String description;

  final String date_created;

  TransactionHistoryModel(this.id,this.userId,this.category,this.currency,this.metadata,this.balance_after,this.source,this.destination,this.Transactiontype,this.createdAt,this.updatedAt,this.amount,this.reference,this.description,this.balance_before,this.date_created);

  TransactionHistoryModel.fromJson(Map<String,dynamic> json)
      : id = json["id"],
        userId = json["userId"],
        category = json["category"],
        currency = json["currency"],
        metadata = json["metadata"],
        balance_after = json["balance_after"],
        source = json["source"],
        destination = json["destination"],
        Transactiontype = json["type"],
        createdAt = json["createdAt"],
        updatedAt = json["updatedAt"],

      amount = json["amount"],
        balance_before = json["balance_before"],
        reference = json["reference"],
        description = json["description"],

        date_created = json["date"];
}
import 'package:flutter/material.dart';
import 'package:wallet_app/models/credit_card_model.dart';
import 'package:wallet_app/models/payment_model.dart';
import 'package:wallet_app/models/user_model.dart';


List<PaymentModel> getPaymentsCard() {
  Map<String, dynamic> data = {
    "transactions": [
      {
        "id": "5070142e-c9a1-42a5-b1f2-f52d15c420d1",
        "userId": "c46a7836-5762-45ee-98b1-0e63359a22f0",
        "category": "WALLET_DEBITED_BY_MERCHANT",
        "currency": "NGN",
        "amount": 20000,
        "metadata": null,
        "balance_after": 88900,
        "balance_before": 108900,
        "reference": "QBwbBXH8dCgLdIKnD2vlnK7xY",
        "source": "0489d66d-c33d-4143-8fcf-4994a6b907dd",
        "destination": "tkhgnfjdn562trip1",
        "type": "DEBIT",
        "description": "Account was debited by Merchant",
        "mode": "SANDBOX",
        "status": "success",
        "fee": null,
        "createdAt": "2020-12-07T19:22:08.399Z",
        "updatedAt": "2020-12-07T19:22:08.399Z"
      },
      {
        "id": "fa3fb726-9e41-42a3-b49b-742a491182d3",
        "userId": "c46a7836-5762-45ee-98b1-0e63359a22f0",
        "category": "WALLET_DEBITED_BY_MERCHANT",
        "currency": "NGN",
        "amount": 100000,
        "metadata": null,
        "balance_after": 108900,
        "balance_before": 208900,
        "reference": "yTWTEqc3GqcQL9YFXgGAoaN5V",
        "source": "0489d66d-c33d-4143-8fcf-4994a6b907dd",
        "destination": "tkhgnfjdn562tripe",
        "type": "DEBIT",
        "description": "Account was debited by Merchant",
        "mode": "SANDBOX",
        "status": "success",
        "fee": null,
        "createdAt": "2020-12-07T19:03:06.317Z",
        "updatedAt": "2020-12-07T19:03:06.317Z"
      },
      {
        "id": "50d29b1e-6162-4a15-b8ab-ef48821d1b77",
        "userId": "c46a7836-5762-45ee-98b1-0e63359a22f0",
        "category": "WALLET_DEBITED_BY_MERCHANT",
        "currency": "NGN",
        "amount": 1000,
        "metadata": null,
        "balance_after": 208900,
        "balance_before": 209900,
        "reference": "yvQd01BbcjOAbgtvoXVEt1x57",
        "source": "0489d66d-c33d-4143-8fcf-4994a6b907dd",
        "destination": "1607344833612",
        "type": "DEBIT",
        "description": "Account was debited by Merchant",
        "mode": "SANDBOX",
        "status": "success",
        "fee": null,
        "createdAt": "2020-12-07T12:40:36.018Z",
        "updatedAt": "2020-12-07T12:40:36.018Z"
      },
      {
        "id": "8e23c3d8-ffad-4b83-b7ae-d492e9ac6201",
        "userId": "c46a7836-5762-45ee-98b1-0e63359a22f0",
        "category": "WALLET_CREDITED_BY_MERCHANT",
        "currency": "NGN",
        "amount": 100000,
        "metadata": null,
        "balance_after": 209900,
        "balance_before": 109900,
        "reference": "OXKBmvB3wRn7REE1xVW0Q1Uqv",
        "source": "1607344736866",
        "destination": "0489d66d-c33d-4143-8fcf-4994a6b907dd",
        "type": "CREDIT",
        "description": "N100000 was credited by the Merchant",
        "mode": "SANDBOX",
        "status": "success",
        "fee": null,
        "createdAt": "2020-12-07T12:38:58.140Z",
        "updatedAt": "2020-12-07T12:38:58.140Z"
      },
      {
        "id": "044521c3-1d52-4644-b1b7-c36a8ecbd161",
        "userId": "c46a7836-5762-45ee-98b1-0e63359a22f0",
        "category": "WALLET_DEBITED_BY_MERCHANT",
        "currency": "NGN",
        "amount": 200,
        "metadata": null,
        "balance_after": 109900,
        "balance_before": 110100,
        "reference": "znGxuwG3s7SM2hIFDIN4zJFKv",
        "source": "0489d66d-c33d-4143-8fcf-4994a6b907dd",
        "destination": "1607268338354",
        "type": "DEBIT",
        "description": "Account was debited by Merchant",
        "mode": "SANDBOX",
        "status": "success",
        "fee": null,
        "createdAt": "2020-12-06T15:25:38.108Z",
        "updatedAt": "2020-12-06T15:25:38.108Z"
      },
      {
        "id": "5101f368-1781-49c5-b2e7-ee2828228605",
        "userId": "c46a7836-5762-45ee-98b1-0e63359a22f0",
        "category": "WALLET_CREDITED_BY_MERCHANT",
        "currency": "NGN",
        "amount": 100,
        "metadata": null,
        "balance_after": 110100,
        "balance_before": 110000,
        "reference": "wNeHTTYDyweQTyOXnIhUf0J9x",
        "source": "1607268328474",
        "destination": "0489d66d-c33d-4143-8fcf-4994a6b907dd",
        "type": "CREDIT",
        "description": "N100 was credited by the Merchant",
        "mode": "SANDBOX",
        "status": "success",
        "fee": null,
        "createdAt": "2020-12-06T15:25:28.271Z",
        "updatedAt": "2020-12-06T15:25:28.271Z"
      },
      {
        "id": "b14e3b51-c1e5-430d-b1d7-c4c5e0a06a5d",
        "userId": "c46a7836-5762-45ee-98b1-0e63359a22f0",
        "category": "WALLET_CREDITED_BY_MERCHANT",
        "currency": "NGN",
        "amount": 100000,
        "metadata": null,
        "balance_after": 110000,
        "balance_before": 10000,
        "reference": "DQh8xcw37HvKjXyob5eHgbE8W",
        "source": "1607267822650",
        "destination": "0489d66d-c33d-4143-8fcf-4994a6b907dd",
        "type": "CREDIT",
        "description": "N100000 was credited by the Merchant",
        "mode": "SANDBOX",
        "status": "success",
        "fee": null,
        "createdAt": "2020-12-06T15:17:03.627Z",
        "updatedAt": "2020-12-06T15:17:03.627Z"
      },
      {
        "id": "55a2576d-9aad-4f4e-af86-81c465c5e965",
        "userId": "c46a7836-5762-45ee-98b1-0e63359a22f0",
        "category": "WALLET_CREDITED_BY_MERCHANT",
        "currency": "NGN",
        "amount": 10000,
        "metadata": null,
        "balance_after": 10000,
        "balance_before": 0,
        "reference": "hyVOFJdNBaKB24IxlgOmEKFVn",
        "source": "1607267656805",
        "destination": "0489d66d-c33d-4143-8fcf-4994a6b907dd",
        "type": "CREDIT",
        "description": "N10000 was credited by the Merchant",
        "mode": "SANDBOX",
        "status": "success",
        "fee": null,
        "createdAt": "2020-12-06T15:14:17.125Z",
        "updatedAt": "2020-12-06T15:14:17.125Z"
      }
    ],
  };


  List<dynamic> transRoles = data["transactions"];
  var length = transRoles.length;

    List<PaymentModel> paymentCards = new List<PaymentModel>();
  for(var i = 0;i < length;i++){
    paymentCards.add(
            PaymentModel(
          Icons.picture_as_pdf_rounded,
          Colors.black45,
          transRoles[i]['category'],
                transRoles[i]['type'],
          "14.01",
                transRoles[i]['amount'],
          -1)
    );
  }
    return paymentCards;

}

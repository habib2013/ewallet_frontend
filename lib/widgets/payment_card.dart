import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:wallet_app/models/payment_model.dart';

class PaymentCardWidget extends StatefulWidget {
  final PaymentModel payment;

  const PaymentCardWidget({Key key, this.payment}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PaymentCardWidgetState();
}

class _PaymentCardWidgetState extends State<PaymentCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        dense: true,
        trailing: Text(
          " \₦ ${widget.payment.amount}",
          style: TextStyle(
              inherit: true, fontWeight: FontWeight.bold, fontSize: 13.0,  color: widget.payment.date == 'DEBIT' ? Colors.red : Colors.green),
        ),
//        leading: Padding(
//          padding: const EdgeInsets.symmetric(horizontal: 0.0),
//          child: Material(
//            elevation: 10,
//            shape: CircleBorder(),
//            shadowColor: widget.payment.color.withOpacity(0.4),
//            child: Container(
//              height: 40,
//              width: 40,
//              decoration: BoxDecoration(
//                color: widget.payment.color,
//                shape: BoxShape.circle,
//              ),
//              child: ClipRRect(
//                borderRadius: BorderRadius.circular(8.0),
//                child: Icon(
//                  widget.payment.icon,
//                  color: Colors.white,
//                ),
//              ),
//            ),
//          ),
//        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.payment.name,
              style: TextStyle(
                  inherit: true, fontWeight: FontWeight.bold, fontSize: 14.0,color:  widget.payment.name == 'WALLET_DEBITED_BY_MERCHANT' ? Colors.red:Colors.green,fontFamily: 'ubuntu'),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.payment.date,
                  style: TextStyle(
                      inherit: true, fontSize: 11.0, color: widget.payment.date == 'DEBIT' ? Colors.red : Colors.green)),
              SizedBox(
                width: 20,
              ),
              Text(widget.payment.hour,
                  style: TextStyle(
                      inherit: true, fontSize: 11.0, color:  Colors.black)),
              SizedBox(
                width: 20,
              ),
              IconButton(icon: widget.payment.name == 'WALLET_DEBITED_BY_MERCHANT' ? Icon(FeatherIcons.trendingDown,color: Colors.black45,) : Icon(FeatherIcons.trendingUp,color: Colors.green,) , onPressed: (){
                print('preseed');
              }),
              SizedBox(
                width: 20,
              ),
              IconButton(icon: Icon(FeatherIcons.moreHorizontal,color: Colors.black45,), onPressed: (){
                print('preseed');
              }),

              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

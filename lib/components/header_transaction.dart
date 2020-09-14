import 'package:flutter/material.dart';
import 'package:markopi_mobile/pages/trades/transactions/history_transaction_screen.dart';

class HeaderTransaction extends StatelessWidget implements PreferredSizeWidget {
  final bool isHistory;

  const HeaderTransaction({Key key, this.isHistory}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: new IconThemeData(color: Colors.white),
      backgroundColor: Color(0xFF2696D6),
      title: Text(
        !isHistory? 'markopi':'markopi - riwayat',
        style: TextStyle(
            fontFamily: 'SF Pro Text',
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      actions: <Widget>[
        !isHistory? IconButton(
          icon: Icon(Icons.history, semanticLabel: 'search'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryTransactionScreen()));
          },
        ):Container(),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/converter.dart';
import 'package:markopi_mobile/helpers/custom_widget.dart';
import 'package:markopi_mobile/helpers/style.dart';
import 'package:markopi_mobile/route.dart';
import 'package:markopi_mobile/widgets/molecules/button_mol.dart';
import 'package:markopi_mobile/widgets/organisms/app_bar_org.dart';
import 'package:markopi_mobile/components/header_back.dart';

class PurchaseDetailScreen extends StatefulWidget {
  final bool hasAddress;

  const PurchaseDetailScreen({Key key, this.hasAddress}) : super(key: key);
  @override
  _PurchaseDetailScreenState createState() => _PurchaseDetailScreenState();
}

class _PurchaseDetailScreenState extends State<PurchaseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBack(),
      body: ListView(
        children: <Widget>[
          CustomWidget.emptyVSpace(15.0),
          widget.hasAddress
              ? _addressCard(
                  "Alexius Manik",
                  "(Kampus Institut Teknologi)",
                  "+62131238409182",
                  "Kampus Institut Teknologi Del Jl. Sisingamangaraja Sitoluama, Laguboti, Toba Samosir, 22381",
                )
              : _emptyAddressCard(),
          CustomWidget.emptyVSpace(10.0),
          _shippingDetailCard(),
        ],
      ),
      bottomSheet: _bottomCart(),
    );
  }

  Widget _emptyAddressCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomWidget.emptyVSpace(10.0),
            Text(
              "Belum ada alamat",
              style: Style16Grey,
            ),
            CustomWidget.emptyVSpace(30.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 35,
                child: MolButton(context).blueButton(
                    onPressed: () => Navigator.pushNamed(
                            context, AppRoute.PURCHASE_ADDRESS_LIST_ROUTE,
                            arguments: {
                              "hasAddress": false,
                              "hasTwoAddress": false
                            }),
                    child: Text(
                      "Pilih alamat lain",
                      style: Style14WhiteBold,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressCard(name, shortPlace, phone, place) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  name,
                  style: Style14BlackBold,
                ),
                CustomWidget.emptyHSpace(10.0),
                Expanded(
                    child: Text(
                  shortPlace,
                  style: Style14Black,
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),
            CustomWidget.emptyVSpace(10.0),
            Text(
              phone,
              style: Style14Grey,
            ),
            CustomWidget.emptyVSpace(10.0),
            Text(
              place,
              style: Style12Grey,
            )
          ],
        ),
      ),
    );
  }

  Widget _shippingDetailCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8)
            ]),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://as2.ftcdn.net/jpg/02/17/33/97/500_F_217339703_f8t8l574PCixzcWy4i1O64LR2MXQScYx.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                CustomWidget.emptyHSpace(15.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Kopi Robusta",
                      style: Style14BlackBold,
                    ),
                    Text(
                      "1 barang (10kg)",
                      style: Style14Grey,
                    ),
                    CustomWidget.emptyVSpace(10.0),
                    Text(
                      "Rp.850.000",
                      style: Style18Blue,
                    )
                  ],
                )
              ],
            ),
            CustomWidget.emptyVSpace(5.0),
            Divider(),
            CustomWidget.emptyVSpace(5.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Regular (2-4 hari)",
                      style: Style14BlackBold,
                    ),
                    CustomWidget.emptyVSpace(10.0),
                    Text(
                      "JNE",
                      style: Style14BlackBold,
                    ),
                    CustomWidget.emptyVSpace(10.0),
                    Text(
                      "Rp. 30.000",
                      style: Style14Black,
                    )
                  ],
                ),
                Container(
                  height: 35,
                  child: MolButton(context).blueButton(
                      onPressed: () => Navigator.pushNamed(
                          context, AppRoute.PURCHASE_COURIER_ROUTE),
                      child: Text(
                        "Ubah Pengiriman",
                        style: Style14WhiteBold,
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomCart() {
    return FractionallySizedBox(
      heightFactor: 0.15,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 25,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Harga Barang",
                    style: Style12Grey,
                  ),
                  Text(
                    Converter().priceFormat(880000),
                    style: Style14Blue,
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              child: MolButton(context).blueButton(
                  onPressed: () => widget.hasAddress
                      ? Navigator.pushNamed(
                          context, AppRoute.PURCHASE_PAYMENT_ROUTE)
                      : null,
                  child: Text(
                    "Pilih pembayaran",
                    style: Style14WhiteBold,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

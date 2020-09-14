import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:markopi_mobile/factory/models/products/product.dart';
import 'package:markopi_mobile/helpers/converter.dart';
import 'package:markopi_mobile/helpers/custom_widget.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/resources/trades/cart/bloc/cart_bloc.dart';
import 'package:markopi_mobile/resources/trades/cart/bloc/cart_event.dart';
import 'package:markopi_mobile/resources/trades/cart/bloc/cart_state.dart';
import 'package:markopi_mobile/route.dart';
import 'package:markopi_mobile/widgets/molecules/buttons/button_mol.dart';
import 'package:markopi_mobile/widgets/molecules/buttons/manipulate_product_mol.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CartBloc>(context)..add(LoadCart());
  }


  List<ProductModel> dummyData=[];

  int totalPrice=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HeaderBack(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:BlocBuilder<CartBloc, CartState>(
          builder:(context, state) {
            if(state is CartLoaded) {
              if(state.cart.products==null){
                return Container();
              }
              if(state.cart.products.length==0){
                return Container();

              }
              return Container(
                height: 80,
                color: Colors.grey[100],
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Harga Barang"),
                        Text("${Converter().priceFormat(state.cart.totalPrice.toDouble())}")
                      ],
                    ),
                    CustomWidget.emptyVSpace(10.0),
                    Container(
                      width: double.maxFinite,
                      height: 45,
                      child: MolButton(context)
                          .blueButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoute.PURCHASE_DETAIL_ROUTE,arguments: {"singleProducts":<ProductModel>[]});
                          },
                          child: Text(
                            "Beli Sekarang", style: Style14WhiteBold,)),
                    )
                  ],
                ),
              );
            }

            return Container();
          }
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {

              if (state.cart.products == null) {
                return Center(
                  child: Text("No Data"),
                );
              }

              if(state.cart.products.length==0){
                return Center(
                  child: Text("No Data"),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) =>
                    _buildCartItem(state.filteredProduct[index],state),
                separatorBuilder: (context, index) => Divider(),
                itemCount: state.filteredProduct.length,
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
    );
  }

  Widget _buildCartItem(ProductModel data,CartLoaded state) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: (){
        Navigator.pushNamed(context, AppRoute.SHOW_PRODUCT_ROUTE,
            arguments: {
              "isPurchaseMode": true,
              'productModel':data,
              'showButton':false
            });
      },
      child: Container(
        width: double.maxFinite,
        height: 100,
        padding: const EdgeInsets.all(5),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            _buildContentCartItem(data),
            ManipulateProductButtonMol(
              totalGoods: state.cart.products.where((element) => element.id==data.id).toList().length,
              onAddPressed: () {
                if (data.totalGoods != state.cart.products.where((element) => element.id==data.id).toList().length) {
                  BlocProvider.of<CartBloc>(context)
                    ..add(AddItem(context:context,item: data));
                  setState(() {});
                } else {
                  CustomWidget.showFlushBar(
                      context, "Stok hanya ${data.totalGoods}");
                }
              },
              onRemovePressed: () {
                    BlocProvider.of<CartBloc>(context)..add(RemoveItem(context: context,item: data));
                  setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCartItem(ProductModel data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 90,
          width: 90,
          child: FutureBuilder(
              future: FirebaseStorage.instance
                  .ref()
                  .child("product_images")
                  .child(data.images[0])
                  .getDownloadURL(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    imageUrl: snapshot.data,
                    fit: BoxFit.cover,
                  ),
                );
              }),
        ),
        CustomWidget.emptyHSpace(10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              CustomWidget.emptyVSpace(5.0),
              Text(
                data.type,
                style: TextStyle(color: Colors.grey),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: RichText(
                    text: TextSpan(
                        text: Converter().priceFormat(
                          data.price.toDouble(),
                        ),
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: "/${data.units}",
                              style: TextStyle(color: Colors.grey))
                        ]),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

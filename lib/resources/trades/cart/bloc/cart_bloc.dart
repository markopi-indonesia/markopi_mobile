

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markopi_mobile/factory/models/cart/cart.dart';
import 'package:markopi_mobile/resources/trades/cart/bloc/cart_event.dart';
import 'package:markopi_mobile/resources/trades/cart/bloc/cart_state.dart';

import '../../../data_cart_provider.dart';

class CartBloc extends Bloc<CartEvent,CartState>{
  @override
  // TODO: implement initialState
  CartState get initialState => CartLoading();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async*{

    if(event is AddItem){
      final currentState = state;
      if(currentState is CartLoaded){
        try{
          var carts =await DataCartProvider(event.context).getCartFromCache();
          if(carts!=null){
            carts.products..add(event.item);
            yield CartLoaded(
                cart: carts);
            print("TIDAK KOSONG");
            await DataCartProvider(event.context).saveCartToCache(carts);
          } else {
            print("KOSONG");
            CartModel cart = new CartModel(products: List.from(currentState.cart.products)..add(event.item));
            await DataCartProvider(event.context).saveCartToCache(cart);
            yield CartLoaded(cart: cart);
          }

        }catch (e){
          print(e.toString());
          yield CartError();
        }
      }
    }
    if(event is LoadCart){
      yield CartLoading();
      try{
        var carts =await DataCartProvider(event.context).getCartFromCache();
        if(carts!=null){
          print("AWALAN TIDAK NULL");
          yield CartLoaded(cart: carts);
        } else {
          print("AWALAN NULL");
          yield CartLoaded(cart: new CartModel(products:[]));
        }
      } catch (e){
        yield CartError();
      }
    }
    if(event is RemoveItem){
      final currentState = state;
      try{
        if(currentState is CartLoaded){
          var carts =await DataCartProvider(event.context).getCartFromCache();
          if(carts!=null){
            carts..products.remove(event.item);
            yield CartLoaded(
                cart: carts
            );
            await DataCartProvider(event.context).saveCartToCache(carts);

          } else {
            CartModel cart = new CartModel(products:List.from(currentState.cart.products)..remove(event.item));
            yield CartLoaded(cart: cart);
            await DataCartProvider(event.context).saveCartToCache(cart);
          }
        }
      } catch(e){
        yield CartError();
      }
    }

    if(event is ClearCart){
      final currentState =state;
      try{
        if(currentState is CartLoaded){
          var carts =await DataCartProvider(event.context).getCartFromCache();
          if(carts!=null){
            carts..products.clear();
            yield CartLoaded(
                cart: carts
            );
            await DataCartProvider(event.context).saveCartToCache(carts);
          } else {
            CartModel cart = new CartModel(products:List.from(currentState.cart.products)..clear());
            yield CartLoaded(cart: cart);
            await DataCartProvider(event.context).saveCartToCache(cart);
          }
        }
      } catch(e){

      }
    }

  }

}
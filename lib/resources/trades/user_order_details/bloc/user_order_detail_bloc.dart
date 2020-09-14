import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markopi_mobile/factory/models/order/user_detail.dart';
import 'package:markopi_mobile/factory/models/shipping/shipping_address.dart';
import 'package:markopi_mobile/factory/models/shipping/shipping_method.dart';
import 'package:markopi_mobile/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:markopi_mobile/resources/data_cart_provider.dart';
import 'package:markopi_mobile/resources/trades/user_order_details/bloc/user_order_detail_event.dart';
import 'package:markopi_mobile/resources/trades/user_order_details/bloc/user_order_detail_state.dart';

class UserOrderDetailBloc
    extends Bloc<UserOrderDetailEvent, UserOrderDetailState> {
  @override
  UserOrderDetailState get initialState => UserOrderDetailInitial();

  @override
  Stream<Transition<UserOrderDetailEvent, UserOrderDetailState>>
      transformEvents(Stream<UserOrderDetailEvent> events, transitionFn) {
    return super.transformEvents(
      events.debounceTime(Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<UserOrderDetailState> mapEventToState(
      UserOrderDetailEvent event) async* {
    if (event is UpdateUserOrderDetail) {
      final currentState = state;
      if (currentState is UserOrderDetailLoaded) {
        try{
        var userDetail =
            await DataCartProvider(event.context).getUserDetailCache();
        if (userDetail != null) {
          userDetail.user = event.user ?? currentState.userDetail.user;
          userDetail.chosenShippingIdMethod = event.chosenIdShippingMethod ??
              currentState.userDetail.chosenShippingIdMethod;
          userDetail.shippingAddresses = event.addressListModel ??
              currentState.userDetail.shippingAddresses;
          userDetail.chosenIdAddress =
              event.chosenIdAddress ?? currentState.userDetail.chosenIdAddress;
          userDetail.notes = event.notes ?? currentState.userDetail.notes;
          yield UserOrderDetailLoaded(userDetail: userDetail);
          await DataCartProvider(event.context)
              .saveUserDetailToCache(userDetail);
        } else {
          UserOrderDetailModel userDetail = new UserOrderDetailModel(
            user: event.user ?? currentState.userDetail.user,
            notes: event.notes ?? currentState.userDetail.notes,
            chosenIdAddress: event.chosenIdAddress ??
                currentState.userDetail.chosenIdAddress,
            chosenShippingIdMethod: event.chosenIdShippingMethod ??
                currentState.userDetail.chosenShippingIdMethod,
            shippingAddresses: event.addressListModel ??
                currentState.userDetail.shippingAddresses,
          );
          yield UserOrderDetailLoaded(userDetail: userDetail);
          await DataCartProvider(event.context)
              .saveUserDetailToCache(userDetail);
          print((await DataCartProvider(event.context).getUserDetailCache()).toJson());
        }

        }catch (e){
          print("Udpate User error : "+e.toString());
          yield UserOrderDetailError();
        }
      }
    }

    if (event is LoadUserOrderDetail) {
      yield UserOrderDetailLoading();
      try {
        var userDetail =
            await DataCartProvider(event.context).getUserDetailCache();
        if (userDetail != null) {
          yield UserOrderDetailLoaded(userDetail: userDetail);
        } else {
          yield UserOrderDetailLoaded(
            userDetail: new UserOrderDetailModel(
                chosenIdAddress: "",
                user: new UserModel(
                  name: "",
                  phoneNumber: "",
                  email: "",
                  id: "",
                ),
                chosenShippingIdMethod: 1,
                shippingAddresses: new ShippingAddressListModel(data: []),
                notes: ""),
          );
        }
      } catch (e) {
        print("Load User error : " + e.toString());
        yield UserOrderDetailError();
      }
    }
  }
}

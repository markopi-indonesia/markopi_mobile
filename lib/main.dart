import 'package:flutter/material.dart';
import 'package:markopi_mobile/pages/manage_user/index.dart';
import 'package:markopi_mobile/ui/menu/credit.dart';
import 'package:markopi_mobile/ui/menu/home.dart';
import 'package:markopi_mobile/ui/color/colors.dart';
import 'package:markopi_mobile/pages/authentication/register.dart';
import 'package:markopi_mobile/pages/authentication/login.dart';
import 'package:markopi_mobile/pages/profile/index.dart';
import 'package:markopi_mobile/pages/pengajuan_fasilitator/index_fasilitator.dart';
import 'package:markopi_mobile/pages/pengajuan_fasilitator/index_admin.dart';
import 'package:markopi_mobile/ui/menu/AnimatedSplashScreen.dart';
import 'package:markopi_mobile/route.dart';
import 'package:markopi_mobile/pages/trades/choose_path.dart';
import 'package:markopi_mobile/pages/trades/purchases/address/add_address_screen.dart';
import 'package:markopi_mobile/pages/trades/purchases/address/address_list_screen.dart';
import 'package:markopi_mobile/pages/trades/purchases/courier/courier_screen.dart';
import 'package:markopi_mobile/pages/trades/purchases/payment/payment_proof_screen.dart';
import 'package:markopi_mobile/pages/trades/purchases/payment/payment_screen.dart';
import 'package:markopi_mobile/pages/trades/purchases/payment/payment_uploaded_screen.dart';
import 'package:markopi_mobile/pages/trades/purchases/purchase_detail_screen.dart';
import 'package:markopi_mobile/pages/trades/sales/manipulate_product/manipulate_product.dart';
import 'package:page_transition/page_transition.dart';

import 'pages/trades/current_products/current_product_screen.dart';
import 'pages/trades/purchases/purchase_screen.dart';
import 'pages/trades/sales/manipulate_product/product_summary.dart';
import 'pages/trades/show_product/show_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'markopi_mobile',
      theme: _markopi_mobileTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => AnimatedSplashScreen(),
        '/home': (context) => HomePage(),
        '/register': (context) => Register(),
        '/login': (context) => Login(),
        '/manage-user': (context) => ManageUser(),
        '/profile': (context) => IndexProfileDialog(),
        '/pengajuan_fasilitator': (context) => PengajuanFasilitator(),
        '/pengajuan_fasilitator_admin': (context) =>
            PengajuanFasilitatorAdmin(),
        '/credit': (context) => Credit(),
      },
      onGenerateRoute: _routes(),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case AppRoute.TRADE_ROUTE:
          screen = ChoosePathScreen();
          break;
        case AppRoute.CURRENT_PRODUCT_ROUTE:
          screen = CurrentProductScreen(isPurchaseMode: arguments['isPurchaseMode'],);
          break;
        case AppRoute.MANIPULATE_PRODUCT_ROUTE:
          screen = ManipulateProductScreen(isEdit: arguments['isEdit'],);
          break;
        case AppRoute.PRODUCT_SUMMARY_ROUTE:
          screen = ProductSummaryScreen();
          break;
        case AppRoute.SHOW_PRODUCT_ROUTE:
          screen = ShowProductScreen(isPurchaseMode: arguments['isPurchaseMode'],);
          break;
        case AppRoute.PURCHASE_ROUTE:
          screen = PurchaseScreen();
          break;
        case AppRoute.PURCHASE_DETAIL_ROUTE:
          screen = PurchaseDetailScreen(hasAddress: arguments['hasAdress'],);
          break;
        case AppRoute.PURCHASE_ADDRESS_LIST_ROUTE:
          screen = PurchaseAddressListScreen(hasAddress: arguments['hasAddress'],hasTwoAddress: arguments['hasTwoAddress'],);
          break;
        case AppRoute.PURCHASE_ADD_ADDRESS_ROUTE:
          screen = PurchaseAddAddressScreen(twoAddress: arguments['twoAddress'],);
          break;
        case AppRoute.PURCHASE_COURIER_ROUTE:
          screen = PurchaseCourierScreen();
          break;
        case AppRoute.PURCHASE_PAYMENT_ROUTE:
          screen = PurchasePaymentScreen();
          break;
        case AppRoute.PURCHASE_PROOF_ROUTE:
          screen = PaymentProofScreen();
          break;
        case AppRoute.PURCHASE_UPLOADED_PROOF_ROUTE:
          screen = PaymentUploadedProofScreen();
          break;
        default:
          return null;
      }
      return PageTransition(child: screen,type: PageTransitionType.rightToLeftWithFade,alignment: Alignment.topCenter,duration: Duration(milliseconds: 300));
    };
  }
}

final ThemeData _markopi_mobileTheme = _buildmarkopi_mobileTheme();

ThemeData _buildmarkopi_mobileTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    primaryColor: kShrineBackgroundWhite,
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    errorColor: kShrineErrorRed,
    primaryIconTheme: base.iconTheme.copyWith(color: kShrineAltBlack),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline.copyWith(
          fontWeight: FontWeight.w500,
        ),
        title: base.title.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: kShrineAltBlack,
        bodyColor: kShrineAltBlack,
      );
}

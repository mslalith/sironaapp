import 'package:flutter/material.dart';
import 'package:medical_shop/providers/addresses.dart';
import 'package:medical_shop/providers/banners.dart';
import 'package:medical_shop/providers/locations.dart';
import 'package:medical_shop/providers/offers.dart';
import 'package:medical_shop/providers/orders.dart';
import 'package:medical_shop/providers/profile.dart';
import 'package:medical_shop/providers/units.dart';
import 'package:medical_shop/screens/aboutUs.dart';
import 'package:medical_shop/screens/addAddress.dart';
import 'package:medical_shop/screens/addPin.dart';
import 'package:medical_shop/screens/addPlaceScreen.dart';
import 'package:medical_shop/screens/authPage.dart';
import 'package:medical_shop/screens/imgOrder.dart';
import 'package:medical_shop/screens/itemOrder.dart';
import 'package:medical_shop/screens/listReceipts.dart';
import 'package:medical_shop/screens/manageAddress.dart';
import 'package:medical_shop/screens/orderScreen.dart';
import 'package:medical_shop/screens/otpPage.dart';
import 'package:medical_shop/screens/profileDisplay.dart';
import 'package:medical_shop/screens/refer.dart';
import 'package:medical_shop/screens/signInScreen.dart';
import 'package:medical_shop/screens/signUpScreen.dart';
import 'package:medical_shop/screens/splashScreen.dart';
import 'package:medical_shop/screens/uploadPrescription.dart';
import 'package:medical_shop/screens/viewOrder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:medical_shop/screens/prescription.dart';
import 'package:medical_shop/screens/tabsScreen.dart';

import 'providers/auth.dart';
import 'screens/addProfile.dart';
import 'screens/confirmOrder.dart';
import 'screens/imageOrder.dart';
import 'screens/notifications.dart';
import 'screens/orderListScreen.dart';
import './screens/authScreen.dart';
import 'screens/prescriptionOrder.dart';
import 'screens/profile.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, OrderList>(
            update: (ctx, auth, previousOrders) => previousOrders..auth = auth,
            create: (BuildContext context) {
              return OrderList();
            },
          ),
          ChangeNotifierProxyProvider<Auth, Profile>(
            update: (ctx, auth, profile) => profile..auth = auth,
            create: (BuildContext context) {
              return Profile();
            },
          ),
          ChangeNotifierProxyProvider<Auth, UnitList>(
            update: (ctx, auth, previousUnits) => previousUnits..auth = auth,
            create: (BuildContext context) {
              return UnitList();
            },
          ),
          ChangeNotifierProxyProvider<Auth, BannerList>(
            update: (ctx, auth, previousBanners) =>
                previousBanners..auth = auth,
            create: (BuildContext context) {
              return BannerList();
            },
          ),
          ChangeNotifierProxyProvider<Auth, OfferList>(
            update: (ctx, auth, previousOffers) => previousOffers..auth = auth,
            create: (BuildContext context) {
              return OfferList();
            },
          ),
          ChangeNotifierProxyProvider<Auth, LocationList>(
            update: (ctx, auth, previousLocations) =>
                previousLocations..auth = auth,
            create: (BuildContext context) {
              return LocationList();
            },
          ),
          ChangeNotifierProxyProvider<Auth, AddressList>(
            update: (ctx, auth, previousAddress) =>
                previousAddress..auth = auth,
            create: (BuildContext context) {
              return AddressList();
            },
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            home: auth.isAuth
                ? TabsScreen()
                // ? ViewOrder()
                // : auth.isUser ? LoginScreen() : SignUpScreen() ,
                : FutureBuilder(
                    future: auth.tryAutoLogin(ctx),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthPage()),
            routes: {
              TabsScreen.routeName: (ctx) => TabsScreen(),
              Prescription.routeName: (ctx) => Prescription(),
              OrderListScreen.routeName: (ctx) => OrderListScreen(),
              AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              ItemOrder.routeName: (ctx) => ItemOrder(),
              ImgOrder.routeName: (ctx) => ImgOrder(),
              ConfirmOrder.routeName: (ctx) => ConfirmOrder(),
              ProfileDetail.routeName: (ctx) => ProfileDetail(),
              AddProfile.routeName: (ctx) => AddProfile(),
              ViewOrder.routeName: (ctx) => ViewOrder(),
              SignInScreen.routeName: (ctx) => SignInScreen(),
              SignUpScreen.routeName: (ctx) => SignUpScreen(),
              OtpPage.routeName: (ctx) => OtpPage(),
              UploadPrescription.routeName: (ctx) => UploadPrescription(),
              PrescriptionOrders.routeName: (ctx) => PrescriptionOrders(),
              AddPin.routeName: (ctx) => AddPin(),
              AddAddress.routeName: (ctx) => AddAddress(),
              DisplayProfile.routeName: (ctx) => DisplayProfile(),
              ListReceipts.routeName: (ctx) => ListReceipts(),
              ManageAddress.routeName: (ctx) => ManageAddress(),
              NotificationPage.routeName: (ctx) => NotificationPage(),
              ReferPage.routeName: (ctx) => ReferPage(),
              AboutUs.routeName: (ctx) => AboutUs()
            },
            theme: ThemeData(fontFamily: 'Roboto'),
          ),
        ));
  }
}

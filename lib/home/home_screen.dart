import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/MyWidgets/cart_icon_btn.dart';
import 'package:my_smartstore/MyWidgets/notification_icon_btn.dart';
import 'package:my_smartstore/home/fragments/cart_fragment/cart_fragment.dart';
import 'package:my_smartstore/home/fragments/home_fragment/home_fragment.dart';
import 'package:my_smartstore/home/fragments/orders_fragment/orders_fragment.dart';
import 'package:my_smartstore/home/fragments/wishlist_fragment/wishlist_fragment.dart';
import 'package:my_smartstore/home/fragments/wishlist_fragment/wishlist_fragment_cubit.dart';

import '../notifications/notifications_cubit.dart';
import '../notifications/notifications_screen.dart';
import '../registration/authentication/auth_cubit.dart';
import '../registration/authentication/auth_state.dart';
import 'fragments/account_fragment/account_fragment.dart';
import 'fragments/cart_fragment/cart_fragment_cubit.dart';
import 'fragments/orders_fragment/orders_fragment_cubit.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomeScreen extends StatefulWidget {
  final drawerItems = [
    DrawerItem('Home', Icons.home),
    DrawerItem('My Orders', Icons.shopping_bag),
    DrawerItem('My Cart', Icons.shopping_cart),
    DrawerItem('My Wishlist', Icons.favorite_outlined),
    DrawerItem('My Account', Icons.account_circle),
  ];

  //declare home.fragments here
  final HomeFragment _homeFragment = HomeFragment();
  final WishlistFragment _wishlistFragment = WishlistFragment();
  final OrdersFragment _ordersFragment = OrdersFragment();
  final CartFragment _cartFragment = CartFragment(null, false);
  final AccountFragment _accountFragment = AccountFragment();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: _selectedDrawerIndex == 0
            ? [
                NotificationIconBtn(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider(
                            create: (_) => NotificationsCubit(),
                            child: NotificationsScreen())));
                  },
                ),
                CartIconBtn(
                  onPressed: () {
                    setState(() {
                      _selectedDrawerIndex = 2;
                    });
                  },
                ),
              ]
            : null,
        titleSpacing: 0,
        title: _selectedDrawerIndex == 0
            ? Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 50,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text('MySmartStore')
                ],
              )
            : Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
            child: Column(
          children: _createDrawerOptions(),
        )),
      ),
      body: _getDrawerItemFragment(_selectedDrawerIndex),
    );
  }

  _createDrawerOptions() {
    String email = 'Email', name = "Fullname";
    AuthState authState = BlocProvider.of<AuthCubit>(context).state;
    if (authState is Authenticated) {
      email = authState.userdata.email!;
      name = authState.userdata.fullname!;
    }

    var drawerOptions = <Widget>[
      UserAccountsDrawerHeader(
          accountName: Text(name), accountEmail: Text(email))
    ];

    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];

      drawerOptions.add(Container(
          child: ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () {
          setState(() {
            _selectedDrawerIndex = i;
          });
          Navigator.pop(context);
        },
      )));
    }

    return drawerOptions;
  }

  _getDrawerItemFragment(int selectedDrawerIndex) {
    switch (selectedDrawerIndex) {
      case 0:
        return widget._homeFragment;
      case 1:
        return BlocProvider(
            create: (_) => OrdersFragmentCubit(),
            child: widget._ordersFragment);
      case 2:
        return BlocProvider(
            create: (_) => CartFragmentCubit(), child: widget._cartFragment);
      case 3:
        return BlocProvider(
            create: (_) => WishlistFragmentCubit(),
            child: widget._wishlistFragment);
      case 4:
        return widget._accountFragment;
      default:
        return Text('Error');
    }
  }
}

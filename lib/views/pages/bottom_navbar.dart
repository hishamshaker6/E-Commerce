import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onlinestore/controllers/cart/cart_cubit.dart';
import 'package:onlinestore/controllers/favorite/favorite_cubit.dart';
import 'package:onlinestore/controllers/home/home_cubit.dart';
import 'package:onlinestore/controllers/profile/profile_cubit.dart';
import 'package:onlinestore/services/profile_services.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/views/pages/cart_page.dart';
import 'package:onlinestore/views/pages/favorite_page.dart';
import 'package:onlinestore/views/pages/home_page.dart';
import 'package:onlinestore/views/pages/profile_page.dart';
import 'package:onlinestore/views/pages/shop/shop_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final _bottomNavbarController = PersistentTabController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (context) {
            final homeCubit = HomeCubit();
            homeCubit.getHomeContent();
            return homeCubit;
          },
        ),
        BlocProvider<CartCubit>(
          create: (context) {
            final cartCubit = CartCubit();
            cartCubit.getCartItems();
            return cartCubit;
          },
        ),
        BlocProvider<FavoriteCubit>(
          create: (context) {
            final favoriteCubit = FavoriteCubit();
            favoriteCubit.getFavoriteItems();
            return favoriteCubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final profileCubit = ProfileCubit(ProfileServices());
            profileCubit.loadUserData();
            return profileCubit;
          },
        ),
      ],
      child: Scaffold(
        body: PersistentTabView(
          controller: _bottomNavbarController,
          tabs: [
            PersistentTabConfig(
              screen: const HomePage(),
              item: ItemConfig(
                icon: const Icon(Icons.home),
                title: "Home",
                activeForegroundColor: AppColors.colorRed,
              ),
            ),
            PersistentTabConfig(
              screen: const ShopPage(),
              item: ItemConfig(
                icon: const Icon(Icons.shopping_cart),
                title: "Shop",
                activeForegroundColor:AppColors.colorRed,
              ),
            ),
            PersistentTabConfig(
              screen: const CartPage(),
              item: ItemConfig(
                icon: const Icon(Icons.shopping_bag),
                title: "Cart",
                activeForegroundColor: AppColors.colorRed,
              ),
            ),
            PersistentTabConfig(
              screen: const FavoritePage(),
              item: ItemConfig(
                icon: const Icon(Icons.favorite),
                title: "Favorite",
                activeForegroundColor: AppColors.colorRed,
              ),
            ),
            PersistentTabConfig(
              screen: const ProfilePage(),
              item: ItemConfig(
                icon: const Icon(Icons.person),
                title: "Profile",
                activeForegroundColor: AppColors.colorRed,
              ),
            ),
          ],
          navBarBuilder: (navbarConfig) => Style1BottomNavBar(
            navBarConfig: navbarConfig,
          ),
          backgroundColor: AppColors.colorWhite,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          screenTransitionAnimation: const ScreenTransitionAnimation(
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
        ),
      ),
    );
  }
}

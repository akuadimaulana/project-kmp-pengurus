import 'dart:ui';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kmp_pengurus_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_pengurus_app/features/dues_report/presentation/pages/dues_report_page.dart';
import 'package:kmp_pengurus_app/features/financial/presentation/pages/financial_statement_page.dart';
import 'package:kmp_pengurus_app/features/profile/presentation/pages/profile_page.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';
import 'package:kmp_pengurus_app/theme/icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kmp_pengurus_app/env.dart';
import 'package:kmp_pengurus_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:kmp_pengurus_app/framework/blocs/messaging/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // ignore: unused_field
  bool _isInternetConnected = true;
  late PersistentTabController _controller;

  @override
  void dispose() {
    super.dispose();
  }

  late TabController controller;
  int _currentIndex = 0;

  final List<Widget> _children = [
    DashboardPage(),
    DuesReportPage(),
    FinancialStatementPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    controller = new TabController(
      vsync: this,
      length: 3,
    );
  }

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          inactiveIcon: SvgIcon(
            'assets/icon/home.svg',
          ),
          icon: Stack(
            children: [
              Center(
                child: SvgIcon(
                  'assets/icon/homeactive.svg',
                  color: ColorPalette.primary,
                ),
              ),
            ],
          ),
          activeColorPrimary: ColorPalette.primary,
          inactiveColorPrimary: ColorPalette.disabledBTextolor),
      PersistentBottomNavBarItem(
          inactiveIcon: SvgIcon(
            'assets/icon/news.svg',
            color: ColorPalette.disabledBTextolor,
          ),
          icon: SvgIcon(
            'assets/icon/newsactive.svg',
            color: ColorPalette.primary,
          ),
          activeColorPrimary: ColorPalette.primary,
          inactiveColorPrimary: ColorPalette.disabledBTextolor),
      PersistentBottomNavBarItem(
          inactiveIcon: SvgIcon(
            'assets/icon/chart.svg',
            color: ColorPalette.disabledBTextolor,
          ),
          icon: SvgIcon(
            'assets/icon/chartactive.svg',
            color: ColorPalette.primary,
          ),
          activeColorPrimary: ColorPalette.primary,
          inactiveColorPrimary: ColorPalette.disabledBTextolor),
      PersistentBottomNavBarItem(
          inactiveIcon: CircleAvatar(
              radius: 13,
              child:
                  // ValueListenableBuilder<Box<dynamic>>(
                  //     valueListenable:
                  //         Hive.box<dynamic>(HiveDbServices.boxLoggedInUser)
                  //             .listenable(),
                  //     builder: (context, boxy, widget) {
                  //       var userString = boxy.get('user');
                  //       var user = userModelFromJson(userString!);
                  //       return user.avatar!.isNotEmpty
                  //           ? CircleAvatar(
                  //               radius: 14,
                  //               backgroundColor: Colors.white,
                  //               backgroundImage: NetworkImage(
                  //                 '${Env().apiBaseUrl}/${user.avatar}',
                  //               ),
                  //             )
                  //           :
                  CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xffDD4041),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundImage:
                            AssetImage("assets/images/profile.png"),
                      ))
              // }),
              ),
          icon:
              // ValueListenableBuilder<Box<dynamic>>(
              //     valueListenable: Hive.box<dynamic>(HiveDbServices.boxLoggedInUser)
              //         .listenable(),
              //     builder: (context, boxy, widget) {
              //       var userString = boxy.get('user');
              //       var user = userModelFromJson(userString!);
              //       return user.avatar!.isNotEmpty
              //           ? CircleAvatar(
              //               radius: 14,
              //               backgroundColor: Color(0xffDD4041),
              //               child: CircleAvatar(
              //                 radius: 12,
              //                 backgroundColor: Colors.white,
              //                 backgroundImage: NetworkImage(
              //                   '${Env().apiBaseUrl}/${user.avatar}',
              //                 ),
              //               ),
              //             )
              //           :
              CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xffDD4041),
            child: CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage("assets/images/profile.png"),
            ),
          ),
          // }),
          activeColorPrimary: ColorPalette.primary,
          inactiveColorPrimary: ColorPalette.disabledBTextolor),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessagingBloc, MessagingState>(
      listener: (context, state) {
        if (state is InMessagingState) {
          print('[InMessagingState] Messaging: ${state.message}');
        } else if (state is InternetConnectionState) {
          _isInternetConnected = state.isConnected;
          if (Env().isInDebugMode) {
            print(
                '[InternetConnectionState] Connection Status: ${state.isConnected}');
          }
        }
      },
      child: Scaffold(
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _children,
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
              ? 0.0
              : kBottomNavigationBarHeight,
          hideNavigationBarWhenKeyboardShows: true,
          margin: EdgeInsets.all(0.0),
          popActionScreens: PopActionScreensType.all,
          bottomScreenMargin: 0.0,
          onWillPop: (context) async {
            return false;
          },
          hideNavigationBar: false,
          popAllScreensOnTapOfSelectedTab: true,
          itemAnimationProperties: ItemAnimationProperties(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style3,
        ),
      ),
    );
  }
}
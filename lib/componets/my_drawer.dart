import 'package:bilal_goods/componets/text_widget.dart';
import 'package:bilal_goods/screens/vendor_balance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../screens/about_us.dart';
import '../screens/customer_balance_screen.dart';
import '../screens/customer_ledger.dart';
import '../screens/customer_receipts.dart';
import '../screens/login_screen.dart';
import '../screens/new_order.dart';
import '../screens/orderlist_screen.dart';
import '../screens/recieptList.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final _box = GetStorage();

  // final _key = 'isDarkMode';
  //
  // ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  //
  // bool _loadThemeFromBox() => _box.read(_key) ?? false;
  //
  // _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);
  //
  // void switchTheme() {
  //   Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
  //   _saveThemeToBox(!_loadThemeFromBox());
  //   setState(() {});
  // }

  String? name;
  @override
  void initState() {
    name = GetStorage().read("usid");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      elevation: 30,
      shadowColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 180,
            color: Color(0xFF144b9d),
            // color: Theme.of(context).colorScheme.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).colorScheme.shadow,
                    ),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/admin.png'),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                MyTextWidget(
                  text: "${name ?? ""}",
                  color: Colors.white,
                  size: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                // SizedBox(height: 10),
                // MyTextWidget(
                //   text: "Admin@gmail.com",
                //   // color: Colors.white,
                //   size: 18.0,
                //   fontWeight: FontWeight.bold,
                // ),
              ],
            ),
          ),
          Divider(thickness: 2, color: Colors.grey,),
          Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: ListView(children: [
                  ListTile(
                    leading: Icon(Icons.shopping_basket,
                      color: Color(0xFF144b9d),),
                    title: MyTextWidget(
                      text: 'Permit',
                      color: Colors.black,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                      color: Colors.blueAccent,),
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 1));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewOrderListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add_shopping_cart,
                      color: Color(0xFF144b9d),),
                    title: MyTextWidget(
                      text: 'New Order',
                      color: Colors.black,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                      color: Colors.blueAccent,),
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 1));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewOrderListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.list_alt,
                      color: Color(0xFF144b9d),),
                    title: MyTextWidget(
                      text: 'Order List',
                      color: Colors.black,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                      color: Colors.blueAccent,),
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 1));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.receipt,
                    color: Color(0xFF144b9d),),
                    title: MyTextWidget(
                      text: 'Reciepts List',
                      color: Colors.black,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                      color: Colors.blueAccent,),
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 1));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReceiptListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.monetization_on_outlined,
                      color: Color(0xFF144b9d),),
                    title: MyTextWidget(
                      text: 'Customer Balance',
                      color: Colors.black,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                      color: Colors.blueAccent,),
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 1));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerBAlanceScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.balance,
                      color: Color(0xFF144b9d),),
                    title: MyTextWidget(
                      text: 'Party Balance',
                      color: Colors.black,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                      color: Colors.blueAccent,),
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 1));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VendorBalance()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.note_alt_outlined,
                      color: Color(0xFF144b9d),),
                    title: MyTextWidget(
                      text: 'Customer Ledger',
                      color: Colors.black,
                    ),
                    // leading: Icon(Icons.home, color: fontGrey),
                    trailing: Icon(Icons.arrow_forward_ios,
                      color: Colors.blueAccent,),
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 1));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerLedgerScreen(
                                  selectedCustomerName: "Select Customer",
                                  selectedCustomerId: "Select Customer",
                                )),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.indeterminate_check_box_outlined,
                      color: Color(0xFF144b9d),),
                    title: MyTextWidget(
                      text: 'Customer Receipt',
                      color: Colors.black,
                    ),
                    // leading: Icon(Icons.home, color: fontGrey),
                    trailing: Icon(Icons.arrow_forward_ios,
                      color: Colors.blueAccent,),
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 1));
                      Get.to(() => CustomerReceipts(),
                          transition: Transition.leftToRightWithFade);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline,
                      color: Color(0xFF144b9d),),
                    title: MyTextWidget(
                      text: 'About US',
                      color: Colors.black,
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 1));
                      Get.to(() => AboutUs(),
                          transition: Transition.leftToRightWithFade);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout,
                      color: Colors.red,),
                    title: MyTextWidget(
                      text: 'Logout',
                      color: Colors.black,
                    ),
                    onTap: () async {
                      final _box = GetStorage();
                      _box.remove('email');
                      _box.remove('password');
                      _box.remove('FKUNIT');
                      _box.remove('usid');

                      await Future.delayed(Duration(milliseconds: 1));
                      Get.offAll(() => LoginScreen(),
                          transition: Transition.leftToRightWithFade);
                    },
                  ),
                  // SwitchListTile(
                  //     title: MyTextWidget(
                  //       text: 'Theme Switch',
                  //       color: Colors.blueAccent,
                  //       // color: blackColor,
                  //     ),
                  //     value: theme == ThemeMode.dark,
                  //     onChanged: (v) => switchTheme()),
                ])),
          ),
        ],
      ),
    );
  }
}

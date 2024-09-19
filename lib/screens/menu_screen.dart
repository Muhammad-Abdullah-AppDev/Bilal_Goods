import 'package:bilal_goods/screens/permit_voucher.dart';
import 'package:bilal_goods/screens/recieptList.dart';
import 'package:bilal_goods/screens/sale_invoice.dart';
import 'package:bilal_goods/screens/vendor_balance.dart';
import 'package:bilal_goods/screens/vendor_voucher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../componets/my_drawer.dart';
import '../componets/my_homecard.dart';
import 'customer_balance_screen.dart';
import 'customer_ledger.dart';
import 'customer_receipts.dart';
import 'orderlist_screen.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});
  List menuList = [
    const MyHomeCard(
      text: 'Permit',
      imagePath: "assets/images/permit.png",
      imgHeight: 80.0,
      imgWidth: 120.0,
      boxHeight: 130.0,
      boxWidth: 150.0,
    ),
    const MyHomeCard(
      text: 'Sale Invoice',
      imagePath: "assets/images/trucknew.png",
      imgHeight: 80.0,
      imgWidth: 120.0,
      boxHeight: 130.0,
      boxWidth: 150.0,
    ),
    const MyHomeCard(
      text: 'Vendor Payment',
      imagePath: "assets/images/vc_payment.png",
      imgHeight: 80.0,
      imgWidth: 120.0,
      boxHeight: 130.0,
      boxWidth: 150.0,
    ),
    const MyHomeCard(
      text: 'Cust Receipts',
      imagePath: "assets/images/receipts.png",
      imgHeight: 75.0,
      imgWidth: 100.0,
      boxHeight: 125.0,
      boxWidth: 150.0,
    ),
    const MyHomeCard(
      text: 'Vendor Balance',
      imagePath: "assets/images/partyBal.png",
      imgHeight: 80.0,
      imgWidth: 100.0,
      boxHeight: 130.0,
      boxWidth: 150.0,
    ),
    const MyHomeCard(
      text: 'Customer Bal',
      imagePath: "assets/images/balance.png",
      imgHeight: 80.0,
      imgWidth: 100.0,
      boxHeight: 130.0,
      boxWidth: 150.0,
    ),
    const MyHomeCard(
      text: 'Invoice List',
      imagePath: "assets/images/orderlist.png",
      imgHeight: 70.0,
      imgWidth: 100.0,
      boxHeight: 130.0,
      boxWidth: 150.0,
    ),
    const MyHomeCard(
      text: 'Reciepts List',
      imagePath: "assets/images/receiptlist.png",
      imgHeight: 80.0,
      imgWidth: 120.0,
      boxHeight: 130.0,
      boxWidth: 150.0,
    ),
    const MyHomeCard(
      text: 'Ledger',
      imagePath: "assets/images/ledger.png",
      imgHeight: 80.0,
      imgWidth: 100.0,
      boxHeight: 130.0,
      boxWidth: 330.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0c3865),
      appBar: AppBar(
        backgroundColor: Color(0xFF144b9d),
        foregroundColor: Colors.white,
        title: const Text("Dashboard"),
        elevation: 0,
        centerTitle: true,
      ),
      drawer: DrawerWidget(),
      body: ListView.builder(
        itemCount: (menuList.length / 2).ceil(), // Calculate the number of rows
        itemBuilder: (context, rowIndex) {
          // Calculate the indices for this row
          final startIndex = rowIndex * 2;
          final endIndex = (startIndex + 2).clamp(0, menuList.length);

          // Extract the MyHomeCard widgets for this row
          final rowWidgets = menuList.sublist(startIndex, endIndex);

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowWidgets.map((widget) {
              final index = menuList.indexOf(widget);
              return InkWell(
                onTap: () {
                  switch (index) {
                    case 0:
                      Get.to(const PermitVoucher(),
                          transition: Transition.leftToRightWithFade);

                      break;
                    case 1:
                      Get.to(SaleInvoice(),
                          transition: Transition.leftToRightWithFade);

                      break;
                    case 2:
                      Get.to(VendorVoucher(),
                          transition: Transition.leftToRightWithFade);

                      break;
                    case 3:
                      Get.to(CustomerReceipts(),
                          transition: Transition.leftToRightWithFade);

                      break;
                    case 4:
                      Get.to(VendorBalance(),
                          transition: Transition.leftToRightWithFade);

                      break;
                    case 5:
                      Get.to(CustomerBAlanceScreen(),
                          transition: Transition.leftToRightWithFade);

                      break;
                    case 6:
                      Get.to(OrderListScreen(),
                          transition: Transition.leftToRightWithFade);

                      break;
                    case 7:
                      Get.to(ReceiptListScreen(),
                          transition: Transition.leftToRightWithFade);

                      break;
                    case 8:
                      Get.to(
                          CustomerLedgerScreen(
                            selectedCustomerName: "Select Account",
                          ),
                          transition: Transition.leftToRightWithFade);

                      break;
                    default:
                      break;
                  }
                },
                child: widget,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

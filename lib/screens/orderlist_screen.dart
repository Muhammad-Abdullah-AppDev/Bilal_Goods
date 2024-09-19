import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../model/pending_order_model.dart';
import '../services/service.dart';

// ignore: must_be_immutable
class OrderListScreen extends StatelessWidget {
  OrderListScreen({super.key});
  String? FKUNIT = GetStorage().read("FKUNIT");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF144b9d),
        foregroundColor: Colors.white,
        title: Text("Pending Orders"),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<PendingOrderModel>>(
        future: ApiService.getPendingOrders('SaleInvoice/GetSaleInvoiceList?fkunit=$FKUNIT'),
        // initialData: InitialData,
        builder: (BuildContext context,
            AsyncSnapshot<List<PendingOrderModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            debugPrint('${snapshot.error}');
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off_rounded, size: 34),
                  SizedBox(height: 10),
                  Text(
                    'please check your internet  connection',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            final pendingOreders = snapshot.data;

            if (pendingOreders == null || pendingOreders.isEmpty) {
              return Center(
                child: Text(
                  'No pending orders',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }

            debugPrint(FKUNIT);
            //debugPrint(pendingOreders);
            // Sort the pending orders by customer name
            pendingOreders.sort((a, b) =>
                a.cUSTNAME.toString().compareTo(b.cUSTNAME.toString()));
            return Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    // SizedBox(height: 30),
                    orderListCard(
                      context,
                      "NAME",
                      "BRAND",
                      "RATE",
                      "QTY",
                      Theme.of(context).colorScheme.primary,
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: pendingOreders.length,
                      itemBuilder: (BuildContext context, int index) {
                        return orderListCard(
                            context,
                            pendingOreders[index].cUSTNAME.toString(),
                            pendingOreders[index].iTEMNAME.toString() ?? "--",
                            pendingOreders[index].rATE.toString(),
                            pendingOreders[index].qTY.toString(),
                            Theme.of(context).colorScheme.secondary);
                      },
                    )),
                    Card(
                      color: Theme.of(context).colorScheme.primary,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Align(
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  "Total Pending Orders : ${pendingOreders.length}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  SizedBox orderListCard(BuildContext context, String? title, String? brand,
      String? rate, String? Qty, Color color) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Card(
              color: color,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          "$title",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              color: color,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          "$brand",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              color: color,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          "$rate",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              color: color,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          "$Qty",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

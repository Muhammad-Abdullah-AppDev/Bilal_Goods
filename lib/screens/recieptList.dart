import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../model/receipt_list_model.dart';
import '../services/service.dart';

class ReceiptListScreen extends StatelessWidget {
  ReceiptListScreen({super.key});
  String? usid = GetStorage().read("usid");
  double totalAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF144b9d),
        foregroundColor: Colors.white,
        title: Text("Receipts List"),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<RecieptListModel>>(
        future: ApiService.getReceiptList('CutRcv/CustRcvList?usid=$usid'),
        // initialData: InitialData,
        builder: (BuildContext context,
            AsyncSnapshot<List<RecieptListModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            debugPrint(usid);

            //debugPrint(snapshot.error);
            return Center(
              child: Text('Something went wrong try lator'),
            );
          }
          if (snapshot.hasData) {
            final receiplist = snapshot.data;

            for (var recpt in receiplist!) {
              double amount = double.parse(recpt.aMOUNT?.toString() ?? "0");
              totalAmount += amount;
            }
            var formateTotalAmount =
                NumberFormat("#,##0.##", "en_US").format(totalAmount);

            if (receiplist.isEmpty) {
              return Center(
                child: Text(
                  'Receipt List is empty',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
            receiplist.sort((a, b) =>
                a.nAME!.toLowerCase().compareTo(b.nAME!.toLowerCase()));
            debugPrint(usid);
            //debugPrint(receiplist);
            return Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Card(
                            color: Theme.of(context).colorScheme.primary,
                            elevation: 2,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          "Customer Name",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Card(
                            color: Theme.of(context).colorScheme.primary,
                            elevation: 2,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Amount",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: receiplist.length,
                      itemBuilder: (BuildContext context, int index) {
                        /////////////////////////
                        var _date = receiplist[index].vDATE?.toString() ?? "--";
                        var formatedDate = _date.split("T")[0];
                        var formateAmount = NumberFormat("#,##0.##", "en_US")
                            .format(double.parse(
                                receiplist[index].aMOUNT?.toString() ?? "0"));
                        return receiptListCard(
                            context,
                            receiplist[index].nAME?.toString() ?? "--",
                            // receiplist[index].vDATE?.toString() ?? "--",
                            formatedDate,
                            receiplist[index].pTYPE?.toString() ?? "--",
                            formateAmount,
                            Theme.of(context).colorScheme.secondary);
                      },
                    )),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Card(
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
                                        "Total Receipts : ${receiplist.length}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
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
                                        "Total: $formateTotalAmount",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  SizedBox receiptListCard(BuildContext context, String? title, var date,
      var type, String? amount, Color color) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Card(
              color: color,
              elevation: 2,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "$date",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "PTYPE: $type",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              "$title",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "$amount",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

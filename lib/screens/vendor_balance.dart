import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../model/party_balance_model.dart';
import '../services/service.dart';
import 'customer_ledger.dart';

// ignore: must_be_immutable
class VendorBalance extends StatefulWidget {
  VendorBalance({super.key});

  @override
  State<VendorBalance> createState() => _VendorBalanceState();
}

class _VendorBalanceState extends State<VendorBalance> {
  double? _totalBalance = 0;
  final _searchFocusNode = FocusNode();
  bool loading = true;
  String? usid;

  List<PartyBalanceModel>? partyBalanceList;
  List<PartyBalanceModel>? filteredList;
  final _searchController = TextEditingController();

  @override
  void initState() {
    usid = GetStorage().read('usid');
    debugPrint("KKKKKKKKKKKKKKKKKKK$usid");
    getData();

    super.initState();
  }

  //getapi method
  Future<void> getData() async {
    setState(() {
      loading = true;
    });

    partyBalanceList = await ApiService.getPartyBalance(
        'CustomerBal/GetPartyBalance');
    filteredList = List<PartyBalanceModel>.from(partyBalanceList!);
    _totalBalance = partyBalanceList!
        .fold(0, (sum, customer) => sum! + (customer.balance ?? 0));
// Sort the list by customer name
    sortList();
    setState(() {
      loading = false;
    });
  }

  // Sort the filtered list by customer name
  void sortList() {
    filteredList!
        .sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
  }

  // filteredData method
  void searchCustomer(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List<PartyBalanceModel>.from(partyBalanceList!);
      } else {
        filteredList = partyBalanceList!
            .where((element) =>
            element.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTotalAmount =
    NumberFormat("#,##0.##", "en_US").format(_totalBalance);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF144b9d),
        foregroundColor: Colors.white,
        title: Text("Vendor Balance"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          loading
              ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.primary),
            ),
          )
              : Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: TextFormField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: searchCustomer,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error),
                      borderRadius:
                      BorderRadius.all(Radius.circular(15.0)),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.0),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.0),
                      borderRadius:
                      BorderRadius.all(Radius.circular(15.0)),
                    ),
                    hintText: 'Search Customers...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              SizedBox(height: 10),
              balanceListCard(context, "Customer Name", "Balance",
                  Theme.of(context).colorScheme.primary),
              SizedBox(height: 10),
              if (filteredList!.isEmpty) ...[
                Center(
                  child: SizedBox(
                    height: 200,
                    child: Center(child: Text('No data found')),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredList!.length,
                    itemBuilder: (context, index) {
                      var formateAmount =
                      NumberFormat("#,##0.##", "en_US")
                          .format(double.parse(
                        filteredList![index].balance.toString(),
                      ));
                      PartyBalanceModel selectedCustomer =
                      filteredList![index];
                      return balanceListCard(
                        context,
                        filteredList![index].name ?? "Customer Name",
                        formateAmount,
                        Theme.of(context).colorScheme.secondary,
                        ontap: () {
                          _searchController.clear();
                          Get.to(
                            CustomerLedgerScreen(
                              selectedCustomerName: selectedCustomer.name,
                              selectedCustomerId: selectedCustomer.pkcode,
                            ),
                            transition: Transition.leftToRightWithFade,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
              Container(
                child: balanceListCard(
                  context,
                  "Total",
                  '$formattedTotalAmount',
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox balanceListCard(context, String? title, String? Qty, Color color,
      {Callback? ontap}) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: ontap,
              child: Card(
                color: color,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        '$title',
                        overflow: TextOverflow.visible,
                        // maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    // child: FittedBox(
                    //   child: MyTextWidget(
                    //     size: 14.0,
                    //     text: '$title',
                    //     color: Theme.of(context).colorScheme.onPrimary,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              color: color,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      '$Qty',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  // child: FittedBox(
                  //   child: MyTextWidget(
                  //     text: '$Qty',
                  //     color: Theme.of(context).colorScheme.onPrimary,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

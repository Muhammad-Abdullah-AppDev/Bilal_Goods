import 'package:bilal_goods/controller/permit_voucher_controller.dart';
import 'package:bilal_goods/model/permit_voucherList_model.dart';
import 'package:bilal_goods/screens/permit_screen.dart';
import 'package:bilal_goods/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class PermitVoucher extends StatefulWidget {
  const PermitVoucher({super.key});

  @override
  State<PermitVoucher> createState() => _PermitVoucherState();
}

class _PermitVoucherState extends State<PermitVoucher> {
  bool loading = true;
  bool isLoading = false;
  var fkunit;
  List<PermitVoucherListModel>? permitVoucherList;
  List<PermitVoucherListModel>? permitVoucherListData;
  List<PermitVoucherListModel>? filteredList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fkunit = GetStorage().read('FKUNIT');
    debugPrint("FKUNIT : $fkunit");
    getData(fkunit);
  }

  String formatDate(String? date) {
    if (date != null) {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }
    return '';
  }

  Future<void> getData(var fkunit) async {
    setState(() {
      loading = true;
    });

    permitVoucherList = await ApiService.getPermitVoucher(
        'NewPermit/GetPermitList?fkunit=$fkunit');
    filteredList = List<PermitVoucherListModel>.from(permitVoucherList!);
    // _totalBalance = customerBalanceList!
    //     .fold(0, (sum, customer) => sum! + (customer.balance ?? 0));
    debugPrint("Total Vouchers: ${filteredList?.length.toString()}");
    debugPrint("Total Vouchers: ${permitVoucherList}");
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF144b9d),
        foregroundColor: Colors.white,
        title: const Text("Permit List"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  Get.to(const PermitScreen(),
                      transition: Transition.leftToRightWithFade);
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Color(0xFF0392CF),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black87,
                            spreadRadius: 3,
                            blurRadius: 8)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        'Create A New Permit',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Divider(
              thickness: 1.6,
              color: Colors.grey,
              indent: 40,
              endIndent: 40,
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF144b9d),
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredList!.length,
                      separatorBuilder: (context, index) =>
                          const Divider(color: Colors.transparent),
                      itemBuilder: (context, index) {
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  debugPrint(
                                      "Delete Voucher: ${filteredList![index].sRNO}");
                                  deleteVoucher(
                                      context, filteredList![index].sRNO);
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete_sweep_sharp,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Card(
                            child: ListTile(
                              tileColor: index.isEven
                                  ? Colors.blueGrey[50]
                                  : Colors.blue[50],
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${filteredList?[index].sRNO} ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black)),
                                      Text(
                                          '${formatDate(filteredList?[index].vDT)}  ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  Text(
                                      'Vendor: ${filteredList?[index].cUSTNAME}',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('QTY: ${filteredList?[index].qTY}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black)),
                                      Text(
                                          'AMT: ${filteredList?[index].nETAMT}  ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black))
                                    ],
                                  )
                                ],
                              ),
                              trailing: Icon(
                                Icons.verified_user_outlined,
                                size: 30,
                                color: Color(0xFF0392CF),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void deleteVoucher(BuildContext context, String? sRNO) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            AlertDialog(
              title: Text('Delete Voucher'),
              content: Text('Are you sure you want to delete this Voucher?'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = !isLoading;
                    });
                    var responseBody = await TaskStatusController()
                        .deleteTaskStatus(context, sRNO);
                    if (responseBody != null) {
                      setState(() {
                        isLoading = !isLoading;
                      });
                    } else {
                      setState(() {
                        isLoading = !isLoading;
                      });
                    }
                    TaskStatusController().isInsertingStatus.value = true;
                    getData(fkunit);
                    TaskStatusController().isInsertingStatus.value = false;
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(6.0),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.grey;
                        }
                        return isLoading ? Colors.grey : Colors.redAccent;
                      },
                    ),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                  ),
                ),
              ],
            ),
            Obx(() {
              if (TaskStatusController().isInsertingStatus.value) {
                return CircularProgressIndicator();
              } else {
                return SizedBox.shrink();
              }
            }),
          ],
        );
      },
    );
  }
}

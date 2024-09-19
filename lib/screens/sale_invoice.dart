import 'dart:convert';
import 'dart:math';
import 'package:bilal_goods/screens/menu_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../componets/roundbutton.dart';
import '../componets/text_widget.dart';
import '../componets/textfield.dart';
import '../services/service.dart';

class SaleInvoice extends StatefulWidget {
  const SaleInvoice({super.key});

  @override
  State<SaleInvoice> createState() => _SaleInvoiceState();
}

class _SaleInvoiceState extends State<SaleInvoice> {
  String? usid;
  //  String? usid = GetStorage().read('usid');
  bool loading = false;
  var quantity = 0.0;
  var rate = 0.0;

  final quantityController = TextEditingController();
  final driverNameController = TextEditingController();
  final builtyController = TextEditingController();
  final vehicleController = TextEditingController();
  final rateController = TextEditingController();
  final amountController = TextEditingController();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final areaController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  //get customer Api
  String? _customerName = "Select Customer";
  Set<String> _pkcodeForGetCustomr = Set<String>();
  String _finalPkCodeForCustomerName = '';

  List<String>? getCustomersList = [];
  List<String> pkCodesListGetCustomer = [];

  Future<void> _fetchGetCustomersApi() async {
    setState(() {
      loading = true;
    });
    try {
      final data = await ApiService.get("Order/GetCustomer/?USID=$usid");
      if (data != null) {
        setState(() {
          loading = false;
        });
        List<String> menuItems = [];

        for (var item in data) {
          if (item is Map<String, dynamic> &&
              item.containsKey("NAME") &&
              item.containsKey("PKCODE") &&
              item["NAME"] is String &&
              item["PKCODE"] is String) {
            String name = item['NAME'];
            String pkCode = item['PKCODE'];
            if (!menuItems.contains(name) &&
                !pkCodesListGetCustomer.contains(pkCode)) {
              menuItems.add(name);
              pkCodesListGetCustomer.add(pkCode);
            }
          }
        }

        setState(() {
          getCustomersList = menuItems;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("An error occurred: $e");
    }
  }

  bool isItemDisabled(String s) {
    //return s.startsWith('I');

    if (s.startsWith('x')) {
      return true;
    } else {
      return false;
    }
  }

  void itemSelectionChanged(String? s) {
    debugPrint(s);
  }

  String? _customerProduct = "Select Product";
  String? _pkcodeforProduct = "";

  List<String>? customerProductList = [];
  List<String> pkCodesforProductList = [];

  Future<void> _fetchCustomerItems() async {
    setState(() {
      loading = true;
    });
    try {
      final data = await ApiService.get("Order/GetOrderItem/");
      if (data != null) {
        setState(() {
          loading = false;
        });
        List<String> menuItems = [];

        for (var item in data) {
          if (item is Map<String, dynamic> &&
              item.containsKey("NAME") &&
              item.containsKey("PKCODE") &&
              item["NAME"] is String &&
              item["PKCODE"] is String) {
            String name = item['NAME'];
            String pkCode = item['PKCODE'];
            if (!menuItems.contains(name)) {
              menuItems.add(name);
              debugPrint("Updated Name: $menuItems");
            }
            if (!pkCodesforProductList.contains(pkCode)) {
              pkCodesforProductList.add(pkCode);
              debugPrint("Updated pkcode: $menuItems");
            }
          }
        }

        setState(() {
          customerProductList = menuItems;
          debugPrint('Items: $menuItems');
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("An error occurred: $e");
    }
  }

//dispose controller
  void dispose() {
    quantityController.dispose();
    rateController.dispose();
    amountController.dispose();
    nameController.dispose();
    mobileController.dispose();
    areaController.dispose();
    super.dispose();
  }

  void calculateAmount() {
    setState(() {
      try {
        double? quantity = double.tryParse(quantityController.text.trim());
        double? rate = double.tryParse(rateController.text.trim());
        if (quantity != null && rate != null) {
          var amount = quantity * rate;
          amountController.text = amount.toStringAsFixed(2);
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    });
  }

  moveToHome(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      debugPrint('form is validate');

      Map<String, dynamic> bodyData = {
        "USID": usid,
        "FKUNIT": _box.read('FKUNIT'),
        "FKCUST": _finalPkCodeForCustomerName.toString(),
        "FKMAST": _pkcodeforProduct.toString(),
        "TRCNO": vehicleController.text.toString(),
        "DRVNAME": driverNameController.text.toString(),
        "RDNO": builtyController.text.toString(),
        "QTY": quantityController.text.trim(),
        "RATE": rateController.text.trim(),
        "AMOUNT": amountController.text.trim(),
        "CNAME": nameController.text.trim(),
        "MOB": mobileController.text.trim(),
        "AREA": areaController.text.trim(),
      };

      final response =
          await ApiService.post("SaleInvoice/PostSaleInvoice/", body: bodyData);

      debugPrint(bodyData.toString());

      if (response.statusCode == 200) {
        // print(response.statusCode);
        final responseBody = json.decode(response.body);

        debugPrint(responseBody);

        if (responseBody == "Inserted Successfully") {
          setState(() {
            loading = false;
          });
          // Do something if the response is "Inserted Successfully"
          Fluttertoast.showToast(
            msg: 'Intersted Successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          Get.to(() => MenuScreen());
        } else {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(
            msg: 'Somethings Went Wrong.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          throw Exception(e.toString());
        }
      } else {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
          msg: 'Server Error Please Try Again',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        throw Exception("Failed to load data from API");
      }
    }
  }

  GetStorage _box = GetStorage();

  @override
  void initState() {
    _box = GetStorage();
    usid = GetStorage().read('usid');
    debugPrint("Usid is: $usid");
    debugPrint("FKUNIT : ${_box.read("FKUNIT")}");
    _fetchGetCustomersApi();
    _fetchCustomerItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF144b9d),
        foregroundColor: Colors.white,
        title: const Text("Sale Invoice"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          loading
              ? Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.primary),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          MyTextWidget(
                              text: 'Select Customer',
                              color: Theme.of(context).colorScheme.primary),
                          SizedBox(height: 10),
                          getCustomersList != null
                              ? DropdownSearch<String>(
                                  dropdownBuilder: (context, selectedItem) {
                                    return Text(
                                      selectedItem.toString(),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 16,
                                      ),
                                    );
                                  },
                                  popupProps: PopupProps.menu(
                                    showSelectedItems: true,
                                    disabledItemFn: isItemDisabled,
                                    showSearchBox:
                                        true, // Add this line to enable the search box
                                  ),
                                  items: getCustomersList ?? [],
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      filled: true,
                                      isDense: true,
                                      fillColor:
                                          Theme.of(context).colorScheme.primary,
                                      hintText:
                                          "Search here..", // Set the hint text
                                    ),
                                  ),
                                  selectedItem: _customerName,
                                  onChanged: (value) {
                                    setState(() {
                                      _customerName = value;
                                      _customerProduct = "Select Product";
                                      debugPrint(
                                          "..CustomerName..$_customerName");

                                      if (value is List<String>) {
                                        _pkcodeForGetCustomr =
                                            Set.from(value as Iterable);
                                      } else {
                                        _pkcodeForGetCustomr.clear();
                                        _pkcodeForGetCustomr.add(
                                          pkCodesListGetCustomer[
                                              getCustomersList!
                                                  .indexOf(value!)],
                                        );
                                      }
                                      _finalPkCodeForCustomerName =
                                          _pkcodeForGetCustomr.join(', ');
                                      debugPrint(
                                          "..getCustomerpkcode..$_finalPkCodeForCustomerName");
                                    });
                                  },
                                  validator: (value) {
                                    if (value == "Select Customer") {
                                      return "Please select a Customer";
                                    }
                                    return null;
                                  },
                                )
                              : CircularProgressIndicator.adaptive(),
                          SizedBox(height: 20),
                          MyTextWidget(
                              text: 'Select Product',
                              color: Theme.of(context).colorScheme.primary),
                          SizedBox(height: 10),
                          customerProductList != null
                              ? DropdownSearch<String>(
                                  dropdownBuilder: (context, selectedItem) {
                                    return Text(
                                      selectedItem.toString(),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 16,
                                      ),
                                    );
                                  },
                                  popupProps: PopupProps.menu(
                                    showSelectedItems: true,
                                    disabledItemFn: isItemDisabled,
                                    showSearchBox:
                                        true, // Add this line to enable the search box
                                  ),
                                  items: customerProductList ?? [],
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      iconColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      filled: true,
                                      isDense: true,
                                      fillColor:
                                          Theme.of(context).colorScheme.primary,
                                      hintText:
                                          "Search here..", // Set the hint text
                                    ),
                                  ),
                                  selectedItem: _customerProduct,
                                  onChanged: (value) {
                                    setState(() {
                                      _customerProduct = value;
                                      debugPrint(
                                          "..ProductName..$_customerProduct");

                                      _pkcodeforProduct = pkCodesforProductList[
                                          customerProductList!.indexOf(value!)];
                                      debugPrint(
                                          "..Productpkcode..$_pkcodeforProduct");
                                    });
                                  },
                                  validator: (value) {
                                    if (value == "Select Product") {
                                      return "Please select a Product";
                                    }
                                    return null;
                                  },
                                )
                              : CircularProgressIndicator.adaptive(),
                          // if (_showAdditionalFields)

                          SizedBox(height: 10),
                          // if (_showAdditionalFields)
                          //   Column(
                          //     children: [
                          //       Row(
                          //         children: [
                          //           Expanded(
                          //             child: MyTextForm(
                          //               textKeyboardType: TextInputType.number,
                          //               text: 'Vendor Name',
                          //               containerWidth: double.infinity,
                          //               hintText: 'Enter Vendor Name',
                          //               controller: nameController,
                          //               validator: (text) {
                          //                 if (text.toString().isEmpty) {
                          //                   return "Vendor Name is required";
                          //                 }
                          //               },
                          //             ),
                          //           ),
                          //           SizedBox(width: 20),
                          //           Expanded(
                          //             child: MyTextForm(
                          //               textKeyboardType: TextInputType.number,
                          //               text: 'Mobile No',
                          //               containerWidth: double.infinity,
                          //               hintText: 'Enter Mobile No..',
                          //               controller: mobileController,
                          //               validator: (text) {
                          //                 if (text.toString().isEmpty) {
                          //                   return "Mobile No. is required";
                          //                 }
                          //               },
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(height: 10),
                          //       MyTextForm(
                          //         enable: true,
                          //         textKeyboardType: TextInputType.number,
                          //         text: 'Area',
                          //         containerWidth: double.infinity,
                          //         hintText: 'Enter Area',
                          //         controller: areaController,
                          //         validator: (text) {
                          //           if (text.toString().isEmpty) {
                          //             return "Area is required";
                          //           }
                          //         },
                          //       ),
                          //     ],
                          //   ),

                          // SizedBox(height: 10),
                          MyTextForm(
                            textKeyboardType: TextInputType.name,
                            text: 'Driver Name',
                            containerWidth: double.infinity,
                            hintText: 'Enter Driver Name',
                            controller: driverNameController,
                            onchange: (v) {
                              //calculateAmount();
                            },
                            validator: (text) {
                              if (text.toString().isEmpty) {
                                return "Driver Name is required";
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: MyTextForm(
                                      textKeyboardType: TextInputType.number,
                                      text: 'Builty No',
                                      containerWidth: double.infinity,
                                      hintText: 'Enter Builty No',
                                      controller: builtyController,
                                      onchange: (v) {
                                        //calculateAmount();
                                      },
                                      validator: (text) {
                                        if (text.toString().isEmpty) {
                                          return "Builty No is required";
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: MyTextForm(
                                      textKeyboardType: TextInputType.number,
                                      text: 'Vehicle No',
                                      containerWidth: double.infinity,
                                      hintText: 'Enter Vehicle No',
                                      controller: vehicleController,
                                      onchange: (v) {
                                        //calculateAmount();
                                      },
                                      validator: (text) {
                                        if (text.toString().isEmpty) {
                                          return "Vehicle No is required";
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyTextForm(
                                      textKeyboardType: TextInputType.number,
                                      text: 'Quantity',
                                      containerWidth: double.infinity,
                                      hintText: 'Enter your Quantity',
                                      controller: quantityController,
                                      onchange: (v) {
                                        calculateAmount();
                                      },
                                      validator: (text) {
                                        if (text.toString().isEmpty) {
                                          return "Quantity is required";
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: MyTextForm(
                                      textKeyboardType: TextInputType.number,
                                      text: 'Rate',
                                      containerWidth: double.infinity,
                                      hintText: 'Enter Rate',
                                      controller: rateController,
                                      onchange: (v) {
                                        calculateAmount();
                                      },
                                      validator: (text) {
                                        if (text.toString().isEmpty) {
                                          return "Rate is required";
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              MyTextForm(
                                enable: false,
                                textKeyboardType: TextInputType.number,
                                text: 'Amount',
                                containerWidth: double.infinity,
                                hintText: 'Enter Amount',
                                controller: amountController,
                                validator: (text) {
                                  if (text.toString().isEmpty) {
                                    return "Amount is required";
                                  }
                                },
                              ),
                              SizedBox(height: 30),
                              RoundButton(
                                width: double.infinity,
                                loading: loading,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                textColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                onTap: () {
                                  //debugPrint(_pkcodeForGetCustomr as String?);
                                  debugPrint(_pkcodeforProduct);
                                  debugPrint(nameController.text);
                                  debugPrint(mobileController.text);
                                  debugPrint(areaController.text);
                                  moveToHome(context);
                                },
                                title: "Submit",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

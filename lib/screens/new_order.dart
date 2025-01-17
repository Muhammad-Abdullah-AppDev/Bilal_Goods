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

class NewOrderListScreen extends StatefulWidget {
  NewOrderListScreen({super.key});

  @override
  State<NewOrderListScreen> createState() => _NewOrderListScreenState();
}

class _NewOrderListScreenState extends State<NewOrderListScreen> {
  String? usid;
  //  String? usid = GetStorage().read('usid');
  bool loading = false;
  var quantity = 0.0;
  var rate = 0.0;

  final quantityController = TextEditingController();
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

  //for show additional fields
  bool get _showAdditionalFields {
    return _pkcodeForGetCustomr.contains('20200458') ||
        _pkcodeForGetCustomr.contains('20200463') ||
        _pkcodeForGetCustomr.contains('20200464') ||
        _pkcodeForGetCustomr.contains('20200465') ||
        _pkcodeForGetCustomr.contains('20200466');
  }

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
            if (!menuItems.contains(name) &&
                !pkCodesforProductList.contains(pkCode)) {
              menuItems.add(name);
              pkCodesforProductList.add(pkCode);
            }
          }
        }

        setState(() {
          customerProductList = menuItems;
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

  //
  moveToHome(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      debugPrint('form is validate');

      Map<String, dynamic> bodyData = {
        "USID": usid,
        "FKCUST": _finalPkCodeForCustomerName.toString(),
        "FKMAST": _pkcodeforProduct.toString(),
        "QTY": quantityController.text.trim(),
        "RATE": rateController.text.trim(),
        "AMOUNT": amountController.text.trim(),
        "CNAME": nameController.text.trim(),
        "MOB": mobileController.text.trim(),
        "AREA": areaController.text.trim(),
      };

      final response =
          await ApiService.post("Order/PostOrder/", body: bodyData);

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
            msg: 'Order Intersted Successfully',
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

  @override
  void initState() {
    usid = GetStorage().read('usid');
    debugPrint("KKKKKKKKKKKKKKKKKKK$usid");
    _fetchCustomerItems();
    _fetchGetCustomersApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF144b9d),
        foregroundColor: Colors.white,
        title: Text("New Order"),
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
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 16,
                                ),
                              );
                            },
                            popupProps: PopupProps.menu(
                              showSelectedItems: true,
                              disabledItemFn: isItemDisabled,
                              showSearchBox: true, // Add this line to enable the search box
                            ),
                            items: getCustomersList ?? [],
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                filled: true,
                                isDense: true,
                                fillColor: Theme.of(context).colorScheme.primary,
                                hintText: "Search here..", // Set the hint text
                              ),
                            ),
                            selectedItem: _customerName,
                            onChanged: (value) {
                              setState(() {
                                _customerName = value;
                                debugPrint("..CustomerName..$_customerName");

                                if (value is List<String>) {
                                  _pkcodeForGetCustomr = Set.from(value as Iterable);
                                } else {
                                  _pkcodeForGetCustomr.clear();
                                  _pkcodeForGetCustomr.add(
                                    pkCodesListGetCustomer[getCustomersList!.indexOf(value!)],
                                  );
                                }
                                _finalPkCodeForCustomerName = _pkcodeForGetCustomr.join(', ');

                                debugPrint("..getCustomerpkcode..$_finalPkCodeForCustomerName");
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
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 16,
                                ),
                              );
                            },
                            popupProps: PopupProps.menu(
                              showSelectedItems: true,
                              disabledItemFn: isItemDisabled,
                              showSearchBox: true, // Add this line to enable the search box
                            ),
                            items: customerProductList ?? [],
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                iconColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                filled: true,
                                isDense: true,
                                fillColor: Theme.of(context).colorScheme.primary,
                                hintText: "Search here..", // Set the hint text
                              ),
                            ),
                            selectedItem: _customerProduct,
                            onChanged: (value) {
                              setState(() {
                                _customerProduct = value;
                                debugPrint("..ProductName..$_customerProduct");

                                _pkcodeforProduct =
                                pkCodesforProductList[customerProductList!.indexOf(value!)];
                                debugPrint("..Productpkcode..$_pkcodeforProduct");
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
                          if (_showAdditionalFields)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyTextForm(
                                        textKeyboardType: TextInputType.number,
                                        text: 'Customer Name',
                                        containerWidth: double.infinity,
                                        hintText: 'Enter Customer Name',
                                        controller: nameController,
                                        validator: (text) {
                                          if (text.toString().isEmpty) {
                                            return "Customer Name is required";
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: MyTextForm(
                                        textKeyboardType: TextInputType.number,
                                        text: 'Mobile No',
                                        containerWidth: double.infinity,
                                        hintText: 'Enter Mobile No..',
                                        controller: mobileController,
                                        validator: (text) {
                                          if (text.toString().isEmpty) {
                                            return "Mobile No. is required";
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                MyTextForm(
                                  enable: true,
                                  textKeyboardType: TextInputType.number,
                                  text: 'Area',
                                  containerWidth: double.infinity,
                                  hintText: 'Enter Area',
                                  controller: areaController,
                                  validator: (text) {
                                    if (text.toString().isEmpty) {
                                      return "Area is required";
                                    }
                                  },
                                ),
                              ],
                            ),

                          // SizedBox(height: 10),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
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


// class NewOrderListScreen extends StatelessWidget {
//   NewOrderListScreen({super.key});


//   final orderController = Get.put(OrderController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("New Order"),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//           child: GetBuilder<OrderController>(builder: (_) {
//             return Form(
//               key: orderController.formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 20),
//                   MydropDownButton(
//                     dropDownItems: orderController.dropdownCustomerName,
//                     onChanged: (value) {
//                       orderController.customerValue = value!.toString();
//                       orderController.update();

//                       print(orderController.customerValue.toString());
//                     },
//                     title: "Select Customer",
//                     validator: (v) {
//                       return v == 'Select Customer'
//                           ? "Select a Customer"
//                           : null;
//                     },
//                     value: orderController.customerValue,
//                   ),
//                   SizedBox(height: 10),
//                   MydropDownButton(
//                     dropDownItems: orderController.dropdownProducts,
//                     onChanged: (value) {
//                       orderController.productValue = value.toString();
//                       orderController.update();
//                     },
//                     title: "Select Product",
//                     validator: (v) {
//                       return v == 'Select Product' ? "Select a Product" : null;
//                     },
//                     value: orderController.productValue,
//                   ),
//                   SizedBox(height: 10),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: MyTextForm(
//                               textKeyboardType: TextInputType.number,
//                               text: 'Quantity',
//                               containerWidth: double.infinity,
//                               hintText: 'Enter your Quantity',
//                               controller: _.quantityController,
//                               onchange: (v) {
//                                 _.calculateAmount();
//                               },
//                               validator: (text) {
//                                 if (text.toString().isEmpty) {
//                                   return "Quantity is required";
//                                 }
//                               },
//                             ),
//                           ),
//                           SizedBox(width: 20),
//                           Expanded(
//                             child: MyTextForm(
//                               textKeyboardType: TextInputType.number,
//                               text: 'Rate',
//                               containerWidth: double.infinity,
//                               hintText: 'Enter Rate',
//                               controller: _.amountController,
//                               onchange: (v) {
//                                 _.calculateAmount();
//                               },
//                               validator: (text) {
//                                 if (text.toString().isEmpty) {
//                                   return "Rate is required";
//                                 }
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       MyTextForm(
//                         enable: false,
//                         textKeyboardType: TextInputType.number,
//                         text: 'Amount',
//                         containerWidth: double.infinity,
//                         hintText: 'Enter Amount',
//                         controller: _.amountController,
//                         validator: (text) {
//                           if (text.toString().isEmpty) {
//                             return "Amount is required";
//                           }
//                         },
//                       ),
//                       SizedBox(height: 30),
//                       SizedBox(
//                         height: 45,
//                         width: double.infinity,
//                         child: MaterialButton(
//                           color: Theme.of(context).colorScheme.primary,
//                           onPressed: () => orderController.moveToHome(context),
//                           child: orderController.loading
//                               ? Center(
//                                   child: CircularProgressIndicator.adaptive(
//                                     valueColor: AlwaysStoppedAnimation(
//                                       Theme.of(context).colorScheme.onPrimary,
//                                     ),
//                                   ),
//                                 )
//                               : MyTextWidget(
//                                   text: 'Submit',
//                                   size: 18.0,
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

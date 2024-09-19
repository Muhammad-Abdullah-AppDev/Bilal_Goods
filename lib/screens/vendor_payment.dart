import 'dart:convert';

import 'package:bilal_goods/screens/menu_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bilal_goods/componets/dropdown_button.dart';
import 'package:bilal_goods/componets/roundbutton.dart';
import 'package:bilal_goods/componets/text_widget.dart';
import 'package:bilal_goods/componets/textfield.dart';
import 'package:bilal_goods/model/payment_account_model.dart';
import 'package:bilal_goods/services/service.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

class VendorPayment extends StatefulWidget {
  const VendorPayment({super.key});

  @override
  State<VendorPayment> createState() => _VendorPaymentState();
}

class _VendorPaymentState extends State<VendorPayment> {
  String? usid;
  String? fkunit;
  var accountId;
  String? selectedValue;
  GetStorage _box = GetStorage();

  final formKey = GlobalKey<FormState>();
  final bankController = TextEditingController();
  final amountController = TextEditingController();
  final remarksController = TextEditingController();

  bool loading = false;
  bool isloading = false;
  String? _pkCode = "";

  String? _selectedCash = 'Select Cash / Bank';

  String? cashValue = '';
  List<DropdownMenuItem<String>> dropItemsCash = [
    const DropdownMenuItem<String>(
      value: "Select Cash / Bank",
      child: Text("Select Cash / Bank"),
    ),
    const DropdownMenuItem<String>(
      value: "CPV",
      child: Text("Cash"),
    ),
    const DropdownMenuItem<String>(
      value: "BPV",
      child: Text("Bank"),
    ),
  ];
// //
  //get customer Api
  ///////////////////
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

  String? _customerValue = "Select Vendor";

  // String? selectedCustomerValue ="Select Customer";
  List<String>? customersList = [];
  List<String> pkCodes = [];
  List<String>? accountList = [];
  List<String> fkclsd = [];

  Future<void> _fetchCustomer2() async {
    setState(() {
      isloading = true;
    });
    try {
      final data = await ApiService.get("NewPermit/GetVendor");
      if (data != null) {
        List<String> menuItems = [];

        for (var item in data) {
          if (item is Map<String, dynamic> &&
              item.containsKey("NAME") &&
              item.containsKey("PKCODE") &&
              item["NAME"] is String &&
              item["PKCODE"] is String) {
            String name = item['NAME'];
            String pkCode = item['PKCODE'];
            if (!menuItems.contains(name) && !pkCodes.contains(pkCode)) {
              menuItems.add(name);
              pkCodes.add(pkCode);
            }
          }
        }
        setState(() {
          customersList = menuItems;
          debugPrint("Customer List: $customersList");
          debugPrint("PkCode List: $pkCodes");
          isloading = false;
        });
      } else {
        setState(() {
          isloading = false;
        });
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      debugPrint("An error occurred: $e");
    }
  }
  //////////////////

  submitVendorPayment(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      debugPrint('form is validate');

      Map<String, dynamic> bodyData = {
        "USID": usid,
        "FKUNIT": fkunit,
        "VTYP": _selectedCash.toString(),
        "FKVENDOR": _pkCode.toString(),
        "FKMAST": selectedValue.toString(),
        "CHQNO": bankController.text.trim(),
        "AMOUNT": amountController.text.trim(),
        "RMKS": remarksController.text.toString()
      };

      final response =
          await ApiService.post("Payment/PostPayOrder", body: bodyData);
      debugPrint('Response: $response');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        debugPrint(responseBody);

        if (responseBody == "Inserted Successfully") {
          clearController();
          setState(() {
            loading = false;
          });
          // Do something if the response is "Inserted Successfully"
          Fluttertoast.showToast(
            msg: 'Payment Submitted Successfully',
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
          throw Exception("Failed to Submit");
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

  Future<List<PaymentAccModel>> getAccountList() async {
    try {
      final response = await http.get(Uri.parse(
          'https://erm.scarletsystems.com:2012/Api/Payment/GetAccountList'));
      final body = json.decode(response.body) as List;
      if (response.statusCode == 200) {
        accountId = body.map((e) {
          final map = e as Map<String, dynamic>;

          debugPrint("nAME: ${map["NAME"]}");
          return PaymentAccModel(
            pKCODE: map['PKCODE'],
            nAME: map["NAME"],
            fKCLSD: map["FKCLSD"],
          );
        }).toList();
        debugPrint("DATA: ${accountId}");
        return accountId;
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  @override
  void initState() {
    usid = GetStorage().read('usid');
    fkunit = GetStorage().read('FKUNIT');
    _fetchCustomer2();
    super.initState();
  }

  clearController() {
    setState(() {
      _customerValue = "Select Vendor";
      _selectedCash = 'Select Cash / Bank';
      bankController.clear();
      amountController.clear();
      remarksController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF144b9d),
        foregroundColor: Colors.white,
        title: const Text('Vendor Payment'),
        elevation: 0,
        centerTitle: true,
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).colorScheme.primary),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    MydropDownButton(
                      dropDownItems: dropItemsCash,
                      onChanged: (value) {
                        setState(() {
                          _selectedCash = value.toString();
                          debugPrint(
                              "Selected Cash: ${_selectedCash.toString()}");
                          //await getAccountList();
                        });
                      },
                      title: "Select Cash / Bank",
                      validator: (v) {
                        return v == 'Select Cash / Bank'
                            ? "Select a Cash or Bank"
                            : null;
                      },
                      value: _selectedCash,
                    ),
                    const SizedBox(height: 20),
                    MyTextWidget(
                        text: 'Select Vendor',
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 10),
                    DropdownSearch<String>(
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
                        showSearchBox:
                            true, // Add this line to enable the search box
                      ),
                      items: customersList ?? [],
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
                          hintText: "Search here", // Set the hint text
                        ),
                      ),
                      selectedItem: _customerValue,
                      onChanged: (value) {
                        setState(() {
                          _customerValue = value;
                          debugPrint("..customername..$_customerValue");
                          _pkCode = pkCodes[customersList!.indexOf(value!)];
                          debugPrint("..pkcode..$_pkCode");
                        });
                      },
                      validator: (value) {
                        if (value == "Select Vendor") {
                          return "Please select a Vendor";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    MyTextWidget(
                        text: 'Select Account',
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 10),
                    _selectedCash == 'Select Cash / Bank'
                        ? SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              enabled: false,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                fillColor:
                                    Theme.of(context).colorScheme.primary,
                                filled: true,
                                isDense: true,
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                                hintText: "Waiting For Data...",
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : FutureBuilder(
                            future: getAccountList(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      fillColor:
                                          Theme.of(context).colorScheme.primary,
                                      filled: true,
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white70),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                      ),
                                      hintText: "Loading Account Data",
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }
                              //debugPrint("Total: ${snapshot.data!.length.toString()}");
                              if (snapshot.hasData) {
                                List<PaymentAccModel>? filteredAcc;
                                List<PaymentAccModel>? paymentAcc =
                                    snapshot.data;
                                if (_selectedCash == 'CPV') {
                                  filteredAcc = paymentAcc!
                                      .where((item) => item.fKCLSD == 'A300')
                                      .toList();
                                  debugPrint('Filtered Value: $filteredAcc');
                                } else if (_selectedCash == 'BPV') {
                                  filteredAcc = paymentAcc!
                                      .where((item) => item.fKCLSD == 'A304')
                                      .toList();
                                }
                                return Container(
                                  height: 60,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: DropdownButtonFormField2<String>(
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    isExpanded: true,
                                    hint: Text(
                                      'Select Account',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    value: selectedValue,
                                    items: filteredAcc!.map((item) {
                                      return DropdownMenuItem(
                                        value: item.pKCODE,
                                        child: Text("${item.nAME}"),
                                      );
                                    }).toList(),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select Account';
                                      }
                                      debugPrint('ACCOUNT: $value');
                                      // _box.write("FKUNIT", value);
                                      //return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue = value;
                                        debugPrint('Dropdown Value: $value');
                                        //_box.write("FKUNIT", value);
                                      });
                                    },
                                    onSaved: (value) {
                                      selectedValue = value.toString();
                                      debugPrint(
                                          'Saved Dropdown Value: $value');
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      padding: EdgeInsets.only(right: 8),
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.focused)) {
                                            return Colors
                                                .white; // Color when the button is pressed
                                          }
                                          return Colors.blue; // Default color
                                        },
                                      ),
                                    ),
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                      iconSize: 24,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: 200,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF144b9d),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.pressed)) {
                                            return Colors
                                                .blueAccent; // Color when the button is pressed
                                          }
                                          return Colors
                                              .redAccent; // Default color
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 50,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }
                            }),
                    Visibility(
                        visible: _selectedCash == "BPV",
                        child: const SizedBox(height: 20)),
                    Visibility(
                      visible: _selectedCash == "BPV",
                      child: MyTextForm(
                        textKeyboardType: TextInputType.number,
                        text: 'Cheque Number',
                        containerWidth: double.infinity,
                        hintText: 'Enter Cheque No..',
                        controller: bankController,
                        validator: (text) {
                          if (text.toString().isEmpty) {
                            return "Cheque Number is required";
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyTextForm(
                      textKeyboardType: TextInputType.number,
                      text: 'Amount',
                      containerWidth: double.infinity,
                      hintText: 'Enter Amount..',
                      controller: amountController,
                      validator: (text) {
                        if (text.toString().isEmpty) {
                          return "Amount is required";
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    MyTextForm(
                      textKeyboardType: TextInputType.name,
                      text: 'Remarks',
                      containerWidth: double.infinity,
                      hintText: 'Enter Remarks...',
                      controller: remarksController,
                      validator: (text) {
                        if (text.toString().isEmpty) {
                          return "Remarks are required";
                        }
                      },
                    ),
                    const SizedBox(height: 50),
                    RoundButton(
                      loading: loading,
                      width: double.infinity,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      onTap: () {
                        submitVendorPayment(context);

                        debugPrint(usid);
                        debugPrint(fkunit);
                        debugPrint(_selectedCash.toString());
                        debugPrint(_customerValue);
                        debugPrint(_pkCode);
                        debugPrint('${bankController.text}');
                        debugPrint(amountController.text);
                        debugPrint(remarksController.text);
                      },
                      title: 'Submit',
                    ),
                  ],
                ),
              ),
            )),
    );
  }
}

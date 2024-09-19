import 'dart:convert';

import 'package:bilal_goods/componets/textfield_login.dart';
import 'package:bilal_goods/model/location_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:bilal_goods/controller/login_controller.dart';
import 'package:intl/intl.dart';
import '../componets/roundbutton.dart';
import 'menu_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final appController = Get.put(AppController());
  GetStorage _box = GetStorage();

  bool? isObscurText = true;
  var emailCheck = '1';
  var location;
  var locationId;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  List<LocationModel> userList = <LocationModel>[];

  String? selectedValue;
  String dropdownValue = '';

  Future<List<LocationModel>> getLocationList(String USID) async {
    try {
      final response = await http.get(Uri.parse(
          'https://erm.scarletsystems.com:2012/Api/Account/GetLocation?USID=ADMIN'));
      debugPrint('USID is: $USID');
      final body = json.decode(response.body) as List;
      if (response.statusCode == 200) {
        locationId = body.map((e) {
          final map = e as Map<String, dynamic>;

          debugPrint("fKUNIT: ${map["FKUNIT"]}");
          debugPrint("nAME: ${map["NAME"]}");
          return LocationModel(fKUNIT: map["FKUNIT"], nAME: map["NAME"]);
        }).toList();
        debugPrint("DATA: ${locationId}");
        return locationId;
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  String formatDate(String? date) {
    if (date != null) {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    _box = GetStorage();
    //location = getLocationList(appController.emailContoller.text);
  }

  @override
  Widget build(BuildContext context) {
    if (appController.isUserLoggedIn) {
      // if user is already logged in, redirect to the main screen
      return MenuScreen();
    }
    return Scaffold(
      backgroundColor: const Color(0xFF0c3865),
      appBar: AppBar(
        backgroundColor: const Color(0xFF144b9d),
        foregroundColor: Colors.white,
        title: Text(
          "USER LOGIN",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: appController.formKey,
            child: GestureDetector(
              onTap: () {
                // When tapped outside the text field, remove focus
                if (_focusNode.hasFocus) {
                  _focusNode.unfocus();
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Image.asset(
                      "assets/images/bilalGoods.png",
                      height: 210,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 10),
                  MyTextFormLogin(
                    text: 'Email',
                    textKeyboardType: TextInputType.emailAddress,
                    containerWidth: double.infinity,
                    hintText: 'Enter your email',
                    prefixIcon: Icon(
                      Icons.email_rounded,
                      size: 24,
                      color: Colors.white,
                    ),
                    onchange: (value) {
                      setState(() async {
                        location = value;
                        await getLocationList(
                            appController.emailContoller.text.toString());
                        debugPrint("Location Id: $locationId");
                      });
                    },
                    controller: appController.emailContoller,
                    validator: (text) {
                      if (text.toString().isEmpty) {
                        return "Email is required";
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  MyTextFormLogin(
                    text: 'Password',
                    containerWidth: double.infinity,
                    hintText: 'Enter your password',
                    obscurText: isObscurText!,
                    sufixIcon: IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      icon: Icon(
                          color: Colors.white,
                          size: 24,
                          isObscurText!
                              ? Icons.visibility_off
                              : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isObscurText = !isObscurText!;
                        });
                      },
                    ),
                    controller: appController.passContoller,
                    validator: (text) {
                      if (text.toString().isEmpty) {
                        return "Password is required";
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Location",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  locationId == null
                      ? SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              isDense: true,
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white60),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              hintText: "Waiting For Data...",
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          ),
                        )
                      : FutureBuilder(
                          future: getLocationList(location.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  enabled: false,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white70),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.orange),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    hintText: "Loading Location Data",
                                    hintStyle: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              );
                            }
                            debugPrint(
                                "Total: ${snapshot.data!.length.toString()}");
                            if (snapshot.hasData) {
                              return Container(
                                height: 55,
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                child: DropdownButtonFormField2<String>(
                                  isExpanded: true,
                                  autofocus: true,
                                  hint: Text(
                                    'Select Your Location',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  value: selectedValue,
                                  items: snapshot.data!
                                      .map((e) => DropdownMenuItem<String>(
                                            value: e.fKUNIT,
                                            child: Text(
                                              e.nAME.toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: selectedValue == e.fKUNIT
                                                    ? Colors.white
                                                    : Colors.orangeAccent,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select locaton';
                                    }
                                    debugPrint('Location: $value');
                                    _box.write("FKUNIT", value);
                                    //return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value;
                                      debugPrint('Dropdown Value: $value');
                                      _box.write("FKUNIT", value);
                                    });
                                  },
                                  onSaved: (value) {
                                    selectedValue = value.toString();
                                    debugPrint('Saved Dropdown Value: $value');
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    padding: EdgeInsets.only(right: 8),
                                    overlayColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.focused)) {
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
                                        if (states
                                            .contains(MaterialState.pressed)) {
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
                                width: MediaQuery.of(context).size.width * 0.9,
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
                  const SizedBox(height: 30),
                  GetBuilder<AppController>(builder: (_) {
                    return RoundButton(
                      loading: appController.loading.value,
                      width: MediaQuery.of(context).size.width * 0.9,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      onTap: () => appController.login(),
                      title: 'Sign In',
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

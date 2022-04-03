import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/address/address_cubit.dart';
import 'package:my_smartstore/address/address_state.dart';
import 'package:my_smartstore/home/fragments/cart_fragment/cart_fragment_cubit.dart';
import 'package:my_smartstore/home/fragments/cart_fragment/cart_fragment_state.dart';
import 'package:my_smartstore/models/user_model.dart';
import 'package:my_smartstore/registration/authentication/auth_cubit.dart';
import 'package:my_smartstore/registration/authentication/auth_state.dart';

import '../constants.dart';

class AddressScreen extends StatefulWidget {
  late bool fromCart;
  late int totalAmount;

  AddressScreen(this.fromCart, this.totalAmount);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool? editMode, codEnabled;
  bool cod = false, showAppbar = true;
  String _name = '', _phone = '', _address = '', _pincode = '';
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        (context.read<AuthCubit>().state as Authenticated).userdata;

    if (editMode == null) {
      if (userModel.pincode == null) {
        editMode = true;
      } else {
        editMode = false;
      }
    }
    if (codEnabled == null) {
      (BlocProvider.of<CartFragmentCubit>(context).state as CartLoaded)
          .products
          .forEach((element) {
        if (codEnabled == null || codEnabled == true) {
          if (element.quantity! > 0) {
            codEnabled = element.cod;
          }
        }
      });
    }

    return Scaffold(
      appBar: showAppbar
          ? AppBar(
              title: Text('Shipping Details'),
            )
          : null,
      body: BlocConsumer<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state is AddressFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));

            if (state.message == UNAUTHENTICATED_USER) {
              context.read<AuthCubit>().removeToken();
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          }
          if (state is PaymentFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
          if (state is AddressUpdated) {
            userModel.name = state.name;
            userModel.address = state.address;
            userModel.contact_no = state.contact_no;
            userModel.pincode = state.pincode;
            userModel.district = state.district;
            userModel.state = state.state;
            setState(() {
              editMode = false;
            });
          }
          if (state is PaymentInitiated) {
            setState(() {
              showAppbar = false;
            });
            _openGateway(state, userModel);
          }
          if(state is PaymentProcessed){
            BlocProvider.of<CartFragmentCubit>(context).emit(CartLoaded([]));
          }
        },
        builder: (context, state) {
          if (state is InitiatingPayment || state is PaymentInitiated) {
            return Center(
              child: Text('Initiating Payment...'),
            );
          }

          if (state is ProcessingPayment) {
            return Center(
              child: Text('Processing Payment...'),
            );
          }

          if (state is PaymentProcessed) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Order Placed Successfully!",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Image.asset(
                      "assets/images/thankyou.png",
                      height: 150,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Thank You!\n${userModel.fullname}",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Your order has been placed successfully!",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            elevation: MaterialStateProperty.all(0),
                            fixedSize: MaterialStateProperty.all(
                                Size(double.maxFinite, 50))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('continue shopping'))
                  ],
                ),
              ),
            );
          }

          if (showAppbar == false) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              setState(() {
                showAppbar = true;
              });
            });
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/address.png",
                      height: 100,
                      width: 100,
                    ),
                    if (editMode == true) ...[
                      _nameField(userModel.name, state is! AddressUpdating),
                      SizedBox(
                        height: 24,
                      ),
                      _addressField(
                          userModel.address, state is! AddressUpdating),
                      SizedBox(
                        height: 24,
                      ),
                      _phoneField(userModel.contact_no,
                          state is! AddressUpdating, null),
                      SizedBox(
                        height: 24,
                      ),
                      _pincodeField(
                          userModel.pincode.toString(),
                          state is! AddressUpdating,
                          state is AddressFailed
                              ? state.message == 'invalid_pincode'
                                  ? "Invalid Pincode"
                                  : null
                              : null),
                      SizedBox(
                        height: 24,
                      ),
                      if (state is AddressUpdating) CircularProgressIndicator(),
                      SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              elevation: MaterialStateProperty.all(0),
                              fixedSize: MaterialStateProperty.all(
                                  Size(double.maxFinite, 50))),
                          onPressed: state is AddressUpdating
                              ? null
                              : () {
                                  if (formkey.currentState!.validate()) {
                                    context.read<AddressCubit>().updateAddress(
                                        _name, _address, _pincode, _phone);
                                  }
                                },
                          child: Text('Update'))
                    ],
                    if (editMode == false) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 8)
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userModel.name!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              userModel.contact_no!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              userModel.address!,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              userModel.pincode.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              userModel.district!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              userModel.state!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    elevation: MaterialStateProperty.all(0),
                                    fixedSize: MaterialStateProperty.all(
                                        Size(double.maxFinite, 50))),
                                onPressed: () {
                                  setState(() {
                                    editMode = true;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Edit",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      CheckboxListTile(
                          title: Text('Cash on delivery'),
                          value: cod,
                          onChanged: !codEnabled!
                              ? null
                              : (value) {
                                  setState(() {
                                    cod = value!;
                                  });
                                }),
                      SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              elevation: MaterialStateProperty.all(0),
                              fixedSize: MaterialStateProperty.all(
                                  Size(double.maxFinite, 50))),
                          onPressed: () {
                            BlocProvider.of<AddressCubit>(context)
                                .initiatePayment(
                                    (BlocProvider.of<CartFragmentCubit>(context)
                                            .state as CartLoaded)
                                        .products,
                                    widget.fromCart,
                                    widget.totalAmount,
                                    cod ? "COD" : "PREPAID");
                          },
                          child: Text('Continue'))
                    ]
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _nameField(initValue, enableForm) {
    return TextFormField(
      initialValue: initValue,
      enabled: enableForm,
      validator: (value) {
        if (value!.length <= 1) {
          return "Please enter a valid name!";
        }
        _name = value;
      },
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorStyle: TextStyle(height: 1),
          hintText: "Enter your Name",
          labelText: "Fullname",
          suffixIcon: const Icon(Icons.person)),
    );
  }

  Widget _addressField(initValue, enableForm) {
    return TextFormField(
      initialValue: initValue,
      maxLines: 3,
      enabled: enableForm,
      validator: (value) {
        if (value!.length <= 3) {
          return "Please enter a valid Address!";
        }
        _address = value;
      },
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorStyle: TextStyle(height: 1),
          hintText: "Enter your Delivery Address",
          labelText: "Address",
          suffixIcon: const Icon(Icons.home)),
    );
  }

  Widget _phoneField(initValue, enableForm, error) {
    return TextFormField(
      initialValue: initValue,
      maxLength: 10,
      enabled: enableForm,
      validator: (value) {
        if (value!.length != 10) {
          return "Please enter a valid Phone number!";
        }
        _phone = value;
      },
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorText: error,
          errorStyle: TextStyle(height: 1),
          hintText: "Enter your contact no.",
          labelText: "Contact no.",
          suffixIcon: const Icon(Icons.call)),
    );
  }

  Widget _pincodeField(initValue, enableForm, error) {
    return TextFormField(
      initialValue: initValue,
      maxLength: 6,
      enabled: enableForm,
      validator: (value) {
        if (value!.length != 6) {
          return "Please enter a valid Pincode!";
        }
        _pincode = value;
      },
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorText: error,
          errorStyle: TextStyle(height: 1),
          hintText: "Enter your Pincode",
          labelText: "Pincode",
          suffixIcon: const Icon(Icons.location_on)),
    );
  }

  void _openGateway(PaymentInitiated state, UserModel userModel) {
    String stage = "TEST";
    String orderId = state.orderId;
    String orderAmount = state.tx_amount;
    String tokenData = state.token;
    String customerName = userModel.fullname!;
    String orderCurrency = state.currency;
    String appId = state.appId;
    String customerPhone = userModel.phone!;
    String customerEmail = userModel.email!;
    String notifyUrl = "https://test.gocashfree.com/notify";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "notifyUrl": notifyUrl,
      "tokenData": tokenData,
      'color1': "#1C7ADB",
      'color2': "#ffffff",
    };
    if (cod) {
      var data = {
        'orderId': orderId,
        'orderAmount': orderAmount,
        'referenceId': '-',
        'txStatus': 'SUCCESS',
        'paymentMode': 'COD',
        'txMsg': 'collect cash on delivery',
        'txTime': '-',
        'signature': '-',
      };
      BlocProvider.of<AddressCubit>(context).notifyUrl(data);
      return;
    }

    CashfreePGSDK.doPayment(inputParams).then((value) {
      var data;
      if (value!['txStatus'] == 'SUCCESS') {
        data = {
          'orderId': value['orderId'],
          'orderAmount': value['orderAmount'],
          'referenceId': value['referenceId'],
          'txStatus': value['txStatus'],
          'paymentMode': value['paymentMode'],
          'txMsg': value['txMsg'],
          'txTime': value['txTime'],
          'signature': value['signature'],
        };
      } else {
        data = {
          'orderId': orderId,
          'orderAmount': orderAmount,
          'referenceId': value['referenceId'],
          'txStatus': value['txStatus'],
          'paymentMode': value['paymentMode'],
          'txMsg': value['txMsg'],
          'txTime': value['txTime'],
          'signature': value['signature'],
        };
      }
      BlocProvider.of<AddressCubit>(context).notifyUrl(data);
    });
  }
}

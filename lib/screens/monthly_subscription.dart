import 'package:book_zone/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class DummyCardPage extends StatefulWidget {
  @override
  _DummyCardPageState createState() => _DummyCardPageState();
}

class _DummyCardPageState extends State<DummyCardPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _cardNumber = '';
  String _expiryDate = '';
  String _cardHolderName = '';
  String _cvvCode = '';
  bool _isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Subscription'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: _cardNumber,
                expiryDate: _expiryDate,
                cardHolderName: _cardHolderName,
                cvvCode: _cvvCode,
                showBackView: _isCvvFocused, onCreditCardWidgetChange: (CreditCardBrand ) {  },
              ),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: _formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumberDecoration: InputDecoration(
                        labelText: 'Card Number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                      ),
                      expiryDateDecoration: InputDecoration(
                        labelText: 'Expired Date',
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: InputDecoration(
                        labelText: 'Card Holder',
                      ),
                      onCreditCardModelChange: onCreditCardModelChange, cardNumber: '', expiryDate: '', cardHolderName: '', cvvCode: '', themeColor: Colours.loginButtonColor,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Display the complete card
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Complete Card'),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Card Number: $_cardNumber'),
                                  Text('Cardholder Name: $_cardHolderName'),
                                  Text('Expiry Date: $_expiryDate'),
                                  Text('CVV: $_cvvCode'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      _cardNumber = creditCardModel.cardNumber;
      _expiryDate = creditCardModel.expiryDate;
      _cardHolderName = creditCardModel.cardHolderName;
      _cvvCode = creditCardModel.cvvCode;
      _isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
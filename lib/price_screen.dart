import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();

  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          bitcoinValue = '?';
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          bitcoinValue = '?';
          //2: Call getData() when the picker/dropdown changes.
        });
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  String bitcoinValue = '?';

  void getData() async {
    try {
      isWaiting = true;
      //We're now passing the selectedCurrency when we call getCoinData().
      var data = await CoinData().getCoinData(selectedCurrency);

      isWaiting = false;
      setState(() {
        bitcoinValue = data;
      });
    } catch (e) {
      print(e);
    }
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  Column makeCards() {
    List<CoinCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CoinCard(
          roleCoin: crypto,
          selectedCurrency: selectedCurrency,
          coinValue: isWaiting ? '?' : coinValues[crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }
  //TODO: Create a method here called getData() to get the coin data from coin_data.dart

  @override
  void initState() {
    super.initState();
    getData();

    //TODO: Call getData() when the screen loads up.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: [
              makeCards(),
            ],
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.green,
            ),
            child: IconButton(
              onPressed: () {
                getData();
              },
              icon: Icon(Icons.numbers),
              color: Colors.red,
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CoinCard extends StatelessWidget {
  const CoinCard(
      {Key key,
      @required this.roleCoin,
      @required this.coinValue,
      @required this.selectedCurrency})
      : super(key: key);
  final String roleCoin;
  final String coinValue;
  final String selectedCurrency;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            //TODO: Update the Text Widget with the live bitcoin data here.
            '1 $roleCoin = $coinValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

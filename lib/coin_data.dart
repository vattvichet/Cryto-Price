import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'USD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'AUD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '';

class CoinData {
  Future<dynamic> getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      http.Response response = await http.get(
          Uri.parse('$coinAPIURL/$crypto/$selectedCurrency?apiKey=$apiKey'));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double price = decodedData['rate'];
        cryptoPrices[crypto] = price.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        print(response.body);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}

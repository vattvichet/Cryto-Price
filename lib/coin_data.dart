import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
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
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '7275920B-6B7E-4F83-A34E-4BE1A2B0FF01';

class CoinData {
  Future<dynamic> getCoinData() async {
    http.Response response =
        await http.get(Uri.parse('$coinAPIURL/BTC/USD?apikey=$apiKey'));
    print(response.body);
    var data = response.body;
    if (response.statusCode == 200) {
      return jsonDecode(data)['rate'];
    } else {
      print(data);
      return null;
    }
  }
}

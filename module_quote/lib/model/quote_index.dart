
import 'package:library_base/utils/object_util.dart';

class QuoteIndex {

  String name;
  String pair;
  num quote;
  String ico;
  num cny;
  num change_percent;

  QuoteIndex({
    this.name,
    this.pair,
    this.quote,
    this.ico,
    this.cny,
    this.change_percent,
  });

  QuoteIndex.fromJson(Map<String, dynamic> jsonMap) {
    name = jsonMap['name'] ?? '';
    pair = jsonMap['pair'] ?? '';
    quote = jsonMap['quote'] ?? 0;
    ico = jsonMap['ico'] ?? '';
    cny = jsonMap['cny'] ?? 0;
    change_percent = jsonMap['change_percent'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['name'] = this.name;
    jsonMap['pair'] = this.pair;
    jsonMap['quote'] = this.quote;
    jsonMap['ico'] = this.ico;
    jsonMap['cny'] = this.cny;
    jsonMap['change_percent'] = this.change_percent;

    return jsonMap;
  }

  static List<QuoteIndex> fromJsonList(List<dynamic> mapList, String pair) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<QuoteIndex> items = new List<QuoteIndex>();
    for(Map<String, dynamic> map in mapList) {
      items.add(QuoteIndex.fromJson(map)..pair = pair);
    }
    return items;
  }
}


class QuoteIndexBasic {
  String coin_code;
  String pair;
  String data_src;
  double change_percent;
  double change_amount;
  double quote;
  double cny;
  List<QuoteIndex> exchange_quote_list;


  QuoteIndexBasic({
    this.coin_code,
    this.pair,
    this.data_src,
    this.change_percent,
    this.change_amount,
    this.quote,
    this.cny,
    this.exchange_quote_list,
  });

  QuoteIndexBasic.fromJson(Map<String, dynamic> jsonMap) {
    coin_code = jsonMap['coin_code'] ?? '';
    pair = jsonMap['pair'] ?? '';
    data_src = jsonMap['data_src'] ?? '';
    change_percent = jsonMap['change_percent'] ?? 0;
    change_amount = jsonMap['change_amount'] ?? 0;
    quote = jsonMap['quote'] ?? 0;
    cny = jsonMap['cny'] ?? 0;
    exchange_quote_list = QuoteIndex.fromJsonList(jsonMap['exchange_quote_list'], pair);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['coin_code'] = this.coin_code;
    jsonMap['data_src'] = this.data_src;
    jsonMap['change_percent'] = this.change_percent;
    jsonMap['change_amount'] = this.change_amount;
    jsonMap['quote'] = this.quote;
    jsonMap['cny'] = this.cny;
    jsonMap['exchange_quote_list'] = this.exchange_quote_list?.map((v) => v.toJson()).toList();

    return jsonMap;
  }

}

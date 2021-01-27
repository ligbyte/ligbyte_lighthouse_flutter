

import 'dart:async';

import 'package:lighthouse/mvvm/view_state.dart';
import 'package:lighthouse/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/spot_exchange_quote.dart';
import 'package:lighthouse/net/model/spot_exchange_quote_basic.dart';
import 'package:lighthouse/utils/object_util.dart';

class SpotQuoteModel extends ViewStateModel {

  SpotExchangeQuoteBasic quoteBasic;
  List<SpotExchangeQuote> quoteList = [];

  SpotQuoteModel() : super(viewState: ViewState.first);

  Future getQuote(String chain) {
    Map<String, dynamic> params = {
      'chain': chain,
    };

    return DioUtil.getInstance().requestNetwork(Constant.URL_GET_CHAIN_QUOTE, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          quoteBasic = SpotExchangeQuoteBasic.fromJson(data);
          quoteList = quoteBasic?.exchange_quote_list ?? [];

          if (ObjectUtil.isEmptyList(quoteList)) {
            setEmpty();
          } else {
            setSuccess();
          }
        },
        onError: (errno, msg) {
          setError(errno, message: msg);
        });
  }

}
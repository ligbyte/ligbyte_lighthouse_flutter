

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/dialog/share_widget.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/widget/shot_view.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:module_home/item/global_quote_item.dart';
import 'package:module_home/item/global_quote_round_item.dart';
import 'package:module_home/viewmodel/global_quote_model.dart';
import 'package:module_home/home_router.dart';
import 'package:module_home/widget/global_quote_appbar.dart';


class GlobalQuotePage extends StatefulWidget {

  GlobalQuotePage({
    Key key,
  }) : super(key: key);

  @override
  _GlobalQuotePageState createState() => _GlobalQuotePageState();
}

class _GlobalQuotePageState extends State<GlobalQuotePage> with BasePageMixin<GlobalQuotePage>, SingleTickerProviderStateMixin {

  ShotController _shotController = new ShotController();

  GlobalQuoteModel _globalQuoteModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initViewModel() {
    _globalQuoteModel = GlobalQuoteModel();
    _globalQuoteModel.getGlobalAll();
  }

  @override
  Future<void> refresh({slient = false}) {
    return _globalQuoteModel.getGlobalAll();
  }

  Future<void> _share() async {
    Uint8List pngBytes = await _shotController.makeImageUint8List();

    DialogUtil.showShareDialog(context,
        children: [
          ShareQRHeader(),
          Container(
            color: Colours.gray_100,
            child: Image.memory(pngBytes),
          )
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colours.gray_100,
        appBar: AppBar(
            leading: BackButtonEx(),
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colours.white,
            actions: <Widget>[
              IconButton(
                icon: LocalImage('icon_share', package: Constant.baseLib, width: 20, height: 20),
                onPressed: _share,
              )
            ],
            centerTitle: true,
            title: Text(S.of(context).globalQuote, style: TextStyles.textBlack18)
        ),
        body: ProviderWidget<GlobalQuoteModel>(
            model: _globalQuoteModel,
            builder: (context, model, child) {
              String package = HomeRouter.isRunModule ? null : Constant.moduleHome;
              return RefreshIndicator(
                  onRefresh: model.getGlobalAll,
                  child: model.isFirst ? FirstRefresh() :
                  Stack(
                    children: [
                      CommonScrollView(
                        physics: ClampingScrollPhysics(),
                        children: [
                          Stack(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: ClampingScrollPhysics(),
                                child: ShotView(
                                  controller: _shotController,
                                  child: Container(
                                    height: 428,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(ImageUtil.getImgPath('bg_world_map'), package: package),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    child: AspectRatio (
                                        aspectRatio: 1.7,
                                        child: Stack(
                                          children: _buildItem(),
                                        )
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),

                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 12 , vertical: 9),
                              decoration: BoxDecoration(
                                color: Colours.white,
                                borderRadius: BorderRadius.all(Radius.circular(14.0)),
                                boxShadow: BoxShadows.normalBoxShadow,
                              ),
                              child: Column(
                                children: [

                                  GridView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.fromLTRB(15, 18, 15, 12),
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.95,
                                    ),
                                    itemCount: model.quoteList.length,
                                    itemBuilder: (_, index) {
                                      return GlobalQuoteItem(
                                        index: index,
                                        name: model.quoteList[index].zh_name,
                                        price: model.quoteList[index].quote,
                                        change: model.quoteList[index].change_amount,
                                        rate: model.quoteList[index].change_percent,
                                      );
                                    },
                                  ),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: Text('*' + S.of(context).quoteDefinition, style: TextStyles.textGray500_w400_12)
                                  ),
                                  Gaps.vGap18,
                                ],
                              )
                          ),

                        ],
                      ),

                      Positioned(
                        top: 12,
                        left: 12,
                        right: 12,
                        child: GlobalQuoteAppBar(height: 55),
                      ),
                    ],
                  )

              );
            }
        )
    );
  }

  List<Widget> _buildItem() {
    final list = List.generate(_globalQuoteModel.quoteList.length, (index) {
      return GlobalQuoteRoundItem(
        index: index,
        name: _globalQuoteModel.quoteList[index].zh_name,
        posX: _globalQuoteModel.quoteList[index].posX,
        posY: _globalQuoteModel.quoteList[index].posY,
        rate: _globalQuoteModel.quoteList[index].change_percent,
      );
    });
    return list;
  }
}

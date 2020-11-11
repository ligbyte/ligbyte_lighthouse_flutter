

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/page2nd/news_page.dart';
import 'package:lighthouse/utils/image_util.dart';
import 'package:lighthouse/utils/screen_util.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  double _appBarOpacity = 0;
  double _toolbarHeight = 80;

  final _newsPageKey = GlobalKey<NewsPageState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _scrollNotify(double scrollY) {
    if (scrollY > 100) {
      var opacity = (scrollY - 100) / 100;
      setState(() {
        _appBarOpacity = opacity <= 1 ? opacity : 1;
      });
    } else {
      setState(() {
        _appBarOpacity = 0;
      });
    }
  }

  Future<void> _refresh()  {
    if (_newsPageKey.currentState != null) {
      return _newsPageKey.currentState.refresh(showHeader: false);
    }

    return Future<void>.delayed(const Duration(seconds: 1), () {

    });
//    await Future.wait<dynamic>([demo1,demo2,demo3]).then((e){
//
//      print(e);//[true,true,false]
//    }).catchError((e){
//
//    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: NestedScrollViewRefreshIndicator(
        onRefresh: _refresh,
        child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification.depth == 0 && notification is ScrollUpdateNotification) {
                _scrollNotify(notification.metrics.pixels);
              }
              return false;
            },
            child: extended.NestedScrollView(
              physics: const ClampingScrollPhysics(),
              pinnedHeaderSliverHeightBuilder: () {
                return _toolbarHeight;
              },
              innerScrollPositionKeyBuilder: () {
                return Key('Tab0');
              },
              headerSliverBuilder: (context, innerBoxIsScrolled) => _headerSliverBuilder(context),
              body: extended.NestedScrollViewInnerScrollPositionKeyWidget(Key('Tab0'), NewsPage(key: _newsPageKey, isSupportPull: false)),
            ),
          ),
      ),
    );
  }

  List<Widget> _headerSliverBuilder(BuildContext context) {
    return <Widget>[
      SliverAppBar(
          toolbarHeight: _toolbarHeight,
          titleSpacing: 0,
          elevation: 0.0,
          primary: false,
          actions: null,
          automaticallyImplyLeading : false,
          brightness: _appBarOpacity > 0.5 ? Brightness.light : Brightness.dark,
          backgroundColor: Colours.normal_bg,
          title: _titleBuilder(),
          centerTitle: true,
          expandedHeight: 500.0,
          floating: false, // 不随着滑动隐藏标题
          pinned: true, // 固定在顶部
          flexibleSpace: _flexibleSpeceBuilder()
      ),
      SliverToBoxAdapter(
        child: Container(
          color: Colours.toast_error,
          height: 1,
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colours.toast_warn,
            ),
            child: Container(
              height: 80.0,
              padding: const EdgeInsets.only(top: 8.0),
            ),
          ), 80.0,
        ),
      ),
    ];
  }

  Widget _titleBuilder() {
    return  Opacity(
      opacity: _appBarOpacity,
      child: Container(
        padding: EdgeInsets.only(top: ScreenUtil.getStatusBarH(context)),
        height: _toolbarHeight,
        decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.circular(3.0),
          boxShadow: [
            BoxShadow(
              color: Colours.normal_border_shadow,
              offset: Offset(0.0, 4.0),
              blurRadius: 30.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 24),
                        alignment: Alignment.centerLeft,
                        child: Text('标题', style: TextStyles.textBlack16,
                        )),
                    Gaps.vGap5,
                    Container(
                        margin: EdgeInsets.only(left: 24),
                        alignment: Alignment.centerLeft,
                        child: Text('副标题', style: TextStyles.textGray14,
                        )),
                  ],)
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text('标题2', style: TextStyles.textBlack16,)
                    ),
                    Gaps.vGap5,
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text('副标题2', style: TextStyles.textGray14,)
                    ),
                  ],)
            ),
          ],
        ),
      ),
    );
  }

  Widget _flexibleSpeceBuilder() {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: Stack(
        children: <Widget>[
          Container(
              height: 285,
              decoration: BoxDecoration(
                color: Colours.transparent,
                image: DecorationImage(
                  image: AssetImage(ImageUtil.getImgPath('bg_home')),
                  fit: BoxFit.fill,
                ),
              )
          ),
          Container(  //占满
            color: Colours.transparent,
          ),
        ],
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final double height;
  SliverAppBarDelegate(this.widget, this.height);

  // minHeight 和 maxHeight 的值设置为相同时，header就不会收缩了
  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return widget;
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
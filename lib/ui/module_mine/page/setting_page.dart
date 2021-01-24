

import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/mvvm/base_page.dart';
import 'package:lighthouse/mvvm/provider_widget.dart';
import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/net/rt_account.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/router/fade_route.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:lighthouse/ui/module_base/widget/button/back_button.dart';
import 'package:lighthouse/ui/module_base/widget/clickbar/setting_avatar_clickbar.dart';
import 'package:lighthouse/ui/module_base/widget/clickbar/setting_clickbar.dart';
import 'package:lighthouse/ui/module_base/widget/common_scroll_view.dart';
import 'package:lighthouse/ui/module_base/widget/dialog/dialog_util.dart';
import 'package:lighthouse/ui/module_base/widget/image/gallery_photo.dart';
import 'package:lighthouse/ui/module_mine/viewmodel/setting_model.dart';
import 'package:lighthouse/utils/toast_util.dart';

class SettingPage extends StatefulWidget {

  const SettingPage({
    Key key,
  }) : super(key : key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with BasePageMixin<SettingPage>{

  SettingModel _settingModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  void initViewModel() {
    _settingModel = SettingModel();
    _settingModel.listenEvent();
    _settingModel.addListener(() {
      if (_settingModel.isBusy) {
        showProgress(content: S.of(context).uploading);

      } else if (_settingModel.isError) {
        closeProgress();
        ToastUtil.error(_settingModel.viewStateError.message);

      } else if (_settingModel.isSuccess) {
        closeProgress();

        ToastUtil.success(S.of(context).modifySuccess);
        Navigator.pop(context);
      }
    });
  }

  void _avatarSelect() {
    DialogUtil.showAvatarSelectDialog(context,
        crop: true,
        selectCallback: (path) {
          _settingModel.uploadHeadIcon(path);
        },
        viewCallback: _viewAvatar
    );
  }

  void _viewAvatar() {

    Account account = RTAccount.instance().getActiveAccount();
    List<Gallery> galleryList = [Gallery(id: 'avatar', resource: account?.head_ico)];

    Navigator.push(
      context,
      FadeRoute(
        pageBuilder: (context) => GalleryPhotoViewWrapper(
          galleryItems: galleryList,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: 0,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  void _logout() {
    DialogUtil.showCupertinoAlertDialog(context,
        title: S.of(context).logout,
        content: S.of(context).logoutConfirm,
        cancel: S.of(context).cancel,
        confirm: S.of(context).confirm,
        cancelPressed: () => Navigator.of(context).pop(),
        confirmPressed: () {
          Navigator.of(context).pop();
          Routers.goBack(context);
          RTAccount.instance().logout();
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colours.normal_bg,
        appBar: AppBar(
            leading: BackButtonEx(),
            elevation: 0.5,
            brightness: Brightness.light,
            backgroundColor: Colours.white,
            centerTitle: true,
            title: Text(S.of(context).accountSecurity, style: TextStyles.textBlack18)
        ),
        body: ProviderWidget<SettingModel>(
            model: _settingModel,
            builder: (context, model, child) {
              Account account = RTAccount.instance().getActiveAccount();

              return CommonScrollView(
                  children: <Widget>[
                    Gaps.vGap10,
                    SettingAvatarClickBar(
                        title: S.of(context).myAvatar,
                        account: account,
                        onPressed: _avatarSelect
                    ),
                    SettingClickBar(
                      title: S.of(context).modifyNickname,
                      subTitle: account?.nick_name,
                      onPressed: () => Routers.loginGuardNavigateTo(context, Routers.modifyNicknamePage),
                    ),
                    SettingClickBar(
                      title: S.of(context).loginPhone,
                      subTitle: account?.phoneSecret,
                    ),
                    SettingClickBar(
                      title: S.of(context).modifyPassword,
                      onPressed: () => Routers.loginGuardNavigateTo(context, Routers.modifyPwdPage),
                    ),

                    Gaps.vGap18,

                    FlatButton(
                        color: Colours.white,
                        onPressed: () => _logout(),
                        padding: EdgeInsets.all(0.0),
                        child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            width: double.infinity,
                            child: Text(S.of(context).logout,
                              style: TextStyles.textRed_w400_15,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        )
                    ),


                  ]
              );
            }
        )

    );
  }

}

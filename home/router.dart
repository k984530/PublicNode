import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:node/home/root.dart';
import 'package:node/ui/page/ideas/ideaSetting.dart';
import 'package:node/ui/page/ideas/expalinIdea.dart';
import 'package:node/ui/page/ideas/mainIdeaPage.dart';
import 'package:node/ui/page/informations/adminMessage.dart';
import 'package:node/ui/page/informations/adminReport.dart';
import 'package:node/ui/page/informations/eula.dart';
import 'package:node/ui/page/informations/goldInfo.dart';
import 'package:node/ui/page/informations/info.dart';
import 'package:node/ui/page/informations/notice.dart';
import 'package:node/ui/page/menu.dart';
import 'package:node/ui/page/accounts/accountSetting.dart';
import 'package:node/ui/page/messages/mainMessagePage.dart';
import 'package:node/ui/page/messages/readApply.dart';
import 'package:node/ui/page/messages/readMessage.dart';
import 'package:node/ui/page/messages/sendMessage.dart';
import 'package:node/ui/page/splash/splash_page.dart';
import 'package:node/ui/page/teams/expalinTeam.dart';
import 'package:node/ui/page/teams/mainTeamPage.dart';
import 'package:node/ui/page/teams/teamSetting.dart';

class AppRouter {
  static Route<MaterialPageRoute> onNavigate(RouteSettings settings) {
    late final Widget selectedPage;

    switch (settings.name) {
      case eulaPage.route:
        selectedPage = eulaPage();
        break;
      case adminReportPage.route:
        selectedPage = adminReportPage();
        break;
      case goldInfoPage.route:
        selectedPage = goldInfoPage();
        break;
      case readApplyPage.route:
        selectedPage = readApplyPage();
        break;
      case editNoticePage.route:
        selectedPage = editNoticePage();
        break;
      case adminMessagePage.route:
        selectedPage = adminMessagePage();
        break;
      case messagePage.route:
        selectedPage = messagePage();
        break;
      case readMessagePage.route:
        selectedPage = readMessagePage();
        break;
      case sendMessagePage.route:
        selectedPage = sendMessagePage();
        break;
      case explainTeam.route:
        selectedPage = explainTeam();
        break;
      case explainIdea.route:
        selectedPage = explainIdea();
        break;
      case createIdea.route:
        selectedPage = createIdea();
        break;
      case splashPage.route:
        selectedPage = splashPage();
        break;
      case sendApplyPage.route:
        selectedPage = sendApplyPage();
        break;
      case ideaPage.route:
        selectedPage = ideaPage();
        break;
      case accountSettingPage.route:
        selectedPage = accountSettingPage();
        break;
      case teamPage.route:
        selectedPage = teamPage();
        break;
      case menuPage.route:
        selectedPage = menuPage();
        break;
      case teamSettingPage.route:
        selectedPage = teamSettingPage();
        break;
      default:
        selectedPage = Root();
        break;
    }

    return MaterialPageRoute(builder: (context) => selectedPage);
  }
}

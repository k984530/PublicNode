import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/messages_database.dart';
import 'package:node/models/account.dart';
import 'package:node/ui/page/accounts/accountSetting.dart';
import 'package:node/ui/page/accounts/provider/write_account_view_model_provider.dart';
import 'package:node/ui/page/informations/notice.dart';
import 'package:node/ui/page/messages/provider/write_message_view_model_provider.dart';

class eulaPage extends ConsumerWidget {
  const eulaPage({super.key});
  static const String route = '/eula';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 2.0,
        spreadRadius: 2.0,
        offset: Offset(2, 5),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('이용 약관'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: s,
                ),
                child: Text(
                  '''이 최종 사용자 라이센스 계약서("EULA")는 사용자와 IONEU(이하 "ONE") 사이의 법적 계약입니다. 사용자는 본 계약을 자세히 읽은 후 해당 서비스를 이용해야합니다.
                  
1. 사용자 제재
One은 불쾌한 콘텐츠나 악의적인 게시글을 올린 사용자에 대해서 사전 통보 없이 해당 게시글을 수정 및 삭제하거나, 작성자의 계정에 제재를 할 수 있습니다.

2. 자동 소프트웨어 업데이트.
One은 때때로 버그 수정, 업데이트, 업그레이드 및 기타 소프트웨어 수정 사항(이하 "업데이트")을 제공할 수 있습니다. 이것은 추가 공지 또는 추가 동의 없이 자동으로 설치될 수 있습니다. 사용자는 이 자동 업데이트에 동의합니다. 그러한 업데이트를 원하지 않는다면 제품 사용을 중단하십시오. 본 EULA 조건은 원래 소프트웨어를 교체하거나 보완하는 One에서 제공하는 모든 업데이트에 적용됩니다. 단 그러한 업데이트가 별도의 사용권과 함께 제공되는 경우 해당 사용권의 조건이 적용됩니다.
      
       
3. 앱 스토어(App Store).
Apple App Store, Google Play(이하 "App Store")와 같은 애플리케이션 시장 또는 매장에서 소프트웨어를 다운로드한 경우 사용자는 해당 App Store 이용 약관의 적용을 받습니다. 사용자의 소프트웨어 사용이 App Store의 이용 약관의 적용을 받는 경우, App Store의 사용 약관과 본 EULA 간에 상충되거나 모호한 경우, App Store의 사용은 적용되지만, 그러한 분쟁이나 모호성을 해결하는 데 필요한 범위까지만 적용되며, 본 EULA의 조항은 완전한 효력을 유지합니다. 사용자는 (i) 본 EULA가 App Store가 아닌 One과 사용자 간에 체결된 것이며; (ii) App Store는 다운로드한 소프트웨어와 관련해서 어떤 지원이나 유지보수를 제공할 의무가 없으며; (iii) 본 EULA에 제공된 대로 지정된 범위까지 App Store가 아닌 One이 App Store에서 다운로드한 소프트웨어의 제품 보증, 제품 청구 및 지적재산 청구에 대한 책임이 있고, 어떤 경우에도 보증에 대한 App Store의 최대 책임은 소프트웨어의 구매 가격 환불로 국한되며; (iv) Apple과 해당 자회사는 Apple App Store 및 Mac Store에서 다운로드한 소프트웨어에 대해 본 EULA의 제3의 수혜자임을 확인합니다.''',
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.of(context)
                    .pushReplacementNamed(accountSettingPage.route);
              },
              child: Container(
                margin: EdgeInsets.all(15),
                height: 50,
                width: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Text(
                  '동의 후 진행하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:account_managment/common/AppUtil.dart';
import 'package:account_managment/common/locale/localizations.dart';
import 'package:account_managment/manager/AccountManager.dart';
import 'package:account_managment/manager/NavigatorManager.dart';
import 'package:account_managment/manager/PreferencesManager.dart';
import 'package:account_managment/manager/RemoteManager.dart';
import 'package:account_managment/model/Account.dart';
import 'package:account_managment/model/lov/AccountSexLOV.dart';
import 'package:account_managment/model/lov/AccountStatusLOV.dart';
import 'package:account_managment/model/lov/AppBarActionLOV.dart';
import 'package:account_managment/model/lov/enums.dart';
import 'package:account_managment/screens/AccountDetailsEditor.dart';
import 'package:flutter/material.dart';

class AccountsViewer extends StatefulWidget {

  @override
  _AccountsViewerState createState() => _AccountsViewerState();
}

class _AccountsViewerState extends State<AccountsViewer> with SingleTickerProviderStateMixin {
  FirstScreenView fsv = PreferencesManager.createInstance().getCurrentViewMode();
  BuildContext _scaffoldContext;
  final _activeAccounts = <ListTile>[];
  final _inactiveAccounts = <ListTile>[];

  _AccountsViewerState();

  @override
  void initState() {
    super.initState();
    Future<List<Account>> accountList = AccountManager.createInstance().getAllAccounts();
    accountList.then((accounts) async => await _updateAccountsListView(accounts));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Builder(
            builder: (BuildContext  bc) {
              _scaffoldContext = bc;

              return fsv == FirstScreenView.LIST ? _buildListView() : _buildTabsView();
            }
        ),
        floatingActionButton: _buildNewBtn(),
      )
    );
  }

  _buildAppBar() {
    if(fsv == FirstScreenView.LIST) {
      return AppBar(
          title: _buildAppBarTitle(),
          actions: _buildAppBarActions(),
      );
    } else {
      return AppBar(
          title: _buildAppBarTitle(),
          actions: _buildAppBarActions(),
          bottom: _buildAppBarBottom()
      );
    }
  }
  _buildAppBarTitle() {
    return Text(AppLocalizations.of(context).first_screen_app_bar);
  }
  _buildAppBarActions() {
    return <Widget>[
//      IconButton(
//        icon: new Icon(AppBarActionLOV.firstScreenActions[0].icon),
//        tooltip: AppBarActionLOV.firstScreenActions[0].title,
//        onPressed: AppUtil.getOnChangeLanguageListener,
//      ),
        new IconButton(
          icon: new Icon(AppBarActionLOV.firstScreenActions[0].icon),
          tooltip: AppBarActionLOV.firstScreenActions[0].title,
          onPressed: () => _onAppBarActionSelected(AppBarActionLOV.firstScreenActions[0]),
        ),
      PopupMenuButton<AppBarActionLOV>(
        onSelected: _onAppBarActionSelected,
        itemBuilder: (BuildContext context) {
          return AppBarActionLOV.firstScreenActions.skip(1).map((AppBarActionLOV action) {
            return PopupMenuItem<AppBarActionLOV>(
              value: action,
              child: Text(action.title),
            );
          }).toList();
        },
      ),
    ];
  }
  _buildAppBarBottom() {
    return TabBar(
      indicatorColor: Colors.amber,
      tabs: [
        Tab(text: AppLocalizations.of(context).active_accounts_ttl,),
        Tab(text: AppLocalizations.of(context).inactive_accounts_ttl,),
      ]
    );
  }
  _onAppBarActionSelected(AppBarActionLOV action) async {
    if(action == AppBarActionLOV.LANGUAGE_SWITCH) {
      AppUtil.getOnChangeLanguageListener();
    } else if(action == AppBarActionLOV.VIEW_SWITCH) {
      setState(() {
        if(fsv == FirstScreenView.TABS)
          fsv = FirstScreenView.LIST;
        else
          fsv = FirstScreenView.TABS;
      });
      PreferencesManager.createInstance().setCurrentViewMode(fsv);
    } else if(action == AppBarActionLOV.PUSH_CLOUDY_DATA) {
      _pushDataToServer();
    } else if(action == AppBarActionLOV.FETCH_CLOUDY_DATA) {
      _fetchDataFromServer();
    } else if(action == AppBarActionLOV.SIGN_OUT) {
      AppUtil.onLoading(context, AppLocalizations.of(context).sign_out_msg);
      await RemoteManager.createInstance().signOut();
      PreferencesManager.createInstance().setUser(null);
//      NavigatorManager.createInstance().back(context);
      NavigatorManager.createInstance().goToLoginScreen(context);
    }
  }

  _buildTabsView() {
    return Scaffold(
      body: TabBarView(
        children: [
          _buildActiveAccountsWidget(),
          _buildInactiveAccountsWidget(),
        ],
      ),
    );
  }
  _buildListView() {
    return Container(
      child: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          _buildActiveAccountsHeader(),
          _buildActiveAccountsWidget(),
          SizedBox(height: 20,),
          _buildInactiveAccountsHeader(),
          _buildInactiveAccountsWidget(),
        ],
      ),
    );
  }

  _buildActiveAccountsHeader() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.green,
      ),
      child: Text(
          AppLocalizations.of(context).active_accounts_ttl,
        style: TextStyle(
            fontStyle: FontStyle.normal,
            color: Colors.white
        ),
      ),
    );
  }
  _buildActiveAccountsWidget() {
    if(_activeAccounts.length == 0)
      return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(AppLocalizations.of(context).msg_no_actv_acnts),
        ),
      );

    return Padding(
      padding: EdgeInsets.all(5),
      child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: _activeAccounts.length,
          itemBuilder: (context, index) {
            return _activeAccounts[index];
          }
      ),
    );
  }
  _buildInactiveAccountsHeader() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.red,
      ),
      child: Text(
        AppLocalizations.of(context).inactive_accounts_ttl,
        style: TextStyle(
            fontStyle: FontStyle.normal,
            color: Colors.white
        ),
      ),
    );
  }
  _buildInactiveAccountsWidget() {
    if(_inactiveAccounts.length == 0)
      return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(AppLocalizations.of(context).msg_no_inactv_acnts),
        ),
      );

    return Padding(
      padding: EdgeInsets.all(5),
      child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: _inactiveAccounts.length,
          itemBuilder: (context, index) {
            return _inactiveAccounts[index];
          }
      ),
    );
  }
  _buildNewBtn() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      tooltip: AppLocalizations.of(context).btn_new_hnt,
//      onPressed: () => Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context){
//            return AccountDetailsEditor(account: Account.newBorn());
//          })
//      ).then((val) async {
//          List<Account> accountList = await AccountManager.createInstance().getAllAccounts();
//          await _updateAccountsListView(accountList);
//        }
//      ),
    onPressed: () => NavigatorManager.createInstance().goToAccountDetailsEditor(context, Account.newBorn(), () async {
      List<Account> accountList = await AccountManager.createInstance().getAllAccounts();
      await _updateAccountsListView(accountList);
    }),
    );
  }

  _updateAccountsListView(List<Account> accountList) async {
    _activeAccounts.clear();
    _inactiveAccounts.clear();

    accountList.forEach((acnt){
      var wdgt = ListTile(
        leading: CircleAvatar(
          child: Text(
              acnt.firstName[0] + acnt.lastName[0]
          ),
          backgroundColor: acnt.sex == AccountSexLOV.MALE ? Theme.of(context).primaryColorLight : Colors.pink,
        ),
        title: Text(acnt.firstName + " " + acnt.lastName),
        subtitle: Text(acnt.job.desc),
        trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteAccount(context, acnt)
        ),
        onTap: () =>
//            Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => AccountDetailsEditor(account: acnt))
//            ).then((val) async {
//              List<Account> accountList = await AccountManager.createInstance().getAllAccounts();
//              await _updateAccountsListView(accountList);
//            }),
        NavigatorManager.createInstance().goToAccountDetailsEditor(context, acnt, () async {
          List<Account> accountList = await AccountManager.createInstance().getAllAccounts();
          await _updateAccountsListView(accountList);
        }),
      );

      setState(() {
        if(acnt.status == AccountStatusLOV.ACTIVE)
          _activeAccounts.add(wdgt);
        else
          _inactiveAccounts.add(wdgt);
      });
    });
  }
  _deleteAccount(BuildContext ctxt, Account a) async {
    AppUtil.showAlertDialog(ctxt,
      AppLocalizations.of(context).delete_account_ttl,
      AppLocalizations.of(context).delete_account_msg,
      AppLocalizations.of(context).btn_cncl_ttl,
      AppLocalizations.of(context).btn_acpt_ttl,
        () async {
            await AccountManager.createInstance().deleteAccount(a);
            List<Account> accountList = await AccountManager.createInstance().getAllAccounts();
            await _updateAccountsListView(accountList);
            NavigatorManager.createInstance().back(context);
            AppUtil.showMessageBar(_scaffoldContext, AppLocalizations.of(context).msg_acnt_deleted_dn);
          },
    );
  }
  _pushDataToServer() async {
    AppUtil.onLoading(context, AppLocalizations.of(context).psh_dta_srvr_msg);
    List<Account> accountList = await AccountManager.createInstance().getAllAccounts();
    await RemoteManager.createInstance().pushAccountsToServer(accountList);
    NavigatorManager.createInstance().back(context);

    AppUtil.showMessageBar(_scaffoldContext, AppLocalizations.of(context).msg_psh_dta_srvr_dn);
  }
  _fetchDataFromServer() async {
    AppUtil.onLoading(context, AppLocalizations.of(context).ftch_dta_lcl_msg);
    List<Account> accountsList = await RemoteManager.createInstance().fetchAccountsFromServer();
    await AccountManager.createInstance().saveAccounts(accountsList);
    await _updateAccountsListView(accountsList);
    NavigatorManager.createInstance().back(context);

    AppUtil.showMessageBar(_scaffoldContext, AppLocalizations.of(context).msg_ftch_dta_lcl_dn);
  }

}
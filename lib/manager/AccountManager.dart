import 'package:account_managment/dao/AccountDAO.dart';
import 'package:account_managment/model/Account.dart';

class AccountManager {

  static AccountManager _instance;

  AccountManager.createInstance();

  factory AccountManager() {
    if(_instance == null)
      _instance = AccountManager.createInstance();

    return _instance;
  }

  AccountDAO dao = new AccountDAO();

  Future<List<Account>> getAllAccounts() async {
    List<Account> accounts = await dao.all();
    return accounts;
  }

  Future<void> deleteAccount(Account a) async {
    await dao.delete(a);
  }

  void saveAccount(Account a) async {
//    if(a.id == null)
      await dao.insert(a);
//    else
//      await dao.update(a);
  }

  Future<void> saveAccounts(List<Account> as) async {
//    if(a.id == null)
    await dao.insertBatch(as);
//    else
//      await dao.update(a);
  }

}
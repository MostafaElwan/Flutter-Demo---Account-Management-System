import 'package:account_managment/manager/NavigatorManager.dart';
import 'package:account_managment/model/lov/AccountHoppyLOV.dart';
import 'package:account_managment/model/lov/AccountSexLOV.dart';
import 'package:account_managment/model/lov/AccountStatusLOV.dart';
import 'package:account_managment/model/lov/JobTypeLOV.dart';
import 'package:intl/intl.dart';
import 'package:account_managment/manager/AccountManager.dart';
import 'package:account_managment/model/Account.dart';
import 'package:flutter/material.dart';


class AccountDetailsEditor extends StatefulWidget {
  final Account account;

  AccountDetailsEditor({Key key, @required this.account}) : super(key: key);

  @override
  _AccountDetailsEditorState createState() => _AccountDetailsEditorState();
}

class _AccountDetailsEditorState extends State<AccountDetailsEditor> {
  final _formKey = GlobalKey<FormState>();
  final df = new DateFormat('yyyy-MMMM-dd');
//  final account;

  final _fnCntrl = new TextEditingController();
  final _lnCntrl = new TextEditingController();
  final _ntsCntrl = new TextEditingController();
  DateTime _birthDate;
  AccountStatusLOV _selectedStatus;
  JobTypeLOV _selectedJob;
  AccountSexLOV _selectedSex;
  double _selectedPower = 0.0;
  Set<AccountHoppyLOV> _hoppies = Set();

//  _AccountDetailsEditorState(this.account);

  @override
  void initState() {
    super.initState();

    _loadAccountDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Account Details"),
        ),
        body: _buildScreenForm(context));
  }

  _buildScreenForm(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.title;
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                _buildStatusControl(),
                _buildPowerControl(),
              ],
            ),
            _buildFirstNameField(textStyle),
            _buildLastNameField(textStyle),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _buildJobDropDown(),
                  ),
                  Expanded(
                    child: _buildDatePicker(),
                  ),
                ],
              ),
            ),
            _buildSexOptions(),
            Row(
              children: <Widget>[
                Expanded(
                    child: _buildHoppiesOptions(),
                ),
                Expanded(
                  child: _buildCommentField(textStyle),
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(5),
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text("Save"),
                        onPressed: _saveAccount,
                      ),
                    )),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorLight,
                          textColor: Theme.of(context).accentColor,
                          child: Text("Cancel"),
                          onPressed: () => NavigatorManager.createInstance().back(context),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _buildStatusControl() {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text('Satus: ${_selectedStatus.desc}'),
          Switch(
            value: _selectedStatus == AccountStatusLOV.ACTIVE,
            onChanged: (bool isChecked) {
              setState(() {
                _selectedStatus = isChecked ? AccountStatusLOV.ACTIVE : AccountStatusLOV.INACTIVE;
              });
            },
            activeColor: Colors.green,
          ),
        ],
      )
    );
  }

  _buildPowerControl() {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text('Power: ${_selectedPower.round()}'),
          Slider(
            value: _selectedPower,
            activeColor: Colors.green,
            min: 0.0,
            max: 100.0,
            onChanged: (newRating) {
              setState(() => _selectedPower = newRating);
            },
          )
        ],
      ),
    );
  }

  _buildFirstNameField(TextStyle textStyle) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: TextFormField(
        style: textStyle,
        controller: _fnCntrl,
        decoration: InputDecoration(
            labelText: 'First Name',
            hintText: 'Enter account first name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
            )),
        validator: (val) {
          if (val.isEmpty) return 'Please enter account first name !';
        },
      ),
    );
  }

  _buildLastNameField(TextStyle textStyle) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: TextFormField(
        style: textStyle,
        controller: _lnCntrl,
        decoration: InputDecoration(
            labelText: 'Last Name',
            hintText: 'Enter account last name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
            )),
        validator: (val) {
          if (val.isEmpty) return 'Please enter account last name !';
        },
      ),
    );
  }

  _buildJobDropDown() {
    List<DropdownMenuItem<JobTypeLOV>> list = [];
    JobTypeLOV.all.forEach((jobType) {
      list.add(DropdownMenuItem<JobTypeLOV>(
        child: Text(jobType.desc),
        value: jobType,
      ));
    });

    return DropdownButton<JobTypeLOV>(
      hint: Text('Select Job'),
      value: _selectedJob,
      onChanged: (newValue) {
        setState(() {
          _selectedJob = newValue;
        });
      },
      items: list,
    );
  }

  _buildDatePicker() {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Text(
              "Birth Date",
              textAlign: TextAlign.start,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                  '${_birthDate != null ? df.format(_birthDate) : "-----"}'
              ),
              SizedBox(width: 5),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(3000),
    );

    if(picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  _buildSexOptions() {
    final list = <Widget>[];
    AccountSexLOV.all.forEach((sex) {
      list.add(
        Expanded(
          child: RadioListTile(
            value: sex.code,
            groupValue: _selectedSex.code,
            onChanged: _selectSex,
            activeColor: _selectedSex == AccountSexLOV.MALE ? Theme.of(context).primaryColor : Colors.pink,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(sex.desc),
          )
        )
      );
    });

    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: new Container(
        padding: new EdgeInsets.all(10.0),
        child: new Center(
          child: new Row(
            children: list,
          ),
        ),
      )
    );
  }
  _selectSex(int s) {
    setState(() {
      _selectedSex = AccountSexLOV.fromCode(s);
    });
  }

  _buildHoppiesOptions() {
    final list = <Widget>[];
//    list.add(CheckboxListTile(
//      value: _isHoppyChecked(0),
//      onChanged: (bool val){_selectHoppy(val, 0);},
//      title: new Text('Drawing'),
//      controlAffinity: ListTileControlAffinity.leading,
//      activeColor: Colors.red,
//    ));
//    list.add(CheckboxListTile(
//      value: _isHoppyChecked(1),
//      onChanged: (bool val){_selectHoppy(val, 1);},
//      title: new Text('Reading'),
//      controlAffinity: ListTileControlAffinity.leading,
//      activeColor: Colors.red,
//    ));
//    list.add(CheckboxListTile(
//      value: _isHoppyChecked(2),
//      onChanged: (bool val){_selectHoppy(val, 2);},
//      title: new Text('Writing'),
//      controlAffinity: ListTileControlAffinity.leading,
//      activeColor: Colors.red,
//    ));
//    list.add(CheckboxListTile(
//      value: _isHoppyChecked(3),
//      onChanged: (bool val){_selectHoppy(val, 3);},
//      title: new Text('Football'),
//      controlAffinity: ListTileControlAffinity.leading,
//      activeColor: Colors.red,
//    ));

    AccountHoppyLOV.all.forEach((hpy){
      list.add(CheckboxListTile(
        value: _isHoppyChecked(hpy),
        onChanged: (bool isChecked){_selectHoppy(isChecked, hpy.code);},
        title: new Text(hpy.desc),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.red,
      ));
    });

    return Container(
      child: Center(
        child: Column(
          children: list,
        ),
      ),
    );
  }
  _selectHoppy(bool isChecked, int code) {
    setState(() {
      if(isChecked)
        _hoppies.add(AccountHoppyLOV.fromCode(code));
      else
        _hoppies.remove(AccountHoppyLOV.fromCode(code));
    });
  }
  _isHoppyChecked(AccountHoppyLOV hpy) {
    return _hoppies != null && _hoppies.contains(hpy);
  }

  _buildCommentField(TextStyle textStyle) {
    return Container(
      child: TextFormField(
        style: textStyle,
        controller: _ntsCntrl,
        maxLines: 6,
        decoration: InputDecoration(
            labelText: 'Comment',
            hintText: 'Enter some comments on the account here ...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
            )),
      ),
    );
  }

  _loadAccountDetails() {
    Account a = widget.account;
    if(a != null) {
      _fnCntrl.text = a.firstName;
      _lnCntrl.text = a.lastName;
      _selectedStatus = a.status;
      _selectedJob = a.job;
      _birthDate = a.bod;
      _selectedSex = a.sex;
      _ntsCntrl.text = a.comment;
      _selectedPower = a.power;
      _hoppies = a.hoppies;
    }
  }

  _saveAccount() {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      final am = new AccountManager();
      Account a = new Account.withId(
        widget.account.id,
        _fnCntrl.text,
        _lnCntrl.text,
        _selectedJob,
        _birthDate,
        _selectedSex,
        _selectedStatus,
        _hoppies,
        _ntsCntrl.text,
        _selectedPower
      );
      am.saveAccount(a);
      NavigatorManager.createInstance().back(context);
    }
  }
}

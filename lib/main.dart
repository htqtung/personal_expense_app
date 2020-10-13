import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoApp(
            title: 'Personal Expenses',
            theme: CupertinoThemeData(
              primaryColor: Colors.indigo,
              //   accentColor: Colors.amber,
              //   textTheme: ThemeData.light().textTheme.copyWith(
              //         headline6: TextStyle(
              //             fontFamily: 'Poppins',
              //             fontWeight: FontWeight.w500,
              //             fontSize: 16),
              //       ),
              //   appBarTheme: AppBarTheme(
              //     textTheme: ThemeData.light().textTheme.copyWith(
              //           headline6: TextStyle(
              //               fontFamily: 'Poppins',
              //               fontWeight: FontWeight.w600,
              //               fontSize: 20),
              //         ),
              //   ),
              // ),
              // darkTheme: ThemeData(
              //   primarySwatch: Colors.deepPurple,
              //   accentColor: Colors.orange,
            ),
            home: MyHomePage(),
          )
        : MaterialApp(
            title: 'Personal Expenses',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              accentColor: Colors.amber,
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
              appBarTheme: AppBarTheme(
                textTheme: ThemeData.light().textTheme.copyWith(
                      headline6: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
              ),
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.orange,
            ),
            home: MyHomePage(),
          );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: '1',
      title: 'Yonex Astrox 88S',
      amount: 29.99,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: '2',
      title: 'Yonex Voltric Zforce 2',
      amount: 39.99,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: '3',
      title: 'Keychron K1 TKL',
      amount: 84.99,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
    Transaction(
      id: '4',
      title: 'iPhone 11 Pro',
      amount: 79.99,
      date: DateTime.now().subtract(Duration(days: 4)),
    ),
    Transaction(
      id: '5',
      title: 'Apple Watch Series 5',
      amount: 49.99,
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
    Transaction(
      id: '6',
      title: 'Apple Airpods Pro',
      amount: 29.99,
      date: DateTime.now().subtract(Duration(days: 6)),
    ),
    Transaction(
      id: '7',
      title: 'Apple Macbook Pro 13"',
      amount: 99.99,
      date: DateTime.now(),
    ),
  ];

  bool _chartVisibility = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where(
            (transaction) => transaction.date.isAfter(DateTime.now().subtract(
                  Duration(days: 7),
                )))
        .toList();
  }

  void _addTransaction(String title, double amount, DateTime transactionDate) {
    final newTransaction = Transaction(
      title: title,
      amount: amount,
      id: DateTime.now().toString(),
      date: transactionDate,
    );
    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewTransaction(_addTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget transactionListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Show chart'),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _chartVisibility,
            onChanged: (val) => setState(() {
              _chartVisibility = val;
            }),
          ),
        ],
      ),
      _chartVisibility
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.8,
              child: Chart(_recentTransactions),
            )
          : transactionListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget transactionListWidget,
  ) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.25,
        child: Chart(_recentTransactions),
      ),
      transactionListWidget,
    ];
  }

  Widget _buildAppBar(Text titleText) {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: titleText,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _startAddNewTransaction(context),
                  child: Icon(CupertinoIcons.add),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final _isLandscape = mediaQuery.orientation == Orientation.landscape;
    final _titleText = Text('Personal Expenses');
    final PreferredSizeWidget _appBar = _buildAppBar(_titleText);
    final _transactionListWidget = Container(
      height: (mediaQuery.size.height -
              _appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.75,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final _appBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (_isLandscape)
              ..._buildLandscapeContent(
                  mediaQuery, _appBar, _transactionListWidget),
            if (!_isLandscape)
              ..._buildPortraitContent(
                  mediaQuery, _appBar, _transactionListWidget),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: _appBody,
            navigationBar: _appBar,
          )
        : Scaffold(
            appBar: _appBar,
            body: _appBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterFloat,
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}

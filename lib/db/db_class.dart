
import 'package:flutter/material.dart';
import 'package:register_shop_app/models/users/User.dart';

class Db extends ChangeNotifier {

  bool _fetchingData = false;
  User _user;

  User get getCurrentUser => _user;

  set setUser(User user){
    _user = user;
  }

  void setFetchingData(bool state){
    _fetchingData = state;
    notifyListeners();
  }

  bool get isFetching{
    return _fetchingData;
  }

  double price;


}

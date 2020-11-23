import 'package:flutter/material.dart';
import 'package:skype_clone/enum/view_state.dart';

class ImageUploadProvider with ChangeNotifier {
  ViewState _viewState = ViewState.IDEL;

  ViewState get getViewState => _viewState;

  void setToLoding() {
    _viewState = ViewState.LOADING;
    notifyListeners();
  }

  void setToIdel() {
    _viewState = ViewState.IDEL;
    notifyListeners();
  }
}

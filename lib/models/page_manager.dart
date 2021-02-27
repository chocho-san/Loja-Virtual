import 'package:flutter/material.dart';


class PageManager extends ChangeNotifier{

  PageController _pageController;

  set pageControllers(PageController controller){
    _pageController =controller;
  }



/*
  PageController _pageController;

  set pageControllers(PageController controller) { //pageController受け取り。
    _pageController = controller;
  }*/


  int page = 0;

  void setPage(int value){
    if(value == page) return;
    page = value;
    _pageController.jumpToPage(value);
  }
}
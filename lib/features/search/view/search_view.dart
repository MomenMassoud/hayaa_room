import 'package:flutter/material.dart';

import '../widget/search_view_body.dart';


class SearchView extends StatefulWidget{
  static const id = 'SearchView';
  _SearchView createState()=>_SearchView();
}

class _SearchView extends State<SearchView>{
  @override
  Widget build(BuildContext context) {
    return SearchViewBody();
  }

}

import 'package:bureau_couple/getx/repository/repo/matches_repo.dart';
import 'package:get/get.dart';

import '../../src/models/matches_model.dart';




class FilterController extends GetxController implements GetxService {

  FilterController();


  bool _isLoading = false;
  bool get isLoading => _isLoading;


  final List<String> _filterReligion = [];
  List<String> get filterReligion => _filterReligion;
  final List<int> _filterReligionList = [];
  List<int> get filterReligionList => _filterReligionList;

  void setFilterReligion(String val,int id) {
    if (_filterReligion.contains(val)) {
      _filterReligion.remove(val);
      _filterReligionList.remove(id);
    } else {
      _filterReligion.add(val);
      _filterReligionList.add(id);
    }
    update();
  }

  final List<String> _filterCommunity = [];
  List<String> get filterCommunity => _filterCommunity;

  final List<int> _filterCommunityList = [];
  List<int> get filterCommunityList => _filterCommunityList;

  void setFilterCommunity(String val,int id) {
    if (_filterCommunity.contains(val)) {
      _filterCommunity.remove(val);
      _filterCommunityList.remove(id);
    } else {
      _filterCommunity.add(val);
      _filterCommunityList.add(id);
    }
    update();
  }

  final List<String> _filterMotherTongue = [];
  List<String> get filterMotherTongue => _filterMotherTongue;
  final List<int> _filterMotherTongueList = [];
  List<int> get filterMotherTongueList => _filterMotherTongueList;

  void setFilterMotherTongue(String val,int id) {
    if (_filterMotherTongue.contains(val)) {
      _filterMotherTongue.remove(val);
      _filterMotherTongueList.remove(id);
    } else {
      _filterMotherTongue.add(val);
      _filterMotherTongueList.add(id);
    }
    update();
  }

  final List<String> _filterProfession = [];
  List<String> get filterProfession => _filterProfession;
  final List<int> _filterProfessionList = [];
  List<int> get filterProfessionList => _filterProfessionList;

  void setFilterProfession(String val,int id) {
    if (_filterProfession.contains(val)) {
      _filterProfession.remove(val);
      _filterProfessionList.remove(id);
    } else {
      _filterProfession.add(val);
      _filterProfessionList.add(id);
    }
    update();
  }

  bool isExpanded = false;
  void toggleExpanded() {
    isExpanded = !isExpanded;
    update();
  }
  final List<String> matchFilterTopList = ['Religion','Community','Preferred','Mother Tongue',];
  final List<String> connectedFilterTopList = ['Sent','Request','Connected'];
  int _selectedMatchFilterTop = 0;
  int get selectedMatchFilterTop => _selectedMatchFilterTop;


  void setSelectedMatchFilterTop (int index) {
    _selectedMatchFilterTop = index;
    update(); // This will call GetBuilder to rebuild the widget
  }



}


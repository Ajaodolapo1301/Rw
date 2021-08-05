//import 'dart:convert';
//
//import 'package:flutter/cupertino.dart';
//import 'package:rex_money/models/history.dart';
//import 'package:http/http.dart';
//
//
//const stagingUrl = "https://staging.api.rexwire.co/api/v1";
//enum LoadMoreStatus { LOADING, STABLE }
//
//
//class DataProvider with ChangeNotifier {
//  APIService _apiService;
//
//  AccountStatement accountStatementModel;
//  int totalPages = 0;
//  int pageSize = 10;
//
//  List<StatementModel> get allTransaction => accountStatementModel.statementModel;
//  double get totalRecords =>  allTransaction.length.toDouble();
//
//  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
//  getLoadMoreStatus() => _loadMoreStatus;
//
//  DataProvider() {
//    _initStreams();
//  }
//
//  void _initStreams() {
//    _apiService = APIService();
//    accountStatementModel = AccountStatement();
//  }
//
//  void resetStreams() {
//    _initStreams();
//  }
//
//  fetchAllStatement({pageNumber, from_date, to_date,  page_size, token}) async {
//
//    if ((totalPages == 0) || pageNumber <= totalPages) {
//      print("yess");
//      AccountStatement accountStatement = await _apiService.getData(page_size: page_size, pageNumber: pageNumber, to_date: to_date, from_date: from_date, token: token);
//      if (accountStatementModel.statementModel == null) {
//        print("No");
//        totalPages =  ((accountStatement.statementModel.length - 1) / pageSize).ceil();
//        accountStatementModel = accountStatement;
//      } else { print("maybe");
//        accountStatementModel.statementModel.addAll(accountStatement.statementModel);
//        accountStatementModel = accountStatementModel;
//
//        // One load more is done will make it status as stable.
//        setLoadingState(LoadMoreStatus.STABLE);
//      }
//
//      notifyListeners();
//    }
//
//    if(pageNumber > totalPages){
//      // One load more is done will make it status as stable.
//      setLoadingState(LoadMoreStatus.STABLE);
//      notifyListeners();
//    }
//  }
//
//  setLoadingState(LoadMoreStatus loadMoreStatus) {
//    _loadMoreStatus = loadMoreStatus;
//    notifyListeners();
//  }
//}
//
//
//
//
//class APIService {
//  Future<AccountStatement> getData({pageNumber,from_date, to_date,  page_size, token}) async {
//    String url ;
//    if(from_date != null && to_date != null){
//url  =  "$stagingUrl/auth/wallet/fiat/statement?from_date=$from_date&to_date=$to_date&page_index=$pageNumber&page_size=10";
//
//    }else{
// url  = "$stagingUrl/auth/wallet/fiat/statement?page_index=$pageNumber&page_size=10";
//     }
//
//print(to_date);
//    print("URL : $url");
//    var headers = {'Authorization': 'Bearer $token'};
//    final response = await get(url,headers: headers );
//
//    print(response.body);
//    print(response.statusCode);
//    if (response.statusCode == 200) {
//      return AccountStatement.fromJson(json.decode(response.body),
//      );
//    } else {
//      throw Exception('Failed to load data!');
//    }
//  }
//}
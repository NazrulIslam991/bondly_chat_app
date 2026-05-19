import 'get_all_product.dart';
import 'get_model.dart';

class GetStateModel {
  final List<GetModel> dataList;
  final List<GetAllProductModel> getAllProductModel;
  final bool isLoading;
  final bool isLoadMore;
  final int currentPage;
  final bool hasNextPage;
  final String? errorMessage;

  GetStateModel({
    required this.dataList,
    this.getAllProductModel = const [],
    this.isLoading = false,
    this.isLoadMore = false,
    this.currentPage = 1,
    this.hasNextPage = true,
    this.errorMessage,
  });

  GetStateModel copyWith({
    List<GetModel>? dataList,
    List<GetAllProductModel>? getAllProductModel,
    bool? isLoading,
    bool? isLoadMore,
    int? currentPage,
    bool? hasNextPage,
    String? errorMessage,
  }) {
    return GetStateModel(
      dataList: dataList ?? this.dataList,
      getAllProductModel: getAllProductModel ?? this.getAllProductModel,
      isLoading: isLoading ?? this.isLoading,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

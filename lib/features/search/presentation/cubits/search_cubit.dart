import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/search/domain/search_repo.dart';
import 'package:socialx/features/search/presentation/cubits/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;
  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final users = await searchRepo.searchUsers(query);
      emit(SearchLoaded(users));
    } catch (e) {
      emit(SearchError("Search Error $e"));
    }
  }
}

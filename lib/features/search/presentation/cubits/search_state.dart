import 'package:socialx/features/profile/domain/models/profile_user.dart';

abstract class SearchState {}

//initial

class SearchInitial extends SearchState {}

//loading
class SearchLoading extends SearchState {}

//loaded
class SearchLoaded extends SearchState {
  final List<ProfileUser?> users;
  SearchLoaded(this.users);
}

//error

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

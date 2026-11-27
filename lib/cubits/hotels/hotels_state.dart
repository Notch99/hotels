part of 'hotels_cubit.dart';

abstract class HotelsState {}

class HotelsInitial extends HotelsState {}

class HotelsLoading extends HotelsState {}

class HotelsLoaded extends HotelsState {
  final List<Hotel> hotels;
  HotelsLoaded(this.hotels);
}

class HotelsError extends HotelsState {
  final String message;
  HotelsError(this.message);
}

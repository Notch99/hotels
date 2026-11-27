import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/hotel.dart';

part 'hotels_state.dart';

class HotelsCubit extends Cubit<HotelsState> {
  HotelsCubit() : super(HotelsInitial());

  List<Hotel> allHotels = [];

  Future<void> loadHotels() async {
    emit(HotelsLoading());

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('hotels').get();

      allHotels = snapshot.docs
          .map((doc) => Hotel.fromMap(doc.data()))
          .toList();

      if (isClosed) return;
      emit(HotelsLoaded(allHotels));
    } catch (e) {
      if (isClosed) return;
      emit(HotelsError(e.toString()));
    }
  }

  void searchHotels(String query) {
    final filtered = allHotels.where((hotel) {
      return hotel.name.toLowerCase().contains(query.toLowerCase()) ||
          hotel.address.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(HotelsLoaded(filtered));
  }
}

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
      var snapshot =
          await FirebaseFirestore.instance.collection('hotels').get();

      if (snapshot.docs.isEmpty) {
        await addDefaultHotels();
        snapshot =
            await FirebaseFirestore.instance.collection('hotels').get();
      }

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

  Future<void> addDefaultHotels() async {
    final hotels = [
      {
        'name': 'Four Seasons Nile Plaza',
        'address': '1089 Corniche El Nil, Garden City, Cairo',
        'price': 350,
        'services': ['Free WiFi', 'Swimming Pool', 'Spa', 'Breakfast', 'Gym'],
        'image':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      },
      {
        'name': 'Marriott Mena House',
        'address': '6 Pyramids Road, Giza',
        'price': 280,
        'services': ['Free WiFi', 'Pyramids View', 'Pool', 'Restaurant'],
        'image':
            'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800',
      },
      {
        'name': 'Rixos Premium Seagate',
        'address': 'Nabq Bay, Sharm El Sheikh',
        'price': 320,
        'services': ['Private Beach', 'Aqua Park', 'All Inclusive', 'Free WiFi'],
        'image':
            'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
      },
      {
        'name': 'Steigenberger Aldau Beach',
        'address': 'Youssef Afifi Road, Hurghada',
        'price': 240,
        'services': ['Beach Access', 'Golf', 'Spa', 'Free WiFi', 'Pool'],
        'image':
            'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
      },
      {
        'name': 'Hilton Alexandria Corniche',
        'address': '544 El Geish Road, Sidi Bishr, Alexandria',
        'price': 190,
        'services': ['Sea View', 'Rooftop Pool', 'Free WiFi', 'Parking'],
        'image':
            'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
      },
    ];

    for (int i = 0; i < hotels.length; i++) {
      await FirebaseFirestore.instance
          .collection('hotels')
          .doc('hotel_${i + 1}')
          .set(hotels[i]);
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

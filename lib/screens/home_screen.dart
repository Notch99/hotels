import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/auth/auth_cubit.dart';
import '../cubits/hotels/hotels_cubit.dart';
import 'hotel_details_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HotelsCubit()..loadHotels(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Available Hotels'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthCubit>().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (value) {
                      context.read<HotelsCubit>().searchHotels(value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search hotels...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<HotelsCubit, HotelsState>(
                    builder: (context, state) {
                      if (state is HotelsLoading || state is HotelsInitial) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is HotelsError) {
                        return Center(child: Text(state.message));
                      }

                      if (state is HotelsLoaded) {
                        if (state.hotels.isEmpty) {
                          return const Center(child: Text('No hotels found'));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.hotels.length,
                          itemBuilder: (context, index) {
                            final hotel = state.hotels[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: hotel.image.isNotEmpty
                                    ? Image.network(
                                        hotel.image,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) =>
                                            const Icon(Icons.hotel, size: 40),
                                      )
                                    : const Icon(Icons.hotel, size: 40),
                                title: Text(
                                  hotel.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(hotel.address),
                                trailing: Text(
                                  '\$${hotel.price.toInt()}/night',
                                  style: const TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HotelDetailsScreen(hotel: hotel),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

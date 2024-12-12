import 'package:mocktail/mocktail.dart';
import 'package:santap_mantap_app/di/injection.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_entity.dart';
import 'package:santap_mantap_app/domain/repositories/restaurant_repository.dart';
import 'package:santap_mantap_app/presentation/module/home/home_provider.dart';
import 'package:santap_mantap_app/utils/ui_loading_dummy_data.dart';
import 'package:santap_mantap_app/utils/ui_state.dart';
import 'package:test/test.dart';

import 'dummy_data.dart';

class MockRestaurantRepository extends Mock implements RestaurantRepository {}

void main() {
  late HomeProvider provider;
  late MockRestaurantRepository repository;

  final List<RestaurantEntity> fakeRestaurantList = DummyData.restaurantList;

  const int totalTopRestaurants = 3;

  setUp(() {
    repository = MockRestaurantRepository();
    provider = HomeProvider(repository: repository);
  });

  group('HomeProvider getRestaurants', () {
    test('should have InitialState as the default state', () {
      // Assert
      expect(provider.state, isA<InitialState>());
    });

    test(
        'should update state to success and set topRestaurants and restaurants',
        () async {
      // Arrange
      when(() => repository.getRestaurants())
          .thenAnswer((_) async => fakeRestaurantList);

      // Act
      await provider.getRestaurants();

      // Assert
      expect(provider.state, isA<SuccessState>());
      expect(provider.topRestaurants.length, totalTopRestaurants);
      expect(provider.restaurants.length, 2);
    });

    test('should update state to error and restaurants to empty list',
        () async {
      // Arrange
      when(() => repository.getRestaurants())
          .thenAnswer((_) async => Future.error("error"));

      // Act
      await provider.getRestaurants();

      // Assert
      expect(provider.state, isA<ErrorState>());
      expect(provider.topRestaurants.length, 0);
      expect(provider.restaurants.length, 0);
    });
  });
}

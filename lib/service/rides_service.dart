import 'package:my_app/model/ride_pref/ride_pref.dart';
import 'package:my_app/repository/ride_repository.dart';
import '../model/ride/ride.dart';

enum RideSortType {
  departureTime,
  price,
}
class RidesFilter {
  final bool petAccepted;
  RidesFilter({this.petAccepted = false});
}
class RidesService {
  static final RidesService _instance = RidesService._internal();
  RidesRepository? _repository;
  RidesService._internal();
  factory RidesService() {
    return _instance;
  }
  void initialize(RidesRepository repository) {
    _repository = repository;
  }
  List<Ride> getRides(RidePref preference, RidesFilter? filter,{RideSortType? sortType}) 
  {
    if (_repository == null) {
      throw Exception('RidesService not initialized with repository yet !!!');
    }
    List<Ride> rides = _repository!.getRides(preference, filter);
    if (sortType != null) {
      switch (sortType) {
        case RideSortType.departureTime:
          rides.sort((a, b) => a.departureDate.compareTo(b.departureDate));
          break;
        case RideSortType.price:
          rides.sort((a, b) => a.pricePerSeat.compareTo(b.pricePerSeat));
          break;
      }
    }
    return rides;
  }
}
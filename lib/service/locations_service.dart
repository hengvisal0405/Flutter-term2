import 'package:my_app/model/ride/locations.dart';
import '../repository/location_repository.dart';

class LocationsService {
  static final LocationsService _instance = LocationsService._internal();
  LocationsRepository? _repository;

  List<Location>? _availableLocations;

  LocationsService._internal();

  factory LocationsService() {
    return _instance;
  }

  void initialize(LocationsRepository repository) {
    _repository = repository;
    
    _availableLocations = null;
  }

  List<Location> getLocations() {
    _availableLocations ??= _repository!.getLocations();
    return _availableLocations!;
  }
}

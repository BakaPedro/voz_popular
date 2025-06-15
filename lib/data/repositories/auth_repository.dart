import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

import 'package:voz_popular/data/models/user_model.dart';
import 'package:voz_popular/data/models/occurrence_model.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<User> register({required String name, required String email, required String password});
  Future<void> logout();
}

abstract class OccurrenceRepository {
    Future<List<Occurrence>> getOccurrences();
    Future<void> submitOccurrence({
        required String title,
        required String description,
        required String address,
        required String category,
        File? mobileImageFile,
        Uint8List? webImageBytes,
        required Position position,
    });
}


    

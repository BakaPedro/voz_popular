import 'dart:io';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:voz_popular/data/models/comment_model.dart';
import 'package:voz_popular/data/models/user_model.dart';
import 'package:voz_popular/data/models/occurrence_model.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<User> register({required String name, required String email, required String password});
  Future<void> logout();
}

abstract class OccurrenceRepository {
    Future<List<Occurrence>> getOccurrences({OccurrenceStatus? status});
    Future<List<Occurrence>> getMyOccurrences();
    Future<Occurrence> getOccurrenceDetails(String id);
    Future<List<Comment>> getComments(String occurrenceId);
    Future<void> submitOccurrence({
        required String description,
        required String street,
        required String number,
        required String neighborhood,
        required String reference,
        required String categoryId,
        required String themeId,
        File? mobileImageFile,
        Uint8List? webImageBytes,
        required LatLng position,
    });
}


    

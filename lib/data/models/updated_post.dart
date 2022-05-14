import 'package:dio/dio.dart';
import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

Future<Map<String, dynamic>> multiPartUpdatedPost(
    Map<String, dynamic> data) async {
  String? mimeType = mimeFromExtension('webp');
  String mimee = mimeType!.split('/')[0];
  String type = mimeType.split('/')[1];
  Map<String, dynamic> payload = {};
  payload['EventTime'] = data['EventTime'];
  payload['EndTime'] = data['EndTime'];
  payload['UserLocation.Longitude'] = data['Longitude'];
  payload['UserLocation.Latitude'] = data['Latitude'];
  payload['RemainingImagesGuids'] = data['RemainingImagesGuids'];
  if (data.containsKey('Description'))
    payload['UpdatedEvent.Description'] = data['Description'];
  if (data.containsKey('Title')) payload['UpdatedEvent.Title'] = data['Title'];
  if (data.containsKey('EntrancePrice'))
    payload['UpdatedEvent.EntrancePrice'] = data['EntrancePrice'];
  if (data.containsKey('Currency'))
    payload['UpdatedEvent.Currency'] = data['Currency'];
  if (data.containsKey('Requirements'))
    payload['UpdatedEvent.Requirements'] = data['Requirements'];
  if (data.containsKey('Slots')) payload['UpdatedEvent.Slots'] = data['Slots'];
  if (data.containsKey('Address'))
    payload['UserLocation.Address'] = data['Address'];
  if (data.containsKey('City')) payload['UserLocation.City'] = data['City'];
  if (data.containsKey('Region'))
    payload['UserLocation.Region'] = data['Region'];
  if (data.containsKey('EntityName'))
    payload['UserLocation.EntityName'] = data['EntityName'];
  if (data.containsKey('Country'))
    payload['UserLocation.Country'] = data['Country'];
  if (data.containsKey('Tags')) payload['TagNames'] = data['Tags'];
  if (data.containsKey('Picture1'))
    payload['Picture1'] = await MultipartFile.fromFile(
        File(data['Picture1']).absolute.path,
        filename: '0.webp',
        contentType: MediaType(mimee, type));
  if (data.containsKey('Picture2'))
    payload['Picture2'] = await MultipartFile.fromFile(
        File(data['Picture2']).absolute.path,
        filename: '1.webp',
        contentType: MediaType(mimee, type));
  if (data.containsKey('Picture3'))
    payload['Picture3'] = await MultipartFile.fromFile(
        File(data['Picture3']).absolute.path,
        filename: '2.webp',
        contentType: MediaType(mimee, type));
  return payload;
}

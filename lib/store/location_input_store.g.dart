// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_input_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocationInputStore on LocationStore, Store {
  late final _$pickedLocationAtom =
      Atom(name: 'LocationStore.pickedLocation', context: context);

  @override
  PlaceLocation? get pickedLocation {
    _$pickedLocationAtom.reportRead();
    return super.pickedLocation;
  }

  @override
  set pickedLocation(PlaceLocation? value) {
    _$pickedLocationAtom.reportWrite(value, super.pickedLocation, () {
      super.pickedLocation = value;
    });
  }

  late final _$isGettingLocationAtom =
      Atom(name: 'LocationStore.isGettingLocation', context: context);

  @override
  bool get isGettingLocation {
    _$isGettingLocationAtom.reportRead();
    return super.isGettingLocation;
  }

  @override
  set isGettingLocation(bool value) {
    _$isGettingLocationAtom.reportWrite(value, super.isGettingLocation, () {
      super.isGettingLocation = value;
    });
  }

  late final _$addressAtom =
      Atom(name: 'LocationStore.address', context: context);

  @override
  String? get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(String? value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$getCurrentLocationAsyncAction =
      AsyncAction('LocationStore.getCurrentLocation', context: context);

  @override
  Future<void> getCurrentLocation() {
    return _$getCurrentLocationAsyncAction
        .run(() => super.getCurrentLocation());
  }

  late final _$selectOnMapAsyncAction =
      AsyncAction('LocationStore.selectOnMap', context: context);

  @override
  Future<void> selectOnMap(LatLng selectedCoordinates) {
    return _$selectOnMapAsyncAction
        .run(() => super.selectOnMap(selectedCoordinates));
  }

  @override
  String toString() {
    return '''
pickedLocation: ${pickedLocation},
isGettingLocation: ${isGettingLocation},
address: ${address}
    ''';
  }
}

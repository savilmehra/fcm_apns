import 'package:clean_framework/clean_framework_providers.dart';

import 'package:flutter/material.dart';

import '../../../providers.dart';
import '../domain/country_use_case.dart';
import '../domain/country_view_model.dart';

class CountryPresenter extends Presenter<CountryViewModel, CountryUIOutput, CountryUseCase> {
  CountryPresenter({required PresenterBuilder<CountryViewModel> builder})
      : super(
          builder: builder,
          provider: countryUseCaseProvider,
        );

  @override
  void onLayoutReady(BuildContext context, CountryUseCase useCase) {
    useCase.fetchCountries();
  }

  @override
  CountryViewModel createViewModel(
    CountryUseCase useCase,
    CountryUIOutput output,
  ) {
    return CountryViewModel(
      isLoading: output.isLoading,
      countries: output.countries
          .map(
            (c) => SingleCountryViewModel(
              name: c.name,
              emoji: c.emoji,
              capital: c.capital,
            ),
          )
          .toList(growable: false),
      continents: output.continents,
      selectedContinentId: output.selectedContinentId,
      fetchCountries: useCase.fetchCountries,
    );
  }

  @override
  void onOutputUpdate(BuildContext context, CountryUIOutput output) {
    if (output.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(output.errorMessage)),
      );
    }
  }
}

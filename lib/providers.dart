import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart'
    hide FeatureState;
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:flutter/cupertino.dart';

import 'features/country/domain/country_entity.dart';
import 'features/country/domain/country_use_case.dart';
import 'features/country/external_interface/country_gateway.dart';


ProvidersContext _providersContext = ProvidersContext();

ProvidersContext get providersContext => _providersContext;

@visibleForTesting
void resetProvidersContext([ProvidersContext? context]) {
  _providersContext = context ?? ProvidersContext();
}
final countryUseCaseProvider = UseCaseProvider<CountryEntity, CountryUseCase>(
  (_) => CountryUseCase(),
);

final countryGatewayProvider = GatewayProvider<CountryGateway>(
  (_) => CountryGateway(),
);


final graphQLExternalInterface = ExternalInterfaceProvider(
  (_) => GraphQLExternalInterface(
    link: 'https://countries.trevorblades.com',
    gatewayConnections: [
      () => countryGatewayProvider.getGateway(providersContext),
    ],
  ),
);


void loadProviders() {

  graphQLExternalInterface.getExternalInterface(providersContext);

}

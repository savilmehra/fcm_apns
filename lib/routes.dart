import 'package:clean_framework/clean_framework.dart';

import 'package:flutter/material.dart';

import 'features/country/presentation/country_ui.dart';
import 'main.dart';

enum Routes {
  home,
  lastLogin,
  countries,
  countryDetail,
  randomCat,
}

final router = AppRouter<Routes>(
  routes: [
    AppRoute(
      name: Routes.home,
      path: '/',
      builder: (context, state) => const MyHomePage(title: 'test',),
      routes: [

        AppRoute(
          name: Routes.countries,
          path: 'countries',
          builder: (context, state) => CountryUI(),
          routes: [
            AppRoute(
              name: Routes.countryDetail,
              path: ':country',
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(state.getParam('country')),
                  ),
                  body: Center(
                    child: Text(state.queryParams['capital'].toString()),
                  ),
                );
              },
            ),
          ],
        ),

      ],
    ),
  ],
  errorBuilder: (context, state) => Page404(error: state.error),
);

class Page404 extends StatelessWidget {
  const Page404({Key? key, required this.error}) : super(key: key);

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(error.toString()),
      ),
    );
  }
}

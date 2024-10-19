import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onlinestore/controllers/home/home_cubit.dart';
import 'package:onlinestore/views/widgets/home/home_build.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
          current is HomeSuccess || current is HomeLoading || current is HomeFailed,
          builder: (context, state) {
            if (state is HomeLoading) {
              return buildLoadingIndicator();
            } else if (state is HomeFailed) {
              return buildErrorMessage(state.error);
            } else if (state is HomeSuccess) {
              return buildHomeContent(context, state.salesProducts, state.newProducts);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),

    );
  }
}
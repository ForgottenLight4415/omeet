import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/buttons.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../utilities/app_constants.dart';
import '../../blocs/home_bloc/get_claims_cubit.dart';

class HospitalClaimsView extends StatelessWidget {
  final String hospitalId;
  final GetClaimsCubit _claimsCubit = GetClaimsCubit();

  HospitalClaimsView({Key? key, required this.hospitalId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Claims'),
      ),
      body: BlocProvider<GetClaimsCubit>(
        create: (context) => _claimsCubit
          ..getHospitalClaims(context, hospitalId),
        child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
          builder: (context, state) {
            if (state is GetHospitalClaimsSuccess) {
              if (state.claims.isEmpty) {
                return const InformationWidget(
                  svgImage: AppStrings.noDataImage,
                  label: AppStrings.noClaims,
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<GetClaimsCubit>(context).getClaims(context);
                },
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 8.w, top: 8.h, right: 8.w),
                  itemCount: state.claims.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      title: Center(
                        child: Text(
                          state.claims[index].claimId,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  )
                ),
              );
            } else if (state is GetClaimsFailed) {
              return CustomErrorWidget(
                errorText: state.cause + "\n(Error code: ${state.code})",
                action: () {
                  BlocProvider.of<GetClaimsCubit>(context).getClaims(context);
                },
              );
            } else {
              return const LoadingWidget(label: AppStrings.claimsLoading);
            }
          },
        ),
      ),
    );
  }
}

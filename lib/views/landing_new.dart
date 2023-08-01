import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omeet_motor/blocs/home_bloc/get_claims_cubit.dart';
import 'package:omeet_motor/data/providers/claim_provider.dart';

import '../blocs/call_bloc/call_cubit.dart';
import '../utilities/bridge_call.dart';
import '../views/claims/claims_view.dart';
import '../data/repositories/auth_repo.dart';
import '../utilities/app_constants.dart';
import '../widgets/omeet_drawer_header.dart';
import '../widgets/snack_bar.dart';

class ModernLandingPage extends StatefulWidget {
  final String email;
  final String phone;

  const ModernLandingPage({Key? key, required this.email, required this.phone})
      : super(key: key);

  @override
  State<ModernLandingPage> createState() => _ModernLandingPageState();
}

class _ModernLandingPageState extends State<ModernLandingPage> {
  late final GetClaimsCubit _allClaims;
  late final GetClaimsCubit _acceptedClaims;
  late final GetClaimsCubit _rejectedClaims;
  late final GetClaimsCubit _overallClaims;
  late final GetClaimsCubit _concludedClaims;

  int _noAllClaims = 0;
  int _noOverallClaims = 0;
  int _noAcceptedClaims = 0;
  int _noRejectedClaims = 0;
  int _noConcludedClaims = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _allClaims = GetClaimsCubit();
    _overallClaims = GetClaimsCubit();
    _acceptedClaims = GetClaimsCubit();
    _rejectedClaims = GetClaimsCubit();
    _concludedClaims = GetClaimsCubit();
  }

  @override
  void dispose() {
    _allClaims.close();
    _overallClaims.close();
    _acceptedClaims.close();
    _rejectedClaims.close();
    _concludedClaims.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Cases'),
          leading: IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.black),
            ),
            tabs: [
              BlocProvider<GetClaimsCubit>(
                create: (context) => _acceptedClaims
                  ..getClaims(context, claimType: ClaimType.accepted),
                child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                  builder: (context, state) {
                    if (state is GetClaimsSuccess) {
                      _noAcceptedClaims = state.claims.length;
                    }
                    return Tab(text: "Accepted $_noAcceptedClaims");
                  },
                ),
              ),
              BlocProvider<GetClaimsCubit>(
                create: (context) => _allClaims
                  ..getClaims(context, claimType: ClaimType.allocated),
                child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                  builder: (context, state) {
                    if (state is GetClaimsSuccess) {
                      _noAllClaims = state.claims.length;
                    }
                    return Tab(text: "Allocated $_noAllClaims");
                  },
                ),
              ),
              BlocProvider<GetClaimsCubit>(
                create: (context) => _overallClaims
                  ..getClaims(context, claimType: ClaimType.overall),
                child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                  builder: (context, state) {
                    if (state is GetClaimsSuccess) {
                      _noOverallClaims = state.claims.length;
                    }
                    return Tab(text: "Overall $_noOverallClaims");
                  },
                ),
              ),
              BlocProvider<GetClaimsCubit>(
                create: (context) => _rejectedClaims
                  ..getClaims(context, claimType: ClaimType.rejected),
                child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                  builder: (context, state) {
                    if (state is GetClaimsSuccess) {
                      _noRejectedClaims = state.claims.length;
                    }
                    return Tab(text: "Rejected $_noRejectedClaims");
                  },
                ),
              ),
              BlocProvider<GetClaimsCubit>(
                create: (context) => _concludedClaims
                  ..getClaims(context, claimType: ClaimType.concluded),
                child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                  builder: (context, state) {
                    if (state is GetClaimsSuccess) {
                      _noConcludedClaims = state.claims.length;
                    }
                    return Tab(text: "Concluded $_noConcludedClaims");
                  },
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              OMeetUserDrawerHeader(email: widget.email, phone: widget.phone),
              BlocProvider<CallCubit>(
                create: (context) => CallCubit(),
                child: BlocConsumer<CallCubit, CallState>(
                  listener: _callListener,
                  builder: (context, state) => ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.phone,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text(
                      AppStrings.customCall,
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () async {
                      _scaffoldKey.currentState?.closeDrawer();
                      await customCallSetup(context);
                    },
                  ),
                ),
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.arrowUp,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text(
                  AppStrings.uploads,
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  _scaffoldKey.currentState?.closeDrawer();
                  Navigator.pushNamed(context, '/uploads');
                },
              ),
              Expanded(child: Container()),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text(
                  AppStrings.signOut,
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () async {
                  await AuthRepository().signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 5),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  AppStrings.appVersion,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black45),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ClaimsView(cubit: _acceptedClaims, claimType: ClaimType.accepted),
            ClaimsView(cubit: _allClaims, claimType: ClaimType.allocated),
            ClaimsView(cubit: _overallClaims, claimType: ClaimType.overall),
            ClaimsView(cubit: _rejectedClaims, claimType: ClaimType.rejected),
            ClaimsView(cubit: _concludedClaims, claimType: ClaimType.concluded),
          ],
        ),
      ),
    );
  }

  void _callListener(BuildContext context, CallState state) {
    if (state is CallLoading) {
      showSnackBar(context, AppStrings.connecting);
    } else if (state is CallReady) {
      showSnackBar(context, AppStrings.receiveCall, type: SnackBarType.success);
    } else if (state is CallFailed) {
      showSnackBar(context, state.cause, type: SnackBarType.error);
    }
  }
}

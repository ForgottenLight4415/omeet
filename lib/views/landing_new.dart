import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omeet_motor/blocs/home_bloc/get_claims_cubit.dart';

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

  int _noAllClaims = 0;
  int _noAcceptedClaims = 0;
  int _noRejectedClaims = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _allClaims = GetClaimsCubit();
    _acceptedClaims = GetClaimsCubit();
    _rejectedClaims = GetClaimsCubit();
  }

  @override
  void dispose() {
    _allClaims.close();
    _acceptedClaims.close();
    _rejectedClaims.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
            labelColor: Colors.black,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.black),
            ),
            tabs: [
              BlocProvider<GetClaimsCubit>(
                create: (context) => _allClaims
                  ..getClaims(context, forSelfAssignment: true),
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
                create: (context) => _acceptedClaims
                  ..getClaims(context, forSelfAssignment: false),
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
                create: (context) => _rejectedClaims
                  ..getClaims(context, forSelfAssignment: false, rejected: true),
                child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                  builder: (context, state) {
                    if (state is GetClaimsSuccess) {
                      _noRejectedClaims = state.claims.length;
                    }
                    return Tab(text: "Rejected $_noRejectedClaims");
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
            ClaimsView(cubit: _allClaims, forSelfAssignment: true),
            ClaimsView(cubit: _acceptedClaims, forSelfAssignment: false),
            ClaimsView(
                cubit: _rejectedClaims,
                forSelfAssignment: false,
                rejected: true,
            ),
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

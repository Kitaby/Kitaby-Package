import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kitaby/Animations/EmailVerif.dart';
import 'package:kitaby/Animations/ForgotPassword.dart';
import 'package:kitaby/Animations/PasswordChanged.dart';
import 'package:kitaby/Animations/SplashScreen.dart';
import 'package:kitaby/App%20Intro/Intro1.dart';
import 'package:kitaby/App%20Intro/Intro2.dart';
import 'package:kitaby/App%20Intro/Intro3.dart';
import 'package:kitaby/Authentification/Forgotyourpassword/forgotyourpassword.dart';
import 'package:kitaby/Authentification/Forgotyourpassword/forgotyourpassword2.dart';
import 'package:kitaby/Authentification/SignUp/SignUp2.dart';
import 'package:kitaby/Authentification/SignUp/Signup1.dart';
import 'package:kitaby/Authentification/SignUp/signup3.dart';
import 'package:kitaby/Authentification/login.dart';
import 'package:kitaby/Exchange/ChatApp/Chat.dart';
import 'package:kitaby/Home.dart';
import 'package:kitaby/Exchange/ChatApp/UserMessages.dart';
import 'package:kitaby/Exchange/ExchangeNotif.dart';
import 'package:kitaby/Recommendation/RecommendationHome.dart';
import 'package:kitaby/Recommendation/UserBook.dart';
import 'package:kitaby/Exchange/User-Exchange.dart';
import 'package:kitaby/Reservation/LoanNotif.dart';
import 'package:kitaby/Reservation/LoanTimeLine.dart';
import 'package:kitaby/Reservation/User-Reservation.dart';
import 'package:kitaby/profile/Edit_profile.dart';
import 'package:kitaby/profile/Profile.dart';
import 'Community/Home.dart';
import 'Community/comments.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
      },
      child: const Signup2(
        name: '',
        phone: '',
      ),
    );
  }
}

final GoRouter router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
      name: "SplashScreen",
      path: "/",
      builder: (context, state) => const SplashScreen(), //splashscreen
      routes: [
        GoRoute(
          name: 'Intro1',
          path: 'Intro1',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const Intro1(),
          ),
        ),
        GoRoute(
          name: 'Intro2',
          path: 'Intro2',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const Intro2(),
          ),
        ),
        GoRoute(
          name: 'Intro3',
          path: 'Intro3',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const Intro3(),
          ),
        ),
        GoRoute(
          name: 'Login',
          path: 'Login',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const Login(),
          ),
        ),
        GoRoute(
          name: 'ForgetPassword1',
          path: 'ForgetPassword1/:oldmail',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: Forgotyourpassword(
              oldmail: state.pathParameters['oldmail'],
            ),
          ),
        ),
        GoRoute(
          name: 'ForgetPasswordAnime',
          path: 'ForgetPasswordAnime/:email',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: ForgotPasswordAnime(
              email: state.pathParameters['email'],
            ),
          ),
        ),
        GoRoute(
          name: 'ForgetPassword2',
          path: 'ForgetPassword2/:email',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: Forgotyourpassword2(
              email: state.pathParameters['email'],
            ),
          ),
        ),
        GoRoute(
          name: 'PasswordChanged',
          path: 'PasswordChanged',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const PasswordChanged(),
          ),
        ),
        GoRoute(
          name: 'Signup1',
          path: 'Signup1',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const Signup1(),
          ),
        ),
        GoRoute(
          name: 'Signup2',
          path: 'Signup2/:name/:phone',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: Signup2(
              name: state.pathParameters['name'],
              phone: state.pathParameters['phone'],
            ),
          ),
        ),
        GoRoute(
          name: 'Signup3',
          path: 'Signup3/:name/:phone/:email/:password',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: Signup3(
              name: state.pathParameters['name'],
              phone: state.pathParameters['phone'],
              email: state.pathParameters['email'],
              password: state.pathParameters['password'],
            ),
          ),
        ),
        GoRoute(
          name: 'EmailVerif',
          path: 'EmailVerif',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const EmailVerif(),
          ),
        ),
        GoRoute(
          name: "Home",
          path: "Home/:token/:index",
          pageBuilder: (contextHome, stateHome) => NoTransitionPage<void>(
            key: stateHome.pageKey,
            child: Home(
              index: int.parse(stateHome.pathParameters['index']!),
              token: stateHome.pathParameters['token'],
            ),
          ),
        ),
        GoRoute(
            name: "Recommendations",
            path: "Recommendations",
            pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const RecommendationHome(),
                ),
            routes: [
              GoRoute(
                name: "UserBook",
                path: 'UserBook/:isbn',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: UserBook(
                    id: state.pathParameters['isbn'],
                  ),
                ),
              )
            ]),
        GoRoute(
          path: "Loan",
          builder: (contextC, stateC) => const userreservation(),
          routes: [
            GoRoute(
              name: "Loantimeline",
              path: "Loantimeline",
              pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const LoanTimeLine(),
              ),
            ),
            GoRoute(
              name: "LoanNotif",
              path: 'Loannotif',
              pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const LoanNotif(),
              ),
            )
          ],
        ),
        GoRoute(
          path: "Exchange",
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const userexchange(),
          ),
          routes: [
            GoRoute(
              name: "ExchangeNotif",
              path: "ExchangeNotif",
              pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const ExchangeNotif(),
              ),
            ),
            GoRoute(
                name: "ExchangeMessages",
                path: 'ExchangeMessages',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                      key: state.pageKey,
                      child: const UserMessages(),
                    ),
                routes: [
                  GoRoute(
                    name: "Chat",
                    path: 'Chat/:id/:name/:image/:member1/:member2/:token',
                    pageBuilder: (context, state) => NoTransitionPage<void>(
                      key: state.pageKey,
                      child: Chat(
                        id: state.pathParameters['id'],
                        name: state.pathParameters['name'],
                        image: state.pathParameters['image'],
                        member1: state.pathParameters['member1'],
                        member2: state.pathParameters['member2'],
                        token: state.pathParameters['token'],
                      ),
                    ),
                  )
                ]),
          ],
        ),
        GoRoute(
            name: 'Community',
            path: 'Community',
            pageBuilder: (contextCHome, stateCHome) => NoTransitionPage<void>(
                  key: stateCHome.pageKey,
                  child: const HomeCommunity(),
                ),
            routes: [
              GoRoute(
                name: "PostPage",
                path: 'PostPage/:id',
                pageBuilder: (contextPostPage, statePostPage) =>
                    NoTransitionPage<void>(
                  key: statePostPage.pageKey,
                  child: CommentCommunity(
                    id: statePostPage.pathParameters['id'],
                  ),
                ),
              )
            ]),
        GoRoute(
            name: "Profile",
            path: 'Profile',
            pageBuilder: (contextPostPage, statePostPage) =>
                NoTransitionPage<void>(
                    key: statePostPage.pageKey, child: const Profile()),
            routes: [
              GoRoute(
                name: "EditProfile",
                path: 'EditProfile/:image/:wilaya',
                pageBuilder: (contextPostPage, statePostPage) =>
                    NoTransitionPage<void>(
                  key: statePostPage.pageKey,
                  child: Editprofile(
                    image: statePostPage.pathParameters['image'],
                    wilaya: statePostPage.pathParameters['wilaya'],
                  ),
                ),
              ),
            ])
      ])
]);

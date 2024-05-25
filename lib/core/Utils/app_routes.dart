import 'package:flutter/material.dart';
import '../../features/Badges/views/badges_center.dart';
import '../../features/agencies/views/agency_agent_view.dart';
import '../../features/agencies/views/agency_creation_view.dart';
import '../../features/agencies/views/agency_host_view.dart';
import '../../features/agencies/views/agency_join_view.dart';
import '../../features/auth/choice between registration and login/views/choice_between_registration_and_login_view.dart';
import '../../features/auth/choice between registration and login/views/privacy_terms_view.dart';
import '../../features/auth/choice between registration and login/views/user_agreement_view.dart';
import '../../features/auth/login/views/login_view.dart';
import '../../features/auth/login/views/password_recovery.dart';
import '../../features/auth/sinup/view/signup_view.dart';
import '../../features/chat/group/view/create_family_view.dart';
import '../../features/chat/group/view/family_view.dart';
import '../../features/chat/one_to_one/view/chat_view.dart';
import '../../features/chat/widget/group/family_rank_list/search_family.dart';
import '../../features/chat/widget/group/family_rank_list/view_all_family_body.dart';
import '../../features/chat/widget/group/myfamily/my_family_body.dart';
import '../../features/chat/widget/one_to_one/chat_setting.dart';
import '../../features/friend_list/view/friend_list_view.dart';
import '../../features/friend_list/view/visitor_view.dart';
import '../../features/friend_list/widget/friend_requset.dart';
import '../../features/games/views/games_view.dart';
import '../../features/hayaa_team/view/hayaa_team_view.dart';
import '../../features/history_recharge/view/history_recharge_view.dart';
import '../../features/home/views/all_rooms_view.dart';
import '../../features/home/views/home_view.dart';
import '../../features/home/views/main_rank_list_view.dart';
import '../../features/messages/views/messages_view.dart';
import '../../features/messages/widgets/invite_body.dart';
import '../../features/mylook/view/my_look_view.dart';
import '../../features/post/view/create_post_view.dart';
import '../../features/profile/views/profile_edit_view.dart';
import '../../features/recharge_coins/views/recharge_view.dart';
import '../../features/rooms/view/create_room_view.dart';
import '../../features/salery/view/salery_view.dart';
import '../../features/search/view/search_view.dart';
import '../../features/setting/views/setting_view.dart';
import '../../features/splash/views/splash_view.dart';
import '../../features/store/view/store_view.dart';
import '../../features/user_leve/view/user_level_view.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {
  SplashView.id: (context) => const SplashView(),
  ChoiceBetweenRegistrationAndLogin.id: (context) =>
      const ChoiceBetweenRegistrationAndLogin(),
  UserAgreementView.id: (context) => const UserAgreementView(),
  PrivacyTermsView.id: (context) => const PrivacyTermsView(),
  LoginView.id: (context) => const LoginView(),
  PasswordRecoveryView.id: (context) => const PasswordRecoveryView(),
  RechargeView.id: (context) => const RechargeView(),
  HistoryRechargeView.id: (context) => const HistoryRechargeView(),
  ChatView.id: (context) => const ChatView(),
  ChatSetting.id: (context) => ChatSetting(),
  FriendListView.id: (context) => const FriendListView(),
  HomeView.id: (context) => const HomeView(),
  MessagesView.id: (context) => const MessagesView(),
  GamesView.id: (context) => const GamesView(),
  AllRoomsView.id: (context) => const AllRoomsView(),
  FamilyView.id: (context) => const FamilyView(),
  VisitorView.id: (context) => const VisitorView(),
  ProfileEditView.id: (context) => const ProfileEditView(
        fans: "0",
      ),
  MainRankListView.id: (context) => const MainRankListView(),
  SaleryView.id: (context) => const SaleryView(),
  SignupView.id: (context) => const SignupView(),
  SettingView.id: (context) => SettingView(),
  SearchView.id: (context) => SearchView(),
  FriendReuest.id: (context) => FriendReuest(),
  UserLevelView.id: (context) => const UserLevelView(),
  StoreView.id: (context) => const StoreView(),
  MyLookView.id: (context) => const MyLookView(),
  CreateFamilyView.id: (context) => const CreateFamilyView(),
  AgencyJoiningView.id: (context) => const AgencyJoiningView(),
  AgencyCreationView.id: (context) => const AgencyCreationView(),
  AgencyAgentView.id: (context) => const AgencyAgentView(),
  AgencyHostView.id: (context) => const AgencyHostView(),
  MyFamilyBody.id: (context) => const MyFamilyBody(),
  HayaaTeamView.id: (context) => HayaaTeamView(),
  InviteBody.id: (context) => InviteBody(),
  ViewAllFamilyBody.id: (context) => ViewAllFamilyBody(),
  BadgesCenterView.id: (context) => const BadgesCenterView(),
  SearchFamily.id: (context) => SearchFamily(),
  CreatePostView.id: (contex) => CreatePostView(),
  CreateRoomView.id: (contex) => const CreateRoomView(),
};

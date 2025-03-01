part of "auth_state.dart";

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _repo;

  AuthCubit({required AuthRepo repo})
      : _repo = repo,
        super(const AuthState());

  Future<void> signInWithGoogle() async {
    try {
      emit(state.copyWith(status: StateStatus.loading));
      await _repo.signInWithGoogle();
      emit(state.copyWith(status: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        error: CommonError(
            consoleMessage: 'Failed to sign in with Google: $e',
            message: "Something went wrong, Please try again later",
            code: "AUTH"),
      ));
    }
  }
}

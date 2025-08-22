part of '../_index.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final _key = GlobalKey<FormState>();

  bool rememberMe = false;
  bool loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> login() async {
    // Safer validation check
    if (_key.currentState?.validate() != true) {
      print("DEBUG: Validation failed");
      return;
    }

    if (!mounted) return;

    print("DEBUG: Setting loading to true");
    setState(() {
      loading = true;
    });

    try {
      print("DEBUG: Getting provider");
      final prov = ref.read(userProvider.notifier);

      // Set context before login to avoid null context error
      prov.setContext(context);

      print("DEBUG: Calling login with email: ${_email.text}");
      final res = await prov.login(_email.text, _password.text);

      print("DEBUG: Login response received: ${res?.success}");

      if (!mounted) {
        print("DEBUG: Widget not mounted after login");
        return;
      }

      // Add null check for res
      if (res == null) {
        print("DEBUG: Response is null");
        showToast(context, "Login failed - no response");
        return;
      }

      if (!res.success) {
        print("DEBUG: Login failed: ${res.error}");
        showToast(context, res.error ?? "Error");
      } else {
        print("DEBUG: Login successful, navigating to home");
        gotoHome();
      }
    } catch (e, stackTrace) {
      print("DEBUG: Exception caught: $e");
      print("DEBUG: Stack trace: $stackTrace");
      if (mounted) {
        showToast(context, "Unexpected error: $e");
      }
    } finally {
      print("DEBUG: Finally block - setting loading to false");
      if (mounted) {
        setState(() {
          loading = false;
        });
        print("DEBUG: Loading set to false successfully");
      } else {
        print("DEBUG: Widget not mounted in finally block");
      }
    }
  }

  void gotoHome() {
    Navigator.of(context)
        .pushReplacementNamed('/home'); // Navigate to HomeScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.appTheme(context).bg1,
        body: SafeArea(
          child: Form(
            key: _key,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Welcome Back",
                        style: CustomTextTheme.customTextTheme(context)
                            .textTheme
                            .displayMedium,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "Apply smarter, learn faster, grow stronger \n  Skill Sage.",
                        textAlign: TextAlign.center,
                        style: CustomTextTheme.customTextTheme(context)
                            .textTheme
                            .bodySmall,
                      ),
                    ),
                    const SizedBox(
                      height: 50, // Reduced from 90 to 50
                    ),
                    Text('Email',
                        style: CustomTextTheme.customTextTheme(context)
                            .textTheme
                            .displaySmall),
                    const SizedBox(height: 8.0), // Added SizedBox for spacing
                    CustomTextField(
                      hintText: 'Email',
                      controller: _email,
                      isEmail: true,
                    ),
                    const SizedBox(height: 16.0), // Added SizedBox for spacing
                    Text('Password',
                        style: CustomTextTheme.customTextTheme(context)
                            .textTheme
                            .displaySmall),
                    const SizedBox(height: 8.0), // Added SizedBox for spacing
                    CustomTextField(
                      hintText: 'Password',
                      controller: _password,
                      isPassword: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) => {
                                setState(() {
                                  rememberMe = value ?? false;
                                  // Removed the incorrect loading assignment
                                })
                              },
                              shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Text(
                              'Remember me',
                              style: CustomTextTheme.customTextTheme(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => {
                            // TODO: implement forgot password
                          },
                          child: Text(
                            'Forgot Password?',
                            style: CustomTextTheme.customTextTheme(context)
                                .textTheme
                                .bodySmall! // Changed to bodySmall for consistency
                                .copyWith(
                                    fontWeight: FontWeight.bold), // Made bold
                          ),
                        ),
                      ],
                    ),
                    CustomButton(
                      onPressed: login,
                      color: AppTheme.appTheme(context).secondary,
                      title: 'LOGIN',
                      isLoading: loading,
                    ),
                    const SizedBox(height: 16.0), // Added SizedBox for spacing
                    // CustomButton(
                    //   color: AppTheme.appTheme(context).accent,
                    //   title: 'SIGN IN WITH GOOGLE',
                    //   icon: SvgPicture.asset("assets/svgs/google.svg"),
                    // ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You don't have an account? ",
                          style: CustomTextTheme.customTextTheme(context)
                              .textTheme
                              .bodySmall,
                        ),
                        InkWell(
                          onTap: () {
                            if (!loading) {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.userRegister);
                            }
                          },
                          child: Text(
                            'Sign Up',
                            style: CustomTextTheme.customTextTheme(context)
                                .textTheme
                                .bodySmall! // Changed to bodySmall
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration
                                        .underline), // Made bold and underlined
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

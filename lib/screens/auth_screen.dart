import 'dart:math';

import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        // Matrix4 helps to adjust rotation and all of a container
                        ..translate(-10.0),
                      // .. means it edits things in rotationZ and returns the result of rotationZ not of translate,
                      // if we wouldve used . then it would return void cause transalte returns void, but transfrom takes
                      // Matrix4 , so using .. we are returning from rotationZ
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          fontFamily: 'Anton',
                          color: Theme.of(context).textTheme.headline1!.color,
                          fontSize: 50,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  // to use vsync in AnimationController()
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  late AnimationController _controller;

  late Animation<Size> _heightAnimation;
  // <Size> means I want to include size animation
  // wont be needed if used AnimatedContainer

  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  // wont be needed if used animatedContainer, but for widgets like FadeTransition and SlideTransition its needed
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _heightAnimation = Tween<Size>(
      begin: const Size(
        double.infinity,
        260,
      ),
      end: const Size(
        double.infinity,
        320,
      ),
      // tween takes the data and then animate actually return the Animation
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    /* _heightAnimation.addListener(() => setState(() {}));
    // just to rebuild the widget */
    //  dont need to call manually if using AnimationBuilder

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      // for using FadeTransition
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1.5), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    super.initState();
  }

  /* @override
  void dispose() {
    _controller.dispose();
    _heightAnimation.removeListener(() {});
    super.dispose();
  } */
  // not needed if using animationbuilder

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'An error ocurred!',
        ),
        content: Text(errorMessage),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Okay!'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).logIn(
          _authData['email'] as String,
          _authData['password'] as String,
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email'] as String,
          _authData['password'] as String,
        );
      }
    } on HttpException catch (error) {
      // on HttpException = to catch only that type of error
      var errorText = 'Could not verify';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorText = 'Email already exists';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorText = 'email is not found';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorText = 'Invalid password';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorText = 'password is too weak';
      }
      _showErrorDialog(errorText);
    } catch (error) {
      var errorMessage = 'Could not authenticate. Please try again later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(
        () {
          _authMode = AuthMode.Signup;
        },
      );
      _controller.forward();
      // starting the animation for FadeTransition
    } else {
      setState(
        () {
          _authMode = AuthMode.Login;
        },
      );
      _controller.reverse();
      // reverse the FadeTransition animation
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: /* AnimatedBuilder(
        // to rebuild only the needed portion to animate only the needed thing, here the container only 
        animation: _heightAnimation,
        builder: (ctx, ch) => Container(
          height: _heightAnimation.value.height,
          // included the animation
          constraints: BoxConstraints(
            minHeight: _heightAnimation.value.height,
          ),
          width: deviceSize.width * 0.75,
          padding: const EdgeInsets.all(16.0),
          child: ch,
          // ch wont be rebuild, ch = child: Form(..) just like consumer child
        ), */
          // There is also a inbuilt widget to manage these internally

          AnimatedContainer(
        // dont need to add anything else just the duration and curve widget, height and contraints are normally
        // defined but animatedContainer automatically animates that
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 320 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == '' || !value!.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value as String;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  // hidden text as password
                  controller: _passwordController,
                  validator: (value) {
                    if (value == '' || value!.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value as String;
                  },
                ),
                /* if (_authMode == AuthMode.Signup) */
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                  ),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    // for adding fade transition
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      // this effect make it looks like the textfield is coming down and going in the above text field
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        // only enabled when AuthMode.Signup
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.headline1!.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} '),
                  onPressed: _switchAuthMode,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  // to make the size of the button a little smaller
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

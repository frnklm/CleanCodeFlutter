import 'package:flutter/material.dart';

import '../../components/component.dart';
import 'login_presenter.dart';

class LoginScreen extends StatelessWidget {
  // final LoginPresenter presenter;

  const LoginScreen({Key? key}) : super(key: key);
  // const LoginScreen(this.presenter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const LoginHeader(),
            Text(
              'Login'.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        icon: Icon(
                          Icons.email,
                          color: Colors.pink,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      // onChanged: presenter.validateEmail,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 32),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          icon: Icon(
                            Icons.lock,
                            color: Colors.pink,
                          ),
                        ),
                        obscureText: true,
                        // onChanged: presenter.validatePassword,
                      ),
                    ),
                    ElevatedButton(
                      child: Text('Entrar'.toUpperCase()),
                      onPressed: null,
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.person),
                      label: const Text('Criar conta'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean/domain/helpers/helpers.dart';
import 'package:clean/domain/usecases/authentication.dart';

import 'package:clean/data/http/http.dart';
import 'package:clean/data/usecases/usecases.dart';

import 'remote_authentication_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  RemoteAuthentication? sut;
  MockHttpClient? httpClient;
  String url = '';
  AuthenticationParams? params;

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient!, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
  });

  test('Should call HttpClient with correct URL', () async {
    when(httpClient!.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => {'accessToken': faker.guid.guid(), 'name': faker.person.name()});

    await sut!.auth(params!);

    verify(httpClient!.request(
      url: url,
      method: 'post',
      body: {'email': params!.email, 'password': params!.password},
    ));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    when(httpClient!.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    when(httpClient!.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.notFounded);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    when(httpClient!.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.serverError);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401',
      () async {
    when(httpClient!.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.unauthorized);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final accessToken = faker.guid.guid();
    when(httpClient!.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => {'accessToken': accessToken, 'name': faker.person.name()});

    final account = await sut!.auth(params!);

    expect(account.token, accessToken);
  });

   test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
   when(httpClient!.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => {'invalid_key': 'invalid_value'});

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });
}


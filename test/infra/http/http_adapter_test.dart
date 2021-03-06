import 'package:clean/data/http/http.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:clean/infra/http/http.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'http_adapter_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  MockClient? mockClient;
  HttpAdapter? sut;
  String url = '';

  setUp(() {
    mockClient = MockClient();
    sut = HttpAdapter(mockClient!);
    url = faker.internet.httpUrl();
  });

  group('post', () {
    PostExpectation mockRequest() =>
        when(mockClient!.post(any, headers: anyNamed('headers')));

    void mockResponse(int statusCode,
        {String body = '{"any_key": "any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with corret values', () async {
      await sut!
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(mockClient!.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: '{"any_key": "any_value"}',
      ));
    });

    test('Should call post without body', () async {
      await sut!.request(url: url, method: 'post');

      verify(mockClient!.post(
        any,
        headers: anyNamed('headers'),
      ));
    });

    test('Should return data if post returns 200', () async {
      final response = await sut!.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if post returns 200 with no data', () async {
      mockResponse(200, body: '');
      final response = await sut!.request(url: url, method: 'post');

      expect(response, {});
    });

    test('Should return null if post returns 204', () async {
      mockResponse(204, body: '');
      final response = await sut!.request(url: url, method: 'post');

      expect(response, {});
    });

    test('Should return null if post returns 204 with no data', () async {
      mockResponse(204);
      final response = await sut!.request(url: url, method: 'post');

      expect(response, {});
    });

    test('Should return BadRequestError if post returns 400 with no data',
        () async {
      mockResponse(400, body: '');
      final future = sut!.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return BadRequestError if post returns 400', () async {
      mockResponse(400);
      final future = sut!.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError if post returns 401', () async {
      mockResponse(401);
      final future = sut!.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return forbidden if post returns 403', () async {
      mockResponse(403);
      final future = sut!.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return notFounded if post returns 404', () async {
      mockResponse(404);
      final future = sut!.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.notFounded));
    });

    test('Should return ServerError if post returns 500', () async {
      mockResponse(500);
      final future = sut!.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if post throws', () async {
      mockError();
      final future = sut!.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('shared', () {
    test('Should throw ServerError if invalid method is provided', () async {
      final future = sut!.request(url: url, method: 'invalid_method');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}

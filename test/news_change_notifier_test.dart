import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';

class BadMockNewsService implements NewsService {
  bool getArticalsCalled = false;

  @override
  Future<List<Article>> getArticles() async {
    getArticalsCalled = true;
    return [
      Article(title: "Test 1", content: "Test 1 Content"),
      Article(title: "Test 2", content: "Test 2 Content"),
      Article(title: "Test 3", content: "Test 3 Content"),
    ];
  }
}

class MockNewsServices extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier stu;
  late MockNewsServices mockNewsServices;

  setUp(() {
    mockNewsServices = MockNewsServices();
    stu = NewsChangeNotifier(mockNewsServices);
  });

  test(
    "initial values are correct",
    () {
      expect(stu.articles, []);
      expect(stu.isLoading, false);
    },
  );

  void arrangeNewsServicesReturn3Articles() {
    when(() => mockNewsServices.getArticles()).thenAnswer(
      (_) async => [
        Article(title: "test 1", content: "Content 1"),
        Article(title: "test 2", content: "Content 2"),
        Article(title: "test 3", content: "Content 3"),
      ],
    );
  }

  group('getArticles', () {
    test("gets articles using the NewsServices", () async {
      when(() => mockNewsServices.getArticles()).thenAnswer((_) async => []);
      await stu.getArticles();
      verify(() => mockNewsServices.getArticles()).called(1);
    });

    test("indicates loading of data, sets articles to the once the services, indicates that does is not begin loaded anymore",
        () async {
      arrangeNewsServicesReturn3Articles();

      final future = stu.getArticles();
      expect(stu.isLoading, true);
      await future;
      expect(
        stu.articles,
        [
          Article(title: "test 1", content: "Content 1"),
          Article(title: "test 2", content: "Content 2"),
          Article(title: "test 3", content: "Content 3"),
        ],
      );
      expect(stu.isLoading, false);
    });
  });
}















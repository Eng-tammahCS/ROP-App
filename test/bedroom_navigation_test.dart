import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igloo/screens/bedroom_screen.dart';

void main() {
  testWidgets('الشاشة الرئيسية تعرض الغرفة بالعربية', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: BedroomScreen()));

    expect(find.text('غرفتنا'), findsOneWidget);
    expect(find.textContaining('مساحتكما الدافئة'), findsOneWidget);
    expect(find.textContaining('لولو نائمة بطمأنينة على السرير'), findsOneWidget);
    expect(find.text('اكتب رسالة لطيفة...'), findsNothing);
  });

  testWidgets('الضغط على شخصية الطرف الآخر يفتح صفحة محادثة مستقلة', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: BedroomScreen()));

    expect(find.textContaining('محادثة'), findsNothing);

    await tester.tap(find.bySemanticsLabel('لولو'));
    await tester.pumpAndSettle();

    expect(find.text('محادثة لولو'), findsOneWidget);
    expect(find.textContaining('كل شيء هنا محلي وآمن'), findsOneWidget);
    expect(find.text('اكتب رسالة لطيفة...'), findsOneWidget);
  });
}

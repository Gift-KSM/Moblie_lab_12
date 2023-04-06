import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api/ExchangeRate.dart';
import 'package:api/MoneyBox.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ExchangeRate _dataFromAPI;

  @override
  void initState() {
    super.initState();
  }

  Future<ExchangeRate> getExchangeRate() async {
    var url = "https://open.er-api.com/v6/latest/THB";
    var response = await http.get(Uri.parse(url));
    //แปลง JSON เป็น Object
    _dataFromAPI = exchangeRateFromJson(response.body);
    return _dataFromAPI;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('อัตราแลกเปลี่ยนสกุลเงิน'),
        ),
        body: FutureBuilder(
          future: getExchangeRate(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //ตรวจสอบสถานะ กรุณาดึงข้อมูลสำเร็จ
            if (snapshot.connectionState == ConnectionState.done) {
              var result = snapshot.data;
              double money = 50000;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    MoneyBox("THB", money, Colors.green, 150),
                    SizedBox(height: 5),
                    MoneyBox(
                        "AED", money * result.rates["AED"], Colors.red, 100),
                    SizedBox(height: 5),
                    MoneyBox(
                        "CHF", money * result.rates["CHF"], Colors.orange, 100),
                    SizedBox(height: 5),
                    MoneyBox(
                        "CAD", money * result.rates["CAD"], Colors.purple, 100),
                  ],
                ),
              );
            }
            //กรณ๊อยู่ระหว่างดึงข้อมูลให้แสดง progress bar
            return LinearProgressIndicator();
          },
        ));
  }
}

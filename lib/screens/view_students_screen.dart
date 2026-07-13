import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../database/db_helper.dart';
import '../models/student.dart';

class ViewStudentsScreen extends StatefulWidget {
  const ViewStudentsScreen({super.key});

  @override
  State<ViewStudentsScreen> createState() => _ViewStudentsScreenState();
}

class _ViewStudentsScreenState extends State<ViewStudentsScreen> {
  final _dbHelper = DatabaseHelper();
  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];
  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() async {
    final students = await _dbHelper.getAllStudents();
    setState(() {
      _allStudents = students;
      _filteredStudents = students;
    });
  }

  void _filter(String query) {
    setState(() {
      _filteredStudents = _allStudents
          .where((s) => s.name.contains(query) || s.idNumber.contains(query) || s.specialization.contains(query))
          .toList();
    });
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.cairoRegular();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('قائمة الطلاب', style: pw.TextStyle(font: font, fontSize: 24))),
          pw.TableHelper.fromTextArray(
            context: context,
            cellStyle: pw.TextStyle(font: font, fontSize: 10),
            headerStyle: pw.TextStyle(font: font, fontSize: 12, fontWeight: pw.FontWeight.bold),
            data: <List<String>>[
              ['رقم الهاتف', 'المستوى', 'التخصص', 'الهوية', 'الاسم', 'الرقم'],
              ..._filteredStudents.map((s) => [s.phone, s.level, s.specialization, s.idNumber, s.name, s.id.toString()])
            ],
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عرض جميع الطلاب'),
        actions: [
          IconButton(icon: const Icon(Icons.picture_as_pdf), onPressed: _generatePdf),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _filterController,
                decoration: const InputDecoration(
                  labelText: 'تصفية النتائج...',
                  prefixIcon: Icon(Icons.filter_list),
                  border: OutlineInputBorder(),
                ),
                onChanged: _filter,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = _filteredStudents[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ExpansionTile(
                      title: Text(student.name),
                      subtitle: Text('رقم: ${student.id} | تخصص: ${student.specialization}'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('نوع الهوية: ${student.idType}'),
                              Text('رقم الهوية: ${student.idNumber}'),
                              Text('المحافظة: ${student.governorate}'),
                              Text('المديرية: ${student.district}'),
                              Text('القرية: ${student.village}'),
                              Text('العزلة: ${student.isolation}'),
                              Text('المستوى: ${student.level}'),
                              Text('الهاتف: ${student.phone}'),
                              Text('تاريخ الإضافة: ${student.createdAt}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

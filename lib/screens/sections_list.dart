import 'package:chapa_tu_aula/components/classroms_list/classrom_container.dart';
import 'package:chapa_tu_aula/components/classroms_list/searchField.dart';
import 'package:chapa_tu_aula/services/fisi_horarios_api.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../components/shared/navDrawer.dart';
import '../models/Course.dart';
import '../models/Section.dart';

class SectionsList extends StatefulWidget {
  Map<String, dynamic> responseData;
  Map<String, String> cookies;
  String courseCode;

  SectionsList(
      {super.key,
      required this.responseData,
      required this.cookies,
      required this.courseCode});

  @override
  State<SectionsList> createState() => _ClassromsListState();
}

class _ClassromsListState extends State<SectionsList> {
  final searchController = TextEditingController();
  final fisiHorariosAPI = FISIHorariosAPI();
  late String userDegree;
  late String userPlan;
  List<Section> sections = [];

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    getUserInfo();
    buildCourseContainers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Secciones',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: sections.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: sections.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 20.0),
                  child: Column(children: [
                    // CourseContainer(course: sections[index]),
                    const SizedBox(height: 16.0),
                  ]),
                );
              }),
      drawer: NavDrawer(
        responseData: widget.responseData,
        cookies: widget.cookies,
      ),
    );
  }

  void getUserInfo() {
    userDegree =
        widget.responseData['dto']['desEscuela'].split(' ').last.toUpperCase();
    userPlan = widget.responseData['dto']['codPlan'];
    logger.d(userDegree);
    logger.d(userPlan);
  }

  Future<void> buildCourseContainers() async {
    Future<List<Course>?> result =
        fisiHorariosAPI.getCursosFromCarrera(userPlan, userDegree);
    List<Course>? coursesResult = await result;
    logger.d(coursesResult);
    if (coursesResult == null) {
      return;
    }
    courses = coursesResult;
    setState(() {});
  }
}

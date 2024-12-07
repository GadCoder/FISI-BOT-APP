import 'package:flutter/material.dart';

import '../components/shared/bttmNavDrawer.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({Key? key}) : super(key: key);

  @override
  _TeachersScreenState createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  int? selectedSemester;
  String? selectedClass;
  String? selectedTeacher;
  int starRating = 0;
  TextEditingController reviewController = TextEditingController();

  // Dummy data
  final List<int> semesters = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final Map<String, List<String>> classes = {
    '1': ['Algorithms I', 'Algorithms II'],
    '2': ['Data Structures', 'Operating Systems'],
  };
  final Map<String, List<String>> teachers = {
    'Algorithms I': ['Teacher A', 'Teacher B'],
    'Algorithms II': ['Teacher C', 'Teacher D'],
  };

  void _submitReview() {
    if (selectedSemester != null &&
        selectedClass != null &&
        selectedTeacher != null &&
        starRating > 0 &&
        reviewController.text.isNotEmpty) {
      // Logica para subir los datos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback registrado correctamente!')),
      );

      // Reset 
      setState(() {
        selectedSemester = null;
        selectedClass = null;
        selectedTeacher = null;
        starRating = 0;
        reviewController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete todos los campos!')),
      );
    }
  }

  Widget buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            Icons.star,
            color: index < starRating ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              starRating = index + 1;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Califique a su profesor: '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seleccionador semestre
            DropdownButtonFormField<int>(
              value: selectedSemester,
              items: semesters
                  .map((semester) => DropdownMenuItem(
                        value: semester,
                        child: Text('Semester $semester'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSemester = value;
                  selectedClass = null;
                  selectedTeacher = null;
                });
              },
              decoration: InputDecoration(labelText: 'Seleccione un Semestre'),
            ),

            SizedBox(height: 16),

            // Class Selector
            if (selectedSemester != null)
              DropdownButtonFormField<String>(
                value: selectedClass,
                items: (classes[selectedSemester.toString()] ?? [])
                    .map((className) => DropdownMenuItem(
                          value: className,
                          child: Text(className),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedClass = value;
                    selectedTeacher = null;
                  });
                },
                decoration: InputDecoration(labelText: 'Seleccione una clase'),
              ),

            SizedBox(height: 16),

            // Seleccionar un profesor
            if (selectedClass != null)
              DropdownButtonFormField<String>(
                value: selectedTeacher,
                items: (teachers[selectedClass!] ?? [])
                    .map((teacher) => DropdownMenuItem(
                          value: teacher,
                          child: Text(teacher),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTeacher = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Selecione un profesor'),
              ),

            SizedBox(height: 16),

            // Star Rating
            Text(
              'Califique al Profesor',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            buildStarRating(),

            SizedBox(height: 16),

            // Textfield para especificar
            TextField(
              controller: reviewController,
              decoration: InputDecoration(
                labelText: 'Especifique...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),

            SizedBox(height: 16),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _submitReview,
                child: Text('Calificar'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(responseData: {}, cookies: {},),
    );
  }
}

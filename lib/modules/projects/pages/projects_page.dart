import 'package:flutter/material.dart';

import '../models/project.dart';
import '../services/project_service.dart';
import '../widgets/add_project_dialog.dart';
import 'project_details_page.dart';
import '../models/project_task.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() =>
      _ProjectsPageState();
}

class _ProjectsPageState
    extends State<ProjectsPage> {
  List<Project> projects = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  void loadProjects() {
    setState(() {
      projects =
          ProjectService.getAllProjects();

      projects.sort(
        (a, b) => b.createdAt.compareTo(
          a.createdAt,
        ),
      );
    });
  }

  List<Project>
      getFilteredProjects() {
    if (searchQuery.isEmpty) {
      return projects;
    }

    return projects.where((p) {
      final query =
          searchQuery.toLowerCase();

      return p.title
              .toLowerCase()
              .contains(query) ||
          p.description
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  Future<void> addProject(
    Map<String, dynamic> data,
  ) async {
    final project = Project(
      id: data['id'],
      title: data['title'],
      description:
          data['description'],
      budget: data['budget'],
      spentAmount:
          data['spentAmount'],
      progress: data['progress'],
      status: data['status'],
      createdAt:
          data['createdAt'],
      deadline:
          data['deadline'],
      tasks: List<ProjectTask>.from(
        data['tasks'],
      ),
      expenses: [],
    );

    await ProjectService.addProject(
      project,
    );

    loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        getFilteredProjects();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes Projets',
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.all(
              12,
            ),
            child: TextField(
              decoration:
                  InputDecoration(
                hintText:
                    'Rechercher...',
                prefixIcon:
                    const Icon(
                  Icons.search,
                ),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery =
                      value;
                });
              },
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun projet',
                    ),
                  )
                : ListView.builder(
                    itemCount:
                        filtered.length,
                    itemBuilder:
                        (
                      context,
                      index,
                    ) {
                      final project =
                          filtered[index];

                      return Card(
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal:
                              12,
                          vertical: 6,
                        ),
                        child:
                            ListTile(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProjectDetailsPage(
                                  project:
                                      project,
                                ),
                              ),
                            );

                            loadProjects();
                          },

                          leading:
                              const CircleAvatar(
                            child: Icon(
                              Icons
                                  .rocket_launch,
                            ),
                          ),

                          title: Text(
                            project.title,
                          ),

                          subtitle:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
  ),
  decoration: BoxDecoration(
    color: project.status ==
            'Budget dépassé'
        ? Colors.red
        : Colors.green,
    borderRadius:
        BorderRadius.circular(20),
  ),
  child: Text(
    project.status,
    style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
),

                              const SizedBox(
                                height:
                                    5,
                              ),

                              LinearProgressIndicator(
                                value:
                                    project.progress /
                                        100,
                              ),
                            ],
                          ),

                          trailing:
                              Text(
                            '${project.progress}%',
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) =>
                AddProjectDialog(
              onAdd:
                  addProject,
            ),
          );
        },
        child:
            const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
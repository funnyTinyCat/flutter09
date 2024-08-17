import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_api_app/models/team.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Team> teams = [];
  // get teams
  Future getTeams() async {

    var response = await http.get(
      Uri.https('api.balldontlie.io', 'v1/teams', ), // api.
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'ec9653c7-31af-4a28-be06-8420e3b5a8fc',  
      },
    );
    


    // print(response.body);
    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData['data']) {

      final team = Team(
        abbreviation: eachTeam['abbreviation'], 
        city: eachTeam['city']
      );

      teams.add(team);
    }

    // print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    // getTeams();
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: getTeams(), 
          builder: (context, snapshot) {
            // is it done loading? then show team data
            if (snapshot.connectionState == ConnectionState.done) {
      
             return ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
      
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.only(bottom: 12, left: 10, right: 10,),
                    child: ListTile(
                      title: Text(teams[index].abbreviation),
                      subtitle: Text(teams[index].city),
                      
                    ),
                  );
                }, 
              );
            } 
            // if it's still loading, show circural progress
            else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        ),
      ),
    );
  }
}
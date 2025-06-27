import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final _logger = Logger();

class VotePage extends StatelessWidget {
  final VoidCallback? onBack;

  const VotePage({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'This is actually the poll page dood...',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: onBack, child: const Text('Back')),
          const SizedBox(height: 20),
          const MyButton(),
        ],
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightGreen[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 8),
        minimumSize: const Size.fromHeight(48),
      ),
      onPressed: () async {
        final pollResponse = await fetchCurrentPoll();
        if (pollResponse != null) {
          _logger.d(pollResponse.poll.title);
        } else {
          _logger.d('Poll data could not be fetched.');
        }
      },
      child: const Text('DO NOT FUCKING PRESS THIS BUTTON'),
    );
  }
}

Future<PollResponse?> fetchCurrentPoll() async {
  final url = Uri.parse('https://intranet.cssnr.com/api/poll/current/');
  final Map<String, String> headers = {
    'Authorization': '023R5xG6mvAHNTm4MArDGOSHgw5hTkYbCma5qvG-pxc',
  };
  final response = await http.get(url, headers: headers);
  _logger.d('response.statusCode: ${response.statusCode}');
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    _logger.d('Raw JSON response: $jsonResponse');
    return PollResponse.fromJson(jsonResponse);
  } else {
    _logger.d('Failed to load poll data: ${response.statusCode}');
    return null;
  }
}

class PollResponse {
  final Poll poll;
  final List<Choice> choices;
  final Vote? vote;

  PollResponse({required this.poll, required this.choices, this.vote});

  factory PollResponse.fromJson(Map<String, dynamic> json) {
    return PollResponse(
      poll: Poll.fromJson(json['poll']),
      choices: (json['choices'] as List)
          .map((choiceJson) => Choice.fromJson(choiceJson))
          .toList(),
      vote: json['vote'] != null ? Vote.fromJson(json['vote']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'poll': poll.toJson(),
    'choices': choices.map((c) => c.toJson()).toList(),
    if (vote != null) 'vote': vote!.toJson(),
  };
}

class Poll {
  final int id;
  final String title;
  final String question;
  final DateTime startAt;
  final DateTime endAt;

  Poll({
    required this.id,
    required this.title,
    required this.question,
    required this.startAt,
    required this.endAt,
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      id: json['id'],
      title: json['title'],
      question: json['question'],
      startAt: DateTime.parse(json['start_at']),
      endAt: DateTime.parse(json['end_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'question': question,
    'start_at': startAt.toIso8601String(),
    'end_at': endAt.toIso8601String(),
  };
}

class Choice {
  final int id;
  final int poll;
  final String name;
  final String file;
  final int votes;

  Choice({
    required this.id,
    required this.poll,
    required this.name,
    required this.file,
    required this.votes,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'],
      poll: json['poll'],
      name: json['name'],
      file: json['file'],
      votes: json['votes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'poll': poll,
    'name': name,
    'file': file,
    'votes': votes,
  };
}

class Vote {
  final int id;
  final int userId;
  final int pollId;
  final int choiceId;
  final bool notifyOnResult;
  final DateTime votedAt;

  Vote({
    required this.id,
    required this.userId,
    required this.pollId,
    required this.choiceId,
    required this.notifyOnResult,
    required this.votedAt,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'],
      userId: json['user_id'],
      pollId: json['poll_id'],
      choiceId: json['choice_id'],
      notifyOnResult: json['notify_on_result'],
      votedAt: DateTime.parse(json['voted_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'poll_id': pollId,
    'choice_id': choiceId,
    'notify_on_result': notifyOnResult,
    'voted_at': votedAt.toIso8601String(),
  };
}

import 'package:flutter/material.dart';
import 'package:voz_popular/data/models/comment_model.dart';
import 'package:voz_popular/data/repositories/auth_repository.dart';
import 'package:voz_popular/locator.dart';

class CommentSection extends StatefulWidget {
  final String occurrenceId;

  const CommentSection({super.key, required this.occurrenceId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = locator<OccurrenceRepository>().getComments(widget.occurrenceId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<List<Comment>>(
          future: _commentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Não foi possível carregar os comentários.'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(child: Text('Nenhum comentário para esta ocorrência.')),
              );
            }
            final comments = snapshot.data!;
            return Column(
              children: comments.map((comment) {
                return ListTile(
                  leading: CircleAvatar(child: Text(comment.userName.substring(0, 1).toUpperCase())),
                  title: Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(comment.content),
                  trailing: Text(comment.formattedDate, style: Theme.of(context).textTheme.bodySmall),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

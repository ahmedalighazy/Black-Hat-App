import 'package:black_hat_app/domain/failures.dart';
import 'package:black_hat_app/domain/repository/get_all_posts_repository.dart';
import 'package:dartz/dartz.dart';

import '../entities/GetAllPostsResponsesEntity.dart';

class GetAllPostsUseCase {
  GetAllPostsRepository getAllPostsRepository;
  GetAllPostsUseCase({required this.getAllPostsRepository});
  Future<Either<Failures, List<GetAllPostsResponsesEntity>>> call(){
    return getAllPostsRepository.getAllPosts();
  }
}
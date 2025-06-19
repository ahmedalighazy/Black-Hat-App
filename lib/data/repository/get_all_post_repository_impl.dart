import 'package:black_hat_app/data/data_sources/remote_data_source/get_all_posts_remote_data_source.dart';
import 'package:black_hat_app/domain/entities/GetAllPostResponsesEntity.dart';
import 'package:black_hat_app/domain/failures.dart';
import 'package:black_hat_app/domain/repository/get_all_posts_repository.dart';
import 'package:dartz/dartz.dart';


class GetAllPostRepositoryImpl implements GetAllPostsRepository {
  GetAllPostsRemoteDataSource getAllPostsRemoteDataSource;
  GetAllPostRepositoryImpl({required this.getAllPostsRemoteDataSource});
  @override
  Future<Either<Failures, List<GetAllPostResponsesEntity>>> getAllPosts(int userId) async{
    // TODO: implement getAllPosts
    var either = await getAllPostsRemoteDataSource.getAllPosts(userId);
    return either.fold((error)=> Left(error),
        (response)=> Right(response));
  }


}
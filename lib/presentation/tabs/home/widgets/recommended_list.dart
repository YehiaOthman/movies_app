import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/data/data_source_impl/recommended_movies_api_data_source_impl.dart';
import 'package:movies_app/data/models/recommended_movie_response/recommended_movie.dart';
import 'package:movies_app/data/repo_impl/recommended_movies_repo_impl.dart';
import 'package:movies_app/domain/usecases/get_recommended_movies_use_case.dart';
import 'package:movies_app/presentation/common/loading_widget.dart';
import 'package:movies_app/presentation/tabs/home/viewModel/cubits/recommended_movie_cubit.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../data/api/api_manager.dart';
import '../viewModel/states/recommended_movie_state.dart';

class RecommendedList extends StatelessWidget {
  const RecommendedList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecommendedMovieCubit(
        useCase: GetRecommendedMoviesUseCase(
          repo: RecommendedMoviesRepoImpl(
            recommendedMoviesDataSource: RecommendedMoviesApiDataSourceImpl(
              apiManager: ApiManager(),
            ),
          ),
        ),
      )..getRecommendedMovies(),
      child: BlocBuilder<RecommendedMovieCubit, RecommendedMovieState>(
        builder: (context, state) {
          switch (state) {
            case GetRecommendedMovieInitialState():
              return const SizedBox();
            case GetRecommendedMovieLoadingState():
              return const LoadingWidget();
            case GetRecommendedMovieSuccessState():
              return recommendedList(state);
            case GetRecommendedMovieErrorState():
              return Text('Error');
          }
        },
      ),
    );
  }

  Widget recommendedList(GetRecommendedMovieSuccessState state) {
    return Container(
      height: 250.h,
      padding: REdgeInsets.only(
        top: 15,
        bottom: 15,
        left: 20,
      ),
      color: AppColors.gray,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Recommended',
            style: AppStyles.homeListTitle,
          ),
          SizedBox(
            height: 13.h,
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => recommendedListItem(
                movie: state.list[index],
              ),
              itemCount: state.list.length,
              separatorBuilder: (context, index) => SizedBox(
                width: 14.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget recommendedListItem({required RecommendedMovie movie}) => Column(
        children: [
          Container(
            height: 128.h,
            width: 97.w,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  AppConstants.imageBase + movie.posterPath!,
                ),
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const ImageIcon(
                  size: 40,
                  color: Color(0xFF514F4F),
                  AssetImage(
                    AppAssets.bookMarkIcon,
                  ),
                ),
                Padding(
                  padding: REdgeInsets.only(bottom: 6),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 97.w,
            padding: REdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.gray,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4.r),
                bottomRight: Radius.circular(4.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.yellow,
                      size: 15,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      movie.voteAverage.toString(),
                      style: AppStyles.rateText,
                    )
                  ],
                ),
                SizedBox(height: 5.h,),
                Text(
                  movie.title!,
                  style: AppStyles.rateText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/data/api/api_manager.dart';
import 'package:movies_app/data/data_source_impl/new_releases_movies_api_data_source_impl.dart';
import 'package:movies_app/data/models/new_release_movie_response/new_releases_movie.dart';
import 'package:movies_app/data/repo_impl/new_releases_movie_impl.dart';
import 'package:movies_app/domain/usecases/get_new_releases_movie_use_case.dart';
import 'package:movies_app/presentation/common/loading_widget.dart';
import 'package:movies_app/presentation/tabs/home/viewModel/cubits/new_releases_movie_cubit.dart';
import 'package:movies_app/presentation/tabs/home/viewModel/states/get_new_releases_movies_states.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_styles.dart';

class NewReleasesList extends StatelessWidget {
  const NewReleasesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NewReleasesMoviesCubit(
        getNewReleasesMovieUseCase: GetNewReleasesMovieUseCase(
          repo: NewReleaseMovieRepoImpl(
            newReleasesMoviesDataSource: NewReleasesMoviesDataSourceImpl(
              apiManager: ApiManager(),
            ),
          ),
        ),
      )..getNewReleasesMovies(),
      child: BlocBuilder<NewReleasesMoviesCubit, GetNewReleasesMoviesState>(
        builder: (BuildContext context, GetNewReleasesMoviesState state) {
          switch (state) {
            case GetNewReleasesMoviesLoadingState():
              return const LoadingWidget();

            case GetNewReleasesMoviesSuccessState():
              return Container(
                height: 187.h,
                padding: REdgeInsets.only(
                  top: 15,
                  bottom: 15,
                  left: 27,
                ),
                color: AppColors.gray,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'New Releases',
                      style: AppStyles.newReleasesListTitle,
                    ),
                    SizedBox(
                      height: 13.h,
                    ),
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => newReleasesListItem(
                          movie: state.list[index],
                        ),
                        itemCount: 10,
                        separatorBuilder: (context, index) => SizedBox(
                          width: 14.w,
                        ),
                      ),
                    ),
                  ],
                ),
              );

            case GetNewReleasesMoviesErrorState():
              return const Text('Error');
            case GetNewReleasesMoviesInitialState():
              return const SizedBox();
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget newReleasesListItem({required NewReleaseMovie movie}) => Container(
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
      );
}
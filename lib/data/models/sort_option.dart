enum SortOption {
  popularityDesc,
  popularityAsc,
  releaseDateDesc,
  releaseDateAsc,
  voteAverageDesc,
  voteAverageAsc,
}

extension SortOptionExt on SortOption {
  String get apiValue {
    switch (this) {
      case SortOption.popularityDesc:
        return 'popularity.desc';
      case SortOption.popularityAsc:
        return 'popularity.asc';
      case SortOption.releaseDateDesc:
        return 'release_date.desc';
      case SortOption.releaseDateAsc:
        return 'release_date.asc';
      case SortOption.voteAverageDesc:
        return 'vote_average.desc';
      case SortOption.voteAverageAsc:
        return 'vote_average.asc';
    }
  }
}

abstract class ReportFiltering {
  void filterOrSortReports({String? statusFilter, bool sortByDateAsc});

  void sortReports({String? groupByStatus, bool sortByDateAsc});
}

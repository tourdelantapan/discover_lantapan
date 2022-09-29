import 'package:app/models/visitor_model.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VisitorTable extends StatefulWidget {
  VisitorTable({Key? key}) : super(key: key);

  @override
  State<VisitorTable> createState() => _VisitorTableState();
}

class _VisitorTableState extends State<VisitorTable> {
  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      Provider.of<UserProvider>(context, listen: false).getVisitors(
          callback: (code, message) {
        if (code != 200) {
          launchSnackbar(context: context, mode: "ERROR", message: message);
        }
      });
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    DataTableSource dataSource(List<Visitor> visitorList) =>
        TableData(dataList: visitorList);

    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        color: Colors.white,
        child: Row(children: [
          IconText(
            label: "Total Visitors: ${userProvider.visitorCount}",
            color: Colors.black,
            fontWeight: FontWeight.bold,
            size: 18,
          )
        ]),
      ),
      const SizedBox(
        height: 15,
      ),
      if (userProvider.loading == "visitor-list")
        const LinearProgressIndicator()
      else
        Expanded(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: PaginatedDataTable(
            source: dataSource(userProvider.visitorList),
            rowsPerPage: userProvider.visitorList.length < 10
                ? userProvider.visitorList.length
                : 10,
            columns: [
              DataColumn(
                  label: IconText(
                label: 'Destination',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                size: 13,
              )),
              DataColumn(
                  label: IconText(
                label: 'Full Name',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                size: 13,
              )),
              DataColumn(
                  label: IconText(
                label: 'Address',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                size: 13,
              )),
              DataColumn(
                  label: IconText(
                label: 'Date of Visit',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                size: 13,
              )),
              DataColumn(
                  label: IconText(
                label: 'Total Visitors',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                size: 13,
              )),
              DataColumn(
                  label: IconText(
                label: 'Contact Number',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                size: 13,
              )),
            ],
            showCheckboxColumn: false,
          ),
        ))
    ]);
  }
}

class TableData extends DataTableSource {
  TableData({required this.dataList});
  final List<Visitor> dataList;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => dataList.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          dataList[index].placeId.photos.isNotEmpty
                              ? dataList[index].placeId.photos[0].small!
                              : placeholderImage))),
            ),
            Text(dataList[index].placeId.name),
          ]),
        ),
        DataCell(
          Text(dataList[index].fullName),
        ),
        DataCell(
          Text(dataList[index].homeAddress),
        ),
        DataCell(
          Text(DateFormat("MMM dd, yyyy").format(dataList[index].dateOfVisit)),
        ),
        DataCell(
          Text(dataList[index].numberOfVisitors.toString()),
        ),
        DataCell(Text("+63${dataList[index].contactNumber}")),
      ],
    );
  }
}

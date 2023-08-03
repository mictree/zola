import "./datatableTemplate.scss";
import { DataGrid } from "@mui/x-data-grid";
import CircularProgress from '@mui/material/CircularProgress';
import Box from '@mui/material/Box';
import { Link } from "react-router-dom";
import { useEffect, useState } from "react";

const DatatableTemplate = ({title, dataRows, columns, deleteMutation, 
    recoverMutation, hardDeleteMutation ,actionColumn=[], rowHeight = 50, 
    addNew=true, refetch, loading = false}) => {
  const [data, setData] = useState(dataRows);

  const {mutate: deleteElement, isSuccess: deleteElementSuccess} = deleteMutation
  const {mutate: recoverElement, isSuccess: recoverElementSuccess} = recoverMutation
  const {mutate: hardDeleteElement, isSuccess: hardDeleteElementSuccess} = hardDeleteMutation

  useEffect(()=>{
    setData(dataRows)
    recoverElementSuccess && refetch()
    recoverElement && refetch()
    hardDeleteElementSuccess && refetch()
  }, [dataRows, deleteElementSuccess, recoverElementSuccess, hardDeleteElementSuccess])

  const handleDelete = async (event, id) => {
    event.stopPropagation()
    await deleteElement(id)
  };

  const handleHardDelete = async (event, id) => {
    event.stopPropagation()
    setData(data.filter((item) => item.id !== id));
    await hardDeleteElement(id)
  };

  const handleRecover = async (event, id) => {
    event.stopPropagation()
    await recoverElement(id)
  };



  const _actionColumn = actionColumn(handleDelete, handleRecover, handleHardDelete)

  return (
    <div className="datatable">
      <div className="datatableTitle">
        {title}
        {
          addNew ? 
        <Link to='new' className="link">
          Add New
        </Link>
        :
        ""
        }
      </div>
      {
        deleteMutation.isSuccess ?
        <div>Success</div>
        :
        ""
      }
      {!data ? 
        <Box sx={{ display: 'flex', justifyContent: 'center' }}>
          <CircularProgress />
        </Box>
       :
        <DataGrid
          className="datagrid"
          rows={data}
          columns={columns.concat(_actionColumn)}
          pageSize={10}
          rowsPerPageOptions={[10]}
          checkboxSelection
          getRowId={(row) => row._id}
          rowHeight={rowHeight}
          loading={!data || loading}
          onSelectionModelChange={(ids) => {
            const selectedIDs = new Set(ids);
            const selectedRowData = data.filter((row) =>
              selectedIDs.has(row._id.toString())
            )
            console.log(selectedRowData);
          }}
        />
      }
    </div>
  );
};

export default DatatableTemplate;

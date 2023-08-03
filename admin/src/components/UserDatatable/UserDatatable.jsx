import { DataGrid } from "@mui/x-data-grid";
import { useQuery } from "@tanstack/react-query";
import React from "react";
import { Link } from "react-router-dom";
import userService from "../../services/UserService";
import './UserDatatable.scss'

export default function OrderDatatable() {

  const {data: users, error, isError, isLoading } = useQuery({queryKey: ['users'], queryFn: userService.getUser}) 
  const data = users?.data?.data
  

  const actionColumn = [
    {
      field: "action",
      headerName: "Action",
      width: 200,
      renderCell: (params) => {
        return (
          <div className="cellAction">
            <Link to="/users/test" style={{ textDecoration: "none" }}>
              <div className="viewButton">View</div>
            </Link>
            <div
              className="deleteButton"
              onClick={() => handleDelete(params.row.id)}
            >
              Delete
            </div>
          </div>
        );
      },
    },
  ];

  const columns = [
    { field: "_id", headerName: "ID", width: 70 },
    { field: "first_name", headerName: "First name", width: 100 },
    { field: "middle_name", headerName: "Middle name", width: 100 },
    { field: "last_name", headerName: "Last name", width: 100 },
    {
      field: "avatar",
      headerName: "Avatar",
      width: 70,
      renderCell: (params) => {
        return (
          <div className="cellWithImg">
            <img className="cellImg" src={params.row.avatarUrl || '/images/avatar.svg'} alt="avatar" />
          </div>
        );
      },
    },
    {
      field: "fullName",
      headerName: "Full name",
      description: "This column has a value getter and is not sortable.",
      sortable: false,
      width: 150,
      valueGetter: (params) =>
        `${params.row.last_name || ""} ${params.row.middle_name || ""} ${params.row.first_name || ""} `,
    },
    { field: "email", headerName: "Email", width: 170 },
    { field: "postalCode", headerName: "Postal Code", width: 130 },
    {
      field: "birthDate",
      headerName: "Birth Day",
      type: "date",
      width: 90,
    },

  ];

  
  return (
    <>
      <div>OrderDatatable</div>
      <div style={{ height: 400, width: '100%' }}>
        {isLoading ? <div>"Đang tải"</div> : 
        <DataGrid
        rows={data}
        columns={columns.concat(actionColumn)}
        pageSize={5}
        getRowId={(row) => row._id}
        rowsPerPageOptions={[5]}
        checkboxSelection
        rowHeight={60}
      />}
      
    </div>
    </>
  );
}

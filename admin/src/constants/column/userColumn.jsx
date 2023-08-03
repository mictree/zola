import { Link } from "react-router-dom";
import { formatDate } from "../../utils/fmt";

export const userColumns = [
  { field: "_id", headerName: "ID", width: 200 },
  { field: "username", headerName: "username", width: 200 },
  {
    field: "user",
    headerName: "User",
    width: 200,
    renderCell: (params) => {
      return (
        <div className="cellWithImg">
          <img
            className="cellImg"
            src={params.row.avatarUrl || "/images/avatar.svg"}
            alt="avatar"
          />
          {`${params.row.fullname}`}
        </div>
      );
    },
  },
  {
    field: "email",
    headerName: "Email",
    width: 150,
  },
  {
    field: "phone",
    headerName: "Phone",
    width: 130,
  },

  // {
  //   field: "birthday",
  //   headerName: "Birthday",
  //   width: 100,
  //   valueGetter: (params) => formatDate(params.row.birthday),
  // },

  {
    field: "created_date",
    headerName: "Join date",
    width: 100,
    valueGetter: (params) => formatDate(params.row.created_date),
  },

  {
    field: "deleted_at",
    headerName: "Status",
    width: 100,
    // valueGetter: (params) => formatDate(params.row?.deleted_at),
    renderCell: (params) => {
      if (params.row?.deleted_at)
        return <div className="cellWithStatus passive">Deleted</div>;
      return <div className="cellWithStatus active">Active</div>;
    },
  },
  // {
  //   field: "status",
  //   headerName: "Status",
  //   width: 160,
  //   renderCell: (params) => {
  //     return (
  //       <div className={`cellWithStatus ${params.row.status}`}>
  //         {params.row.status}
  //       </div>
  //     );
  //   },
  // },
];

export const userActionColumn = (
  handleDelete,
  handleRecover,
  handleHardDelete
) => [
  {
    field: "action",
    headerName: "Action",
    width: 250,
    renderCell: (params) => {
      return (
        <div className="cellAction">
          <Link
            to={`/users/${params.row._id}`}
            style={{ textDecoration: "none" }}
          >
            <div className="viewButton">View</div>
          </Link>
          {!params.row?.deleted_at ? (
            <div
              className="deleteButton"
              onClick={(event) => handleDelete(event, params.row._id)}
            >
              Delete
            </div>
          ) : (
            <div
              className="recoverButton"
              onClick={(event) => handleRecover(event, params.row._id)}
            >
              Recover
            </div>
          )}
          <div
            className="hardDeleteButton"
            onClick={(event) => handleHardDelete(event, params.row._id)}
          >
            Hard delete
          </div>
        </div>
      );
    },
  },
];

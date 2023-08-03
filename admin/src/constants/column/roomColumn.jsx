import { generatePath, Link } from "react-router-dom";
import { formatDate } from "../../utils/fmt";
import { USER_DETAIL_PATH } from "../path";
import { nanoid } from 'nanoid'
import { Tooltip } from "@mui/material";

export const roomColumns = [
  { field: "_id", headerName: "ID", width: 250 },
  {
    field: "users",
    headerName: "Users",
    width: 350,
    renderCell: (params) => {
      return (
        <div className="cellWithImg">
          {params.row.users?.map((user) => (
            <Link to={generatePath(USER_DETAIL_PATH, { id: user._id })} key={nanoid()}>
            <Tooltip title={user.fullname} arrow>
              <img
                className="cellImg"
                src={user.avatarUrl || "/images/avatar.svg"}
                alt={`${user.fullname}`}
                />
                </Tooltip>
            </Link>
          ))}
        </div>
      );
    },
  },
  {
    field: "created_by",
    headerName: "Creator",
    width: 150,
    renderCell: (params) => {
      return params.row.created_by ? (
        <div className="cellWithImg">
          <Link
            to={generatePath(USER_DETAIL_PATH, {
              id: params.row?.created_by._id,
            })}
          >
            <Tooltip title={params.row?.created_by.fullname}>
            <img
              className="cellImg"
              src={params.row.created_by?.avatarUrl || "/images/avatar.svg"}
              alt={`${params.row.created_by?.fullname}`}
            />
            </Tooltip>
          </Link>
          {params.row.created_by?.username}
        </div>
      ) : (
        ""
      );
    },
  },
  {
    field: "created_at",
    headerName: "Created at",
    width: 100,
    valueGetter: (params) => formatDate(params.row.created_at),
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
];

export const roomActionColumn = (handleDelete, recoverHandle, hardDeleteButton) => [
  {
    field: "action",
    headerName: "Action",
    width: 250,
    renderCell: (params) => {
      return (
        <div className="cellAction">
          <Link
            to={`/rooms/${params.row._id}`}
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
              onClick={(event) => recoverHandle(event, params.row._id)}
            >
              Recover
            </div>
          )}
                    <div
            className="hardDeleteButton"
            onClick={(event) => hardDeleteButton(event, params.row._id)}
          >
            Hard delete
          </div>
        </div>
      );
    },
  },
];

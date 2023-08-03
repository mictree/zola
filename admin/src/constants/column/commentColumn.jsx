import { generatePath, Link } from "react-router-dom";
import { formatDate } from "../../utils/fmt";
import { POST_DETAIL_PATH } from "../path";
import FavoriteIcon from "@mui/icons-material/Favorite";
import { Tooltip } from "@mui/material";

export const commentColumns = [
  { field: "_id", headerName: "ID", width: 250 },
  {
    field: "author",
    headerName: "Author",
    width: 230,
    renderCell: (params) => {
      return (
        <div className="cellWithImg">
          <img
            className="cellImg"
            src={params.row.author.avatarUrl || "/images/avatar.svg"}
            alt="avatar"
          />
          {`${params.row.author.username}`}
        </div>
      );
    },
  },
  {
    field: "postId",
    headerName: "Post",
    width: 230,
    renderCell: (params) => {
      return (
        <Link
          to={generatePath(POST_DETAIL_PATH, { id: params.row.postId })}
          style={{ textDecoration: "none", color: "black" }}
        >
          <div>{`${params.row.postId}`}</div>
        </Link>
      );
    },
  },
  { field: "content", headerName: "Content", width: 200 },
  {
    field: "interact",
    headerName: "Interact",
    width: 100,
    renderCell: (params) => {
      return (
        <div className="cellWithImg">
          <FavoriteIcon className="iconLove" />
          {params.row.like_by.length}
        </div>
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

export const commentActionColumn = (
  handleDelete,
  handleRecover,
  handleHardDelete
) => [
  {
    field: "action",
    headerName: "Action",
    width: 200,
    renderCell: (params) => {
      return (
        <div className="cellAction">
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

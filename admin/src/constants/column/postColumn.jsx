import { generatePath, Link } from "react-router-dom";
import { formatDate } from "../../utils/fmt";
import { POST_DETAIL_PATH } from "../path";
import FavoriteIcon from "@mui/icons-material/Favorite";
import CommentIcon from "@mui/icons-material/Comment";

export const postColumns = [
  { field: "_id", headerName: "ID", width: 200 },
  {
    field: "author",
    headerName: "Author",
    width: 250,
    renderCell: (params) => {
      return (
        <div className="cellWithImg">
          <img
            className="cellImg"
            src={params.row.author.avatarUrl || "/images/avatar.svg"}
            alt="avatar"
          />
          {`${params.row.author.fullname}`}
        </div>
      );
    },
  },
  { field: "content", headerName: "Content", width: 200 },
  {
    field: "interact",
    headerName: "Interact",
    width: 200,
    valueGetter: (params) => params.row.like_by.length,
    renderCell: (params) => {
      return (
        <div className="cellWithImg">
          <FavoriteIcon className="iconLove" />
          {params.row.like_by.length}

          <CommentIcon className="iconComment" />
          {params.row.comments.length}
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

export const postActionColumn = (handleDelete, recoverButton, handleHardDelete) => [
  {
    field: "action",
    headerName: "Action",
    width: 240,
    renderCell: (params) => {
      return (
        <div className="cellAction">
          <Link
            to={generatePath(POST_DETAIL_PATH, { id: params.row._id })}
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
              onClick={(event) => recoverButton(event, params.row._id)}
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

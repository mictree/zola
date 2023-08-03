import React from "react";
import { generatePath, Link } from "react-router-dom";
import { USER_DETAIL_PATH } from "../../constants/path";
import Tooltip from "@mui/material/Tooltip";
import "./userItem.scss";

export default function UserItem({ _id, username, avatarUrl }) {
  return (
    <Link to={generatePath(USER_DETAIL_PATH, { id: _id })} className="userItem">
      <Tooltip title={username} arrow>
        <div className="mainContent">
          <img className="avatar" src={avatarUrl}></img>
          <div className="username">{username}</div>
        </div>
      </Tooltip>
    </Link>
  );
}

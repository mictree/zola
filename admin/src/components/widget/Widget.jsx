import "./widget.scss";
import KeyboardArrowUpIcon from "@mui/icons-material/KeyboardArrowUp";
import PersonOutlinedIcon from "@mui/icons-material/PersonOutlined";
import AccountBalanceWalletOutlinedIcon from "@mui/icons-material/AccountBalanceWalletOutlined";
import ViewHeadlineIcon from '@mui/icons-material/ViewHeadline';
import ShoppingCartOutlinedIcon from "@mui/icons-material/ShoppingCartOutlined";
import ChatIcon from '@mui/icons-material/Chat';
import MonetizationOnOutlinedIcon from "@mui/icons-material/MonetizationOnOutlined";
import BookIcon from '@mui/icons-material/Book';
import { formatPrice } from "../../utils/fmt";
import { Link } from "react-router-dom";

const Widget = ({ type, amount = 0, diff = 0 }) => {
  let data;

  //temporary
  switch (type) {
    case "user":
      data = {
        title: "USERS",
        isMoney: false,
        link: "See all users",
        to: "/users",
        icon: (
          <PersonOutlinedIcon
            className="icon"
            style={{
              color: "crimson",
              backgroundColor: "rgba(255, 0, 0, 0.2)",
            }}
          />
        ),
      };
      break;
    case "post":
      data = {
        title: "POSTS",
        isMoney: false,
        link: "View all posts",
        to: "/posts",
        icon: (
          <ViewHeadlineIcon
            className="icon"
            style={{
              backgroundColor: "rgba(218, 165, 32, 0.2)",
              color: "goldenrod",
            }}
          />
        ),
      };
      break;
    case "room":
      data = {
        title: "ROOM",
        isMoney: false,
        link: "View",
        to: "/rooms",
        icon: (
          <BookIcon
            className="icon"
            style={{ backgroundColor: "rgba(0, 128, 0, 0.2)", color: "green" }}
          />
        ),
      };
      break;
    case "chat":
      data = {
        title: "CHATS",
        link: "View",
        icon: (
          <ChatIcon
            className="icon"
            style={{
              backgroundColor: "rgba(128, 0, 128, 0.2)",
              color: "purple",
            }}
          />
        ),
      };
      break;
    case "comment":
      data = {
        title: "COMMENT",
        link: "View",
        to: "/comments",
        icon: (
          <ChatIcon
            className="icon"
            style={{
              backgroundColor: "rgb(219,233,255)",
              color: "rgb(35,116,225)",
            }}
          />
        ),
      };
      break;
    default:
      break;
  }

  return (
    <div className="widget">
      <div className="left">
        <span className="title">{data.title}</span>
        <span className="counter">
          {data.isMoney && "đ"} {formatPrice (amount)}
        </span>
        {
          data.to && <Link to={data.to}>{data.link}</Link>
        }
      </div>
      <div className="right">
        <div className="percentage positive">
          <KeyboardArrowUpIcon />
          {diff} %
        </div>
        {data.icon}
      </div>
    </div>
  );
};

export default Widget;

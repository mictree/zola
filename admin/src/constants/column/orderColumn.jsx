import { generatePath, Link } from "react-router-dom";
import CheckIcon from '@mui/icons-material/Check';
import {formatPrice} from "../../utils/fmt"
import { USER_DETAIL_PATH } from "../path";

const status = {
  "Chờ xác nhận": "pending",
  "Đang giao": "pending",
  "Đã nhận": "active",
  "Đã hủy": "passive"
}

export const orderColumns = [
    { field: "_id", headerName: "ID", width: 100 },
    {
      field: "order_by",
      headerName: "Order by",
      width: 150,
      renderCell: (params) => {
        return (
          <Link to={generatePath(USER_DETAIL_PATH, {id: params.row.order_by._id})} style={{textDecoration:"none"}}>
          <div className="cellWithImg">
            <img className="cellImg" src={params.row.order_by.avatarUrl || "/images/avatar.svg"} alt="avatar" />
            {`${params.row.order_by.last_name} ${params.row.order_by.middle_name} ${params.row.order_by.first_name}`}
          </div>
          </Link>
        );
      },
    },
    {
      field: "order_items",
      headerName: "Order items",
      width: 400,
      renderCell: (params) => {
        return (
          <div className="cellWithImg">
              <ul>{
              params.row.order_items.map( (item) => (
                <li>
                <img className="bookImg" src={item.info.imageUrl || "/images/avatar.svg"} alt="item_image" />
                <span>{item.info.title.slice(0, 30) + "..."}</span>
                <span>  x{item.quantity}</span>
                </li>
              )
              )}
              </ul>             
          </div>
        );
      },
    },
    
    {
      field: "payment_type",
      headerName: "Payment",
      width: 100,
    },
    {
      field: "is_paid",
      headerName: "Paid",
      width: 80,
      renderCell: (params) => {
        return (
          <div>
            {params.row.is_paid ? <CheckIcon style={{color: "green"}}/> : ""}
          </div>
        )
      }
    },
    {
      field: "address",
      headerName: "Address",
      width: 200,
    },
    {
      field: "order_total_value",
      headerName: "Total",
      width: 100,
      renderCell: (params) =>{
        return <div>{formatPrice(params.row.order_total_value)} đ</div>
      }
    },
    {
      field: "status",
      headerName: "Status",
      width: 100,
      renderCell: (params) => {
        return (
          <div className={`cellWithStatus ${status[params.row.status]}`}>
            {params.row.status}
          </div>
        );
      },
    },
  ];

export const orderActionColumn = (handleDelete) => [
{
    field: "action",
    headerName: "Action",
    width: 200,
    renderCell: (params) => {
    return (
        <div className="cellAction">
        <Link to={"/orders/"+params.row._id} style={{ textDecoration: "none" }}>
            <div className="viewButton">View</div>
        </Link>
        <div
            className="deleteButton"
            onClick={(event) => handleDelete(event, params.row.id)}
        >
            Delete
        </div>
        </div>
    );
    },
},
];
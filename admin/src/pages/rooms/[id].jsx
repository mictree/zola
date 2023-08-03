import "./single.scss";
import Chart from "../../components/chart/Chart";
import { useParams } from "react-router-dom";
import { formatDate } from "../../utils/fmt";
import { useUserLastPost } from "../../hooks/usePost";
import { useDeleteRoom, useRecoverRoom, useRoomDetail } from "../../hooks/useRoom";
import UserItem from "../../components/userItem";
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { useEffect } from "react";
import { nanoid } from "nanoid";
import { useQuery } from "@tanstack/react-query";
import statisticService from "../../services/statisticService";

const RoomsDetail = () => {
  const { id } = useParams();
  const { data, isLoading, refetch } = useRoomDetail(id);
  const { data: posts, isLoading: postIsLoading } = useUserLastPost(id);
  const { mutate: deleteRoom, isSuccess: deleteSuccess } = useDeleteRoom(id);
  const { mutate: recover, isSuccess: recoverSuccess } = useRecoverRoom(id);

  useEffect(() => {
    document.title = 'Rooms Detail - Admin';
  }, []);

  const room = data?.data;

  const {data: roomChat} = useQuery(["room-chat", id], () => statisticService.getRoomChatStatistic(id))
  
  const onDelete = () => {
    deleteRoom(id);
    if (deleteSuccess) {
      toast.success(`Delete ${room?._id} room success`, {
        position: "top-right",
        autoClose: 5000,
        hideProgressBar: false,
        closeOnClick: true,
        pauseOnHover: false,
        draggable: true,
        progress: undefined,
        theme: "light",
      });
      refetch();
    }
  };

  const onRecover = () => {
    recover(id);
    if (recoverSuccess) {
      toast.success(`Recover ${room?._id} room success`, {
        position: "top-right",
        autoClose: 5000,
        hideProgressBar: false,
        closeOnClick: true,
        pauseOnHover: false,
        draggable: true,
        progress: undefined,
        theme: "light",
      });
      refetch();
    }
  };

  return (
    <div className="single">
      <div className="singleContainer">
        <div className="top">
          <div className="left">
            <ToastContainer
              position="top-right"
              autoClose={5000}
              hideProgressBar={false}
              newestOnTop={false}
              closeOnClick
              rtl={false}
              pauseOnFocusLoss
              draggable
              pauseOnHover={false}
              theme="light"
            />
            {room?.deleted_at ? (
              <div className="recoverButton" onClick={onRecover}>
                Recover
              </div>
            ) : (
              <div className="deleteButton" onClick={onDelete}>
                Delete
              </div>
            )}
            <div className="hardDeleteButton">Hard Delete</div>
            <h1 className="title">Information</h1>
            <div className="item">
              <div className="details">
                <h1 className="itemTitle">{room?.name}</h1>
                <div className="detailItem">
                  <span className="itemKey">Id:</span>
                  <span className="itemValue">{room?._id}</span>
                </div>
                <div className="detailItem">
                  <span className="itemKey">Users:</span>
                  {room?.users.map((user) => (
                    <UserItem
                      key={nanoid()}
                      _id={user._id}
                      username={user.username}
                      avatarUrl={user.avatarUrl}
                    />
                  ))}
                </div>

                <div className="detailItem">
                  <span className="itemKey">Create at:</span>
                  <span className="itemValue">
                    {formatDate(room?.created_at)}
                  </span>
                </div>
                <div className="detailItem">
                  <span className="itemKey">Update at:</span>
                  <span className="itemValue">
                    {formatDate(room?.updated_at)}
                  </span>
                </div>
                <div className="detailItem">
                  <span className="itemKey">Deleted at:</span>
                  <span className="itemValue">
                    {formatDate(room?.deleted_at)}
                  </span>
                </div>
              </div>
            </div>
          </div>
          <div className="right">
            <Chart aspect={4 / 2} title="User chat in last year" data={roomChat?.data}/>
          </div>
        </div>
        <div className="bottom">
          <h1 className="title">Last Chat</h1>
          {postIsLoading ? "" : posts.data.map((post) => <div>{post._id}</div>)}
        </div>
      </div>
    </div>
  );
};

export default RoomsDetail;

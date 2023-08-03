import "./single.scss";
import Chart from "../../components/chart/Chart";
import { useParams } from "react-router-dom";
import {
  useDeleteUser,
  useRecoverUser,
  useUserDetail,
} from "../../hooks/useUser";
import { formatDate } from "../../utils/fmt";
import { useUserLastPost } from "../../hooks/usePost";
import Loading from "../../components/Loading";
import { useUserChatStatistic } from "../../hooks/useStatisticNumber";
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { useEffect } from "react";
import { nanoid } from 'nanoid'

const UserDetail = () => {
  const { id } = useParams();
  const { data, isLoading, refetch } = useUserDetail(id);
  const { data: posts, isLoading: postIsLoading } = useUserLastPost(id);
  const { data: chatData, isLoading: chatDataIsLoading } = useUserChatStatistic(id);
  const { mutate: deleteUser, isSuccess: deleteSuccess } = useDeleteUser(id);
  const { mutate: recover, isSuccess: recoverSuccess } = useRecoverUser(id);

  
  const user = data?.data;
  
  useEffect(() => {
    document.title = user?.fullname + ' detail - Admin';
  }, [user]);

  const onDelete = () => {
    deleteUser(id);
    if (deleteSuccess) {
      toast.success(`Delete ${user?.username} user success`, {
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
      toast.success(`Recover ${user?.username} user success`, {
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

  if (isLoading) return <Loading />;

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
            {user?.deleted_at ? (
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
              <img
                src={
                  user?.avatarUrl ||
                  "https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260"
                }
                alt=""
                className="itemImg"
              />
              <div className="details">
                <div className="coverWrapper">
                  <img className="coverImg" src={user?.coverUrl}></img>
                </div>
                <h1 className="itemTitle">{user?.fullname}</h1>
                <div className="detailItem" key={nanoid()}>
                  <span className="itemKey">Id:</span>
                  <span className="itemValue">{user?._id}</span>
                </div>
                <div className="detailItem" key={nanoid()}>
                  <span className="itemKey">Username:</span>
                  <span className="itemValue">{user?.username}</span>
                </div>
                <div className="detailItem" key={nanoid()}>
                  <span className="itemKey">Email:</span>
                  <span className="itemValue">{user?.email}</span>
                </div>
                <div className="detailItem" key={nanoid()}>
                  <span className="itemKey">Phone:</span>
                  <span className="itemValue">{user?.phone}</span>
                </div>
                <div className="detailItem" key={nanoid()}>
                  <span className="itemKey">Description:</span>
                  <span className="itemValue">{user?.contact_info?.bio}</span>
                </div>
                <div className="detailItem" key={nanoid()}>
                  <span className="itemKey">Address:</span>
                  <span className="itemValue">
                    {user?.contact_info?.address}
                  </span>
                </div>
                <div className="detailItem" key={nanoid()}>
                  <span className="itemKey">Birthday:</span>
                  <span className="itemValue">
                    {formatDate(user?.birthday)}
                  </span>
                </div>
                <div className="detailItem" key={nanoid()}>
                  <span className="itemKey">Join at:</span>
                  <span className="itemValue">
                    {formatDate(user?.created_date)}
                  </span>
                </div>
                <div className="detailItem" key={nanoid()}>
                  <span className="itemKey">Update at:</span>
                  <span className="itemValue">
                    {formatDate(user?.updated_at)}
                  </span>
                </div>
                <div className="detailItem" key={nanoid()}>
                  <span className="itemKey">Last online:</span>
                  <span className="itemValue">
                    {formatDate(user?.last_online)}
                  </span>
                </div>
                <div className="detailItem" key={nanoid()}>
                  <span className="itemKey">Status:</span>
                  <span className="itemValue">{user?.status}</span>
                </div>
                <div className="detailItem" key={nanoid()}>
                  <span className="itemKey">Deleted at:</span>
                  <span className="itemValue">
                    {formatDate(user?.deleted_at)}
                  </span>
                </div>
              </div>
            </div>
          </div>
          <div className="right">
            <Chart
              aspect={4 / 2}
              title="User chat in 6 month"
              data={chatData?.data}
            />
          </div>
        </div>
        {/* <div className="bottom">
          <h1 className="title">Last Post</h1>
          {postIsLoading ? "" : posts.data.map((post) => <div>{post._id}</div>)}
        </div> */}
      </div>
    </div>
  );
};

export default UserDetail;

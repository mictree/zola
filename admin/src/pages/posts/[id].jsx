import "./new.scss";
import { useEffect, useState } from "react";
import { postInputs } from "../../formSource";
import { useParams } from "react-router-dom";
import { usePostDetail } from "../../hooks/usePost";
import Loading from "../../components/Loading";
import { ToastContainer } from "react-toastify";
import FavoriteIcon from "@mui/icons-material/Favorite";
import CommentIcon from "@mui/icons-material/Comment";
import { Button, ImageList, ImageListItem } from "@mui/material";
import PostItem from "../../components/postItem/PostItem";
import UserItem from "../../components/userItem";
import { nanoid } from "nanoid";
import { formatDate } from "../../utils/fmt";
import "react-toastify/dist/ReactToastify.css";

const PostDetail = () => {
  const { id } = useParams();
  const { data, isLoading } = usePostDetail(id);


  const inputs = postInputs;
  const post = data?.data;

  

  // console.log({...post?.originPost});
  const title = "Post";
  return (
    <div className="new">
      {isLoading ? (
        <Loading />
      ) : (
        <div className="newContainer">
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
          <div className="top">
            <h1>{(post?.title || title) + ` - ID#${post?._id}`}</h1>
          </div>
          <div className="bottom">
            <div className="left">
              <div className="postInfo">
                <div className="formInput">
                  <input
                    type="file"
                    id="file"
                    onChange={(e) => {
                      setFileRaw(e.target.files[0]);
                      setFile(URL.createObjectURL(e.target.files[0]));
                    }}
                    style={{ display: "none" }}
                  />
                </div>

                <div className="formInput">
                  <label>Author: </label>
                  <div className="infoContent">
                    <UserItem
                      key={nanoid()}
                      _id={post.author._id}
                      username={post.author.username}
                      avatarUrl={post.author.avatarUrl}
                    />
                  </div>
                </div>

                {inputs.map((input) => (
                  <div className="formInput" key={input.id}>
                    <label>{input.label}:</label>
                    <div className="infoContent">
                      {["created_at", "deleted_at", "updated_at"].includes(
                        input.value
                      )
                        ? formatDate(post[input.value])
                        : post[input.value]}
                    </div>
                  </div>
                ))}
              </div>
            </div>
            <div className="right">
              <div className="postContent">
                <h1>Content</h1>
                <div className="mainContent">{post.content}</div>
                {/* <img
                  className="book-image"
                  src={post?.attach_files[0]?.url}
                  alt=""
                /> */}
                {post?.attach_files ? (
                  <ImageList
                    // sx={{}}
                    cols={4}
                    rowHeight={150}
                  >
                    {post?.attach_files.map((item) => (
                      <ImageListItem key={item.url}>
{                        {'image' :<img
                          style={{ maxHeight: "150px" }}
                          src={`${item.url}?w=164&h=164&fit=crop&auto=format`}
                          srcSet={`${item.url}?w=164&h=164&fit=crop&auto=format&dpr=2 2x`}
                          loading="lazy"
                        />,
                        'video':
                        <video src={item.url} controls style={{maxHeight: "150px"}}>
                        </video>}[item.resource_type]}
                      </ImageListItem>
                    ))}
                  </ImageList>
                ) : (
                  ""
                )}
              </div>

              <div className="interact-info">
                <div>
                  <FavoriteIcon className="favorite-icon" />
                  <span>{data.metaData.like}</span>
                </div>
                <div>
                  <CommentIcon className="comment-icon" />
                  <span>{data.metaData.comment}</span>
                </div>
              </div>

              {post?.originPost ? (
                <div className="postOrigin">
                  <label>Origin Post: </label>
                  <PostItem
                    key={post?._id}
                    _id={post?.originPost._id}
                    content={post?.originPost.content}
                    attach_files={post?.originPost.attach_files}
                    created_at={post?.originPost.created_at}
                    author={post?.originPost.author}
                  />
                </div>
              ) : (
                ""
              )}
            </div>
            <div></div>
          </div>

          <div className="button-wrapper">
            <button className="send-button">Recover</button>
            <Button className="delete-button">Delete</Button>
          </div>
        </div>
      )}
    </div>
  );
};

export default PostDetail;

import "./list.scss";
import { useMutation } from "@tanstack/react-query";
import DatatableTemplate from "../../components/datatableTemplate/DatatableTemplate";
import CircularProgress from "@mui/material/CircularProgress";
import Box from "@mui/material/Box";
import { useEffect, useState } from "react";
import {
  postActionColumn,
  postColumns,
} from "../../constants/column/postColumn";
import { usePost } from "../../hooks/usePost";
import postService from "../../services/postService";
import { Pagination } from "@mui/material";
const Posts = () => {
  const [page, setPage] = useState(1);
  const [totalPage, setTotalPage] = useState(1);
  // const [data, setData] = useState()
  const { data: posts, isLoading, isFetching, refetch: fetchPost } = usePost(page);

  useEffect(() => {
    document.title = "Posts - Admin";
  }, []);

  useEffect(() => {
    setTotalPage(posts?.paginate?.totalPage || 1);
  }, [posts]);

  const onPageChange = (event, value) => setPage(value);

  const deletePostMutation = useMutation({
    mutationFn: (id) => postService.deletePost(id),
  });

  const recoverMutation = useMutation({
    mutationFn: (id) => postService.recoverPost(id),
  });

  const hardDeleteMutation = useMutation({
    mutationFn: (id) => postService.hardDeletePost(id),
  });

  return (
    <>
      {isLoading ? (
        <Box
          sx={{
            display: "flex",
            justifyContent: "center",
            paddingTop: "200px",
          }}
        >
          <CircularProgress />
        </Box>
      ) : (
        <>
          <div className="listContainer">
            <DatatableTemplate
              title={"Posts"}
              addNew={false}
              dataRows={posts?.data}
              columns={postColumns}
              actionColumn={postActionColumn}
              deleteMutation={deletePostMutation}
              recoverMutation={recoverMutation}
              hardDeleteMutation={hardDeleteMutation}
              rowHeight={50}
              refetch={fetchPost}
              loading={isFetching}
            />
          </div>
          <div className="paginate-wrapper">
            <Pagination
              count={totalPage}
              variant="outlined"
              color="primary"
              onChange={onPageChange}
            />
          </div>
        </>
      )}
    </>
  );
};

export default Posts;

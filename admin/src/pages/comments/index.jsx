import "./list.scss";
import { useMutation } from "@tanstack/react-query";
import DatatableTemplate from "../../components/datatableTemplate/DatatableTemplate";
import CircularProgress from "@mui/material/CircularProgress";
import Box from "@mui/material/Box";
import { useEffect, useState } from "react";
import { Pagination } from "@mui/material";
import { useComment } from "../../hooks/useComment";
import {
  commentActionColumn,
  commentColumns,
} from "../../constants/column/commentColumn";
import commentService from "../../services/commentService";

const Comments = () => {
  const [page, setPage] = useState(1);
  const [totalPage, setTotalPage] = useState(1);

  const { data: users, isLoading, isFetching, refetch: fetchUser } = useComment(page);

  useEffect(() => {
    setTotalPage(users?.paginate?.totalPage || 1);
  }, [users]);

  const onPageChange = (event, value) => setPage(value);

  const deleteUserMutation = useMutation({
    mutationFn: (id) => commentService.deleteCommentById(id),
  });

  const recoverMutation = useMutation({
    mutationFn: (id) => commentService.recoverComment(id),
  });

  const hardDeleteMutation = useMutation({
    mutationFn: (id) => commentService.hardDeleteCommentById(id),
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
              addNew={false}
              dataRows={users?.data}
              columns={commentColumns}
              actionColumn={commentActionColumn}
              deleteMutation={deleteUserMutation}
              recoverMutation={recoverMutation}
              hardDeleteMutation={hardDeleteMutation}
              rowHeight={50}
              refetch={fetchUser}
              isLoading={isFetching}
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

export default Comments;

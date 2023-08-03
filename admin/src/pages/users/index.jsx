import "./list.scss";
import { useMutation } from "@tanstack/react-query";
import DatatableTemplate from "../../components/datatableTemplate/DatatableTemplate";
import CircularProgress from "@mui/material/CircularProgress";
import Box from "@mui/material/Box";
import userService from "../../services/userService";
import { useEffect, useState } from "react";
import {
  userColumns,
  userActionColumn,
} from "../../constants/column/userColumn";
import { Pagination } from "@mui/material";
import { useUser } from "../../hooks/useUser";
import { useSearchParams } from "react-router-dom";

const User = () => {
  const [page, setPage] = useState(1);
  const [totalPage, setTotalPage] = useState(1);

  const { data: users, isLoading, isFetching, refetch: fetchUser } = useUser(page);

	const [searchParams, setSearchParams] = useSearchParams()


  useEffect(() => {
    document.title = "Users - Admin";
  }, []);

  useEffect(() => {
    setTotalPage(users?.paginate?.totalPage || 1);
  }, [users]);

  const onPageChange = (event, value) => setPage(value);

  const deleteUserMutation = useMutation({
    mutationFn: (id) => userService.deleteUser(id),
  });

  const recoverMutation = useMutation({
    mutationFn: (id) => userService.recoverUser(id),
  });

  const hardDeleteMutation = useMutation({
    mutationFn: (id) => userService.hardDeleteUser(id),
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
              columns={userColumns}
              actionColumn={userActionColumn}
              deleteMutation={deleteUserMutation}
              recoverMutation={recoverMutation}
              hardDeleteMutation={hardDeleteMutation}
              rowHeight={50}
              refetch={fetchUser}
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

export default User;

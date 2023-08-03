import "./list.scss";
import { useMutation, useQuery } from "@tanstack/react-query";
import DatatableTemplate from "../../components/datatableTemplate/DatatableTemplate";
import CircularProgress from "@mui/material/CircularProgress";
import Box from "@mui/material/Box";
import userService from "../../services/userService";
import { useEffect, useState } from "react";
import {
  roomColumns,
  roomActionColumn,
} from "../../constants/column/roomColumn";
import { Pagination } from "@mui/material";
import { useRecoverRoom, useRoom } from "../../hooks/useRoom";
import roomService from "../../services/roomService";

const Rooms = () => {
  const [page, setPage] = useState(1);
  const [totalPage, setTotalPage] = useState(1);

  const { data: rooms, isLoading, isFetching, refetch: fetchRoom } = useRoom(page);

  useEffect(() => {
    document.title = "Room - Admin";
  }, []);

  useEffect(() => {
    setTotalPage(rooms?.paginate?.totalPage || 1);
  }, [rooms]);

  const onPageChange = (event, value) => setPage(value);

  const deleteUserMutation = useMutation({
    mutationFn: (id) => roomService.deleteRoomById(id),
  });

  const recoverMutation = useMutation({
    mutationFn: (id) => roomService.recoverRoom(id),
  });

  const hardDeleteMutation = useMutation({
    mutationFn: (id) => roomService.hardDeleteRoomById(id),
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
              dataRows={rooms?.data}
              columns={roomColumns}
              actionColumn={roomActionColumn}
              deleteMutation={deleteUserMutation}
              recoverMutation={recoverMutation}
              hardDeleteMutation={hardDeleteMutation}
              rowHeight={50}
              refetch={fetchRoom}
              addNew={false}
              // loading={isFetching}
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

export default Rooms;

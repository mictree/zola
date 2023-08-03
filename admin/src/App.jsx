import Home from "./pages/home/Home";
import Login from "./pages/login/Login";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import "./style/dark.scss";
import { useContext } from "react";
import { DarkModeContext } from "./context/darkModeContext";
import MainLayout from "./layout/MainLayout";
import { POST_DETAIL_PATH, POST_PATH, HOME_PATH, USER_DETAIL_PATH, USER_PATH, ROOM_PATH, ROOM_DETAIL_PATH, COMMENT_PATH } from "./constants/path";
import User from "./pages/users";
import Posts from "./pages/posts";
import PostDetail from "./pages/posts/[id]";
import UserDetail from "./pages/users/[id]";
import RoomsDetail from "./pages/rooms/[id]";
import NewUser from "./pages/users/new";
import Rooms from "./pages/rooms";
import Comments from "./pages/comments";

function App() {
  const { darkMode } = useContext(DarkModeContext);
  
  return (
    <div className={darkMode ? "app dark" : "app"}>
      <BrowserRouter>
        <Routes>
          <Route path="login" element={<Login />} />
          <Route element={
            
              <MainLayout/> 
            
            } >
            <Route path={HOME_PATH} element={<Home />} />
            <Route path={USER_PATH}>
              <Route index element={<User />} />
              <Route path={USER_DETAIL_PATH} element={<UserDetail />} />
              <Route
                path="new"
                element={<NewUser />}
              />
            </Route>

            <Route path={POST_PATH}>
              <Route index element={<Posts />} />
              <Route path={POST_DETAIL_PATH} element={<PostDetail />} />
            </Route>

            <Route path={ROOM_PATH}>
              <Route index element={<Rooms />} />
              <Route path={ROOM_DETAIL_PATH} element={<RoomsDetail />} />
            </Route>

            <Route path={COMMENT_PATH}>
              <Route index element={<Comments />} />
            </Route>

          </Route>
      </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;

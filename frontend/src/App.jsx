import { BrowserRouter, Routes, Route } from "react-router-dom";
import Home from "./pages/Home";
import Register from "./pages/Register";
import Login from "./pages/Login";
import UploadSong from "./pages/UploadSong";
import AdminRoute from "./components/AdminRoute";
import ProtectedRoute from "./components/ProtectedRoute";
import Layout from "./components/Layout";
import Playlists from "./pages/Playlists";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />

        <Route
          path="/"
        >
          <Route index element={<Home />} />
        </Route>

        <Route
          path="/"
          element={
            <ProtectedRoute>
              <Layout />
            </ProtectedRoute>
          }
        >
          <Route path="playlists" element={<Playlists />} />
        </Route>

        <Route
          path="/upload"
          element={
            <ProtectedRoute>
              <AdminRoute>
                <Layout />
                <UploadSong />
              </AdminRoute>
            </ProtectedRoute>
          }
        />

      </Routes>
    </BrowserRouter>
  );
}

export default App;

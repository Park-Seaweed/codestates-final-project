import React from "react";
import { Route, Routes } from "react-router-dom";
import AddPage from "../pages/AddPage";
import DetailPage from "../pages/DetailPage";
import MainPage from "../pages/MainPage";

const Router = () => {
    return (
        <Routes>
            <Route path="/" element={<MainPage />} />
            <Route path="/add" element={<AddPage />} />
            <Route path="/detail" element={<DetailPage />} />
        </Routes>
    )
}

export default Router
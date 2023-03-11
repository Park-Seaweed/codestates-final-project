import React from "react";
import { Route, Routes } from "react-router-dom";
import AddPage from "../pages/AddPage";
import MainPage from "../pages/MainPage";

const Router = () => {
    return (
        <Routes>
            <Route path="/" element={<MainPage />} />
            <Route path="/add" element={<AddPage />} />
        </Routes>
    )
}

export default Router
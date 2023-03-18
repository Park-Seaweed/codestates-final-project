import React from 'react';
import { Route, Routes } from 'react-router-dom';
import AddPage from '../pages/AddPage';
import DetailPage from '../pages/DetailPage';
import MainPage from '../pages/MainPage';
import SignInPage from '../pages/SignInPage';
import SignUpPage from '../pages/SignUpPage';
import VerifyPage from '../pages/VerifyPage';

const Router = () => {
  return (
    <Routes>
      <Route path='/' element={<MainPage />} />
      <Route path='/add' element={<AddPage />} />
      <Route path='/detail' element={<DetailPage />} />
      <Route path='/detail/:id' element={<DetailPage />} />
      <Route path='/signin' element={<SignInPage />} />
      <Route path='/signup' element={<SignUpPage />} />
      <Route path='/verify' element={<VerifyPage />} />
    </Routes>
  );
};

export default Router;

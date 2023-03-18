import React, { useEffect } from 'react';
import { Route, Routes, useNavigate, useLocation } from 'react-router-dom';

import SignInPage from '../pages/SignInPage';
import SignUpPage from '../pages/SignUpPage';
import AddPage from '../pages/AddPage';
import DetailPage from '../pages/DetailPage';
import MainPage from '../pages/MainPage';
import VerifyPage from '../pages/VerifyPage';

const Router = () => {
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    const isLoginRequired =
      !localStorage.getItem('accessToken') &&
      !location.pathname.startsWith('/signup') &&
      !location.pathname.startsWith('/verify');

    if (isLoginRequired) {
      navigate('/signin');
    }
  }, [location.pathname, navigate]);
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

import React from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';

import { userApi } from '../api/userApi';

const Header = () => {
  const navigate = useNavigate();

  const handleLogout = async () => {
    const config = {
      headers: {
        'Content-Type': 'application/json',
        Authorization: localStorage.getItem('accessToken'),
      },
    };

    try {
      const res = await userApi.signOut(config);
      localStorage.removeItem('accessToken');
      console.log(res);
      navigate(`/signin`);
    } catch (error) {
      console.log(error);
    }
  };

  return (
    <StHeader>
      <button type='button' onClick={handleLogout}>
        로그아웃
      </button>
    </StHeader>
  );
};

export default Header;

const StHeader = styled.div`
  width: 100%;
  height: 70px;
  display: flex;
  justify-content: flex-end;
  align-items: center;

  > button {
    color: #ffbc3f;
    background-color: white;
    font-weight: bold;
    cursor: pointer;
    border: none;
  }
`;

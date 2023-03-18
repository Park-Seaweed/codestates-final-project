import React from 'react';
import styled from 'styled-components';

const Header = () => {
  return (
    <StHeader>
      <button type='button'>로그아웃</button>
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

import React from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';

const MainTable = ({ data }) => {
  const navigate = useNavigate();

  if (data) {
    return (
      <>
        <StTable>
          <thead>
            <tr>
              <StTh>번호</StTh>
              <StTh>제목</StTh>
              <StTh>작성자</StTh>
              <StTh>작성 시간</StTh>
            </tr>
          </thead>
          <tbody>
            {data.map((item) => {
              return (
                <StTr
                  key={item.id}
                  onClick={() => navigate(`/detail/${item.id}`)}
                >
                  <StTd>{item.id}</StTd>
                  <StTd>{item.title}</StTd>
                  <StTd>{item.user_nickname}</StTd>
                  <StTd>{item.created_at}</StTd>
                </StTr>
              );
            })}
          </tbody>
        </StTable>
      </>
    );
  }
};

export default MainTable;

const StTable = styled.table`
  border-collapse: collapse;
  margin: 0 0 20px 0;
  text-align: center;
  border-radius: 24px;
  box-shadow: rgba(0, 0, 0, 0.2) 0 3px 5px -1px,
    rgba(0, 0, 0, 0.14) 0 6px 10px 0, rgba(0, 0, 0, 0.12) 0 1px 18px 0;
  overflow: hidden;
  width: 850px;
`;

const StTh = styled.th`
  border-bottom: 1px solid #ddd;
  background-color: #ffbc3f;
  font-weight: bold;
  padding: 1rem;
  color: white;

  &:first-child {
    width: 10px;
  }
  &:nth-child(2) {
    width: 450px;
  }
  &:nth-child(3) {
    width: 100px;
  }
  &:last-child {
    width: auto;
  }
`;

const StTr = styled.tr`
  height: 55px;
`;

const StTd = styled.td`
  border-top: 1px solid #ddd;
  padding: 0 2rem;

  &:nth-child(2) {
    text-align: left;
  }
`;

import React, { useState } from 'react';
import MainTable from '../components/MainTable';
import { useNavigate } from 'react-router-dom';
import { useQuery } from 'react-query';
import styled from 'styled-components';
import { articleApi } from '../api/articleApi';
import Pagination from '../components/Pagination';

const MainPage = () => {
  const navigate = useNavigate();

  const Articles = useQuery('article_list', articleApi.getArticles, {
    onSuccess: (data) => {
      console.log(data.data);
    },
  });

  const [currentPage, setCurrentPage] = useState(1);
  const postsPerPage = 10;

  const indexOfLast = currentPage * postsPerPage;
  const indexOfFirst = indexOfLast - postsPerPage;
  const currentPosts = Articles?.data?.data
    .slice()
    .reverse()
    .slice(indexOfFirst, indexOfLast);

  const onClickAddHandler = () => {
    navigate(`/add`);
  };
  return (
    <div>
      <MainTable data={currentPosts} />
      <Bottom>
        <Pagination
          postsPerPage={postsPerPage}
          totalPosts={Articles?.data?.data.length}
          paginate={setCurrentPage}
        />
        <StButton onClick={onClickAddHandler} type='button'>
          글쓰기
        </StButton>
      </Bottom>
    </div>
  );
};

export default MainPage;

const StButton = styled.button`
  position: absolute;
  top: 50%;
  transform: translate(0%, -50%);
  border: none;
  padding: 10px 20px;
  background-color: #ffbc3f;
  color: white;
  font-weight: bold;
  border-radius: 15px;
  box-shadow: rgba(0, 0, 0, 0.2) 0 3px 5px -1px,
    rgba(0, 0, 0, 0.14) 0 6px 10px 0, rgba(0, 0, 0, 0.12) 0 1px 18px 0;
  cursor: pointer;
`;

const Bottom = styled.div`
  position: relative;
`;

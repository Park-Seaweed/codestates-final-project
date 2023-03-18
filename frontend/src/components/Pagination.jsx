import React, { useState } from 'react';
import styled from 'styled-components';

const Pagination = ({ postsPerPage, totalPosts, paginate }) => {
  const [currentPage, setCurrentPage] = useState(1);
  const pageNumbers = [];

  for (let i = 1; i <= Math.ceil(totalPosts / postsPerPage); i++) {
    pageNumbers.push(i);
  }

  const handleClick = (pageNumber) => {
    setCurrentPage(pageNumber);
    paginate(pageNumber);
  };

  const getPageNumbers = () => {
    const maxPageNumbers = 5;
    const halfPageNumbers = Math.floor(maxPageNumbers / 2);
    let startPage;
    let endPage;
    if (pageNumbers.length <= maxPageNumbers) {
      startPage = 1;
      endPage = pageNumbers.length;
    } else if (currentPage <= halfPageNumbers) {
      startPage = 1;
      endPage = maxPageNumbers;
    } else if (currentPage >= pageNumbers.length - halfPageNumbers) {
      startPage = pageNumbers.length - maxPageNumbers + 1;
      endPage = pageNumbers.length;
    } else {
      startPage = currentPage - halfPageNumbers;
      endPage = currentPage + halfPageNumbers;
    }

    const pages = [];
    for (let i = startPage; i <= endPage; i++) {
      pages.push(i);
    }
    return pages;
  };

  return (
    <StPaganation>
      <ul>
        <li>
          <button
            type='button'
            onClick={() => handleClick(1)}
            disabled={currentPage === 1}
          >
            &lt;&lt;
          </button>
        </li>
        <li>
          <button
            type='button'
            onClick={() =>
              handleClick(currentPage > 1 ? currentPage - 1 : currentPage)
            }
            disabled={currentPage === 1}
          >
            &lt;
          </button>
        </li>
        {getPageNumbers().map((number) => (
          <li
            key={number}
            className={`page-item ${currentPage === number ? 'active' : ''}`}
          >
            <button
              type='button'
              onClick={() => {
                handleClick(number);
              }}
              className='page-link'
            >
              {number}
            </button>
          </li>
        ))}
        <li>
          <button
            type='button'
            onClick={() =>
              handleClick(
                currentPage < pageNumbers.length ? currentPage + 1 : currentPage
              )
            }
            disabled={currentPage === pageNumbers.length}
          >
            &gt;
          </button>
        </li>
        <li>
          <button
            type='button'
            onClick={() => handleClick(pageNumbers.length)}
            disabled={currentPage === pageNumbers.length}
          >
            &gt;&gt;
          </button>
        </li>
      </ul>
    </StPaganation>
  );
};

export default Pagination;

const StPaganation = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;

  ul {
    width: 100%;
    list-style: none;
    display: flex;
    justify-content: center;
    align-items: center;

    li {
      button {
        border: none;
        background-color: transparent;
        color: #333;
        padding: 0.5rem 1rem;
        cursor: pointer;
        transition: all 0.2s;
        font-size: 1rem;

        &:hover,
        &:focus {
          font-weight: bold;
        }
      }

      &.active {
        button {
          color: orange;

          &:hover,
          &:focus {
            color: orange;
            font-weight: bold;
          }
        }
      }
    }
  }
`;

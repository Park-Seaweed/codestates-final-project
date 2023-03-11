import React from "react";
import MainTable from "../components/MainTable";
import { useNavigate } from "react-router-dom";
import { useQuery } from 'react-query'
import styled from 'styled-components'
import { getArticles } from "../api/articleApi";


const MainPage = () => {
    const Articles = useQuery('article_list', getArticles, {
        onSuccess: (data) => {
            console.log(data.data);
        },
    });

    const navigate = useNavigate()
    const onClickAddHandler = () => {
        navigate(`/add`)
    }
    return (
        <>
            <MainTable data={Articles?.data?.data} />
            <StBottom>
                <StButton onClick={onClickAddHandler} type='button' >
                    글쓰기
                </StButton>
            </StBottom>
        </>

    )
}

export default MainPage


const StButton = styled.button`
    border: none;
    padding: 10px 20px;
    background-color: #ffbc3f;
    color: white;
    font-weight: bold;
    border-radius: 15px;
    box-shadow: rgba(0, 0, 0, 0.2) 0 3px 5px -1px,
    rgba(0, 0, 0, 0.14) 0 6px 10px 0, rgba(0, 0, 0, 0.12) 0 1px 18px 0;
`;

const StBottom = styled.div`
    width: 100%;
    margin-top: 30px;
`;
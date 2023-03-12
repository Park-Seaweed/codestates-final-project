import React, { useState } from "react";
import { useMutation, useQueryClient } from "react-query";
import { useNavigate } from "react-router-dom";
import styled from 'styled-components'
import { articleApi } from "../api/articleApi";

const AddPage = () => {
    const [title, setTitle] = useState("")
    const [content, setContent] = useState("")
    const navigate = useNavigate()
    const queryClient = useQueryClient()
    const addArticleMutation = useMutation(articleApi.addArticles, {
        onSuccess: (responseData) => {
            queryClient.invalidateQueries("article_list")
            setTitle("")
            setContent("")
            navigate(`/`)
        }
    })
    const onClickAddHandler = () => {
        if (title === "" || content === "") {
            return
        }
        const data = {
            title,
            content
        }
        addArticleMutation.mutate(data)

    }

    const handleMainClick = () => {
        navigate(`/`)
    }

    return (
        <div>
            <StTodoCard>
                <TitleInput
                    value={title}
                    onChange={(e) =>
                        setTitle(e.target.value)

                    }
                    placeholder='제목을 입력하세요.'
                />
                <ContentInput
                    onChange={(e) =>
                        setContent(e.target.value)
                    }
                    value={content}

                    placeholder='내용을 입력하세요.'
                />
            </StTodoCard>
            <StBottom>
                <div onClick={handleMainClick}>목록으로 돌아가기</div>
                <StButton onClick={onClickAddHandler} >등록</StButton>
            </StBottom>
        </div>
    );
}

export default AddPage


const StTodoCard = styled.div`
    display: flex;
    flex-direction: column;
    margin: 20px 0;
    border-radius: 20px;
    width: 620px;
    padding: 1rem;
    box-shadow: rgba(0, 0, 0, 0.2) 0 3px 5px -1px,
    rgba(0, 0, 0, 0.14) 0 6px 10px 0, rgba(0, 0, 0, 0.12) 0 1px 18px 0;
`;

const StBottom = styled.div`
    width: 100%;
    margin-top: 30px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    color: #ffbc3f;
    font-weight: bold;

    > p {
    cursor: pointer;
    }
`;

const TitleInput = styled.input`
    border: none;
    border-bottom: 1px solid #ffbc3f;
    padding: 15px;
    outline: none;
`;

const ContentInput = styled.textarea`
    border: none;
    padding: 15px;
    height: 200px;
    outline: none;
    resize: none;
`;

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
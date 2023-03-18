import React, { useState } from 'react';
import { useMutation, useQuery, useQueryClient } from 'react-query';
import { useNavigate, useParams } from 'react-router-dom';
import styled from 'styled-components';
import { articleApi } from '../api/articleApi';
import Header from '../components/Header';

const DetailPage = () => {
  const queryClient = useQueryClient();
  const navigate = useNavigate();
  const param = useParams();

  const [isEditing, setIsEditing] = useState(false);
  const [editedTitle, setEditedTitle] = useState('');
  const [editedContent, setEditedContent] = useState('');

  const Articles = useQuery('article_list', articleApi.getArticles, {
    onSuccess: (data) => {
      console.log(data.data);
    },
  });

  const handleMainClick = () => {
    navigate(`/`);
  };

  const oneArticle = Articles?.data?.data?.find(
    (a) => a.id === parseInt(param.id)
  );

  const deleteArticleMutation = useMutation(articleApi.deleteArticles, {
    onSuccess: () => {
      queryClient.invalidateQueries('article_list');
      navigate(`/`);
    },
    onError: () => {
      alert('본인이 쓴 게시글만 삭제할 수 있습니다.');
    },
  });

  const editArticleMutation = useMutation(articleApi.updateArticles, {
    onSuccess: () => {
      queryClient.invalidateQueries('article_list');
      setIsEditing(false);
      navigate(`/`);
    },
  });

  const handleClick = (e) => {
    e.preventDefault();
    editArticleMutation.mutate({
      id: oneArticle.id,
      title: editedTitle || oneArticle.title,
      content: editedContent || oneArticle.content,
    });
  };

  return (
    <div>
      <Header />
      <StContentBox>
        {isEditing ? (
          <Form>
            <TitleInput
              type='text'
              value={editedTitle || oneArticle?.title}
              onChange={(e) => setEditedTitle(e.target.value)}
            />
            <ContentInput
              value={editedContent || oneArticle?.content}
              onChange={(e) => setEditedContent(e.target.value)}
            />
          </Form>
        ) : (
          <>
            <TitleBox>
              <h3>{oneArticle?.title}</h3>
              <p>{oneArticle?.user_nickname}</p>
            </TitleBox>
            <p>{oneArticle?.content}</p>
          </>
        )}
      </StContentBox>
      <StBottom>
        <div onClick={handleMainClick}>목록으로 돌아가기</div>
        <div>
          {isEditing ? (
            <StCancelButton
              onClick={() => {
                setIsEditing(false);
              }}
            >
              취소
            </StCancelButton>
          ) : (
            <StButton onClick={() => setIsEditing(true)}>수정</StButton>
          )}
          {isEditing ? (
            <StButton type='submit' onClick={handleClick}>
              완료
            </StButton>
          ) : (
            <StButton
              onClick={() => {
                deleteArticleMutation.mutate(oneArticle.id);
              }}
            >
              삭제
            </StButton>
          )}
        </div>
      </StBottom>
    </div>
  );
};

export default DetailPage;

const TitleBox = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #ffbc3f;
  padding: 0 1rem;
`;

const StContentBox = styled.div`
  margin: 0 0 20px 0;
  border-radius: 20px;
  width: 620px;
  padding: 1rem;
  box-shadow: rgba(0, 0, 0, 0.2) 0 3px 5px -1px,
    rgba(0, 0, 0, 0.14) 0 6px 10px 0, rgba(0, 0, 0, 0.12) 0 1px 18px 0;

  & > p {
    height: 200px;
    padding: 0 1rem;
  }
`;

const StBottom = styled.div`
  width: 100%;
  margin-top: 30px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #ffbc3f;
  font-weight: bold;

  > div {
    display: flex;
    gap: 15px;
  }

  > div:first-child {
    cursor: pointer;
  }
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
  cursor: pointer;
`;

const StCancelButton = styled.button`
  background-color: white;
  border: 2px solid #ffbc3f;
  padding: 10px 20px;
  color: #ffbc3f;
  font-weight: bold;
  border-radius: 15px;
  box-shadow: rgba(0, 0, 0, 0.2) 0 3px 5px -1px,
    rgba(0, 0, 0, 0.14) 0 6px 10px 0, rgba(0, 0, 0, 0.12) 0 1px 18px 0;
`;

const TitleInput = styled.input`
  border: none;
  border-bottom: 1px solid #ffbc3f;
  padding: 15px;
  outline: none;
`;

const Form = styled.form`
  display: flex;
  flex-direction: column;
`;

const ContentInput = styled.textarea`
  border: none;
  padding: 15px;
  height: 200px;
  outline: none;
  resize: none;
`;
